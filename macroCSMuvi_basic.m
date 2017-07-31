clear all
close all

%addpath(genpath('toolboxes'));
addpath('functions')

%load data
load data/car_mons/128/chocolate_had_kron_rep.mat

%KEY PARAMETER
%1 <= slide_length <= meas.had_length
%slide_length decides number of preview frames
%if slide_length is small. MORE frames. LESS motion blur. SLOW solving
%if slide_length is large. LESS frames. MORE motion blur. FAST solving
slide_length = meas.had_length/2;

%COMPUTE PREVIEW
[pv_stk, tcount, med_length] = get_preview_image_stack(comp_meas, slide_length, meas);
figure
montage(pv_stk); title('preview');
pause(1);
fprintf('Number of frames to recover: %d \n', tcount);


%COMPUTE OPTICAL FLOW STUFF
%num_of_window --- is the number of frames in forward and reverse time over
%                  which optical flow constraints are computed
opt.num_of_window = 4;
opt.start_indx = 1;
opt.hard_reset = 1; opt.hard_reset_val = .5;
opt.display = 1;
opt.verbose = 1;
opt.reverse = 0;
figure
[OfStk, ocount, OfAux] = getOpticalFlowConstraints(pv_stk, meas.siz, opt);

%FORM function handles
%wavelet
dwtmode('per');
wave.name = 'db4';
wave.level = 6;
wave.siz = [ meas.siz ];
[tmp, wave.Cbook] = wavedec2(randn(wave.siz), wave.level, wave.name);


of_cons_len = 0;
for kk=1:ocount
    of_cons_len = of_cons_len+meas.num_color*size(OfStk{kk}.Fmat1, 1);
end


funA = @(sss) forwardAMatrix_Oflow_img(sss, wave, meas, OfStk, med_length, of_cons_len);
funAT = @(yyy) reverseAMatrix_Oflow_img(yyy, wave, meas, OfStk, med_length, of_cons_len);

%%ADD NOISE HERE
comp_meas = comp_meas + randn(size(comp_meas))*std(comp_meas(:))/(1000);
zvec = [ comp_meas(:); zeros(of_cons_len,1)];


%SOLVE
funSpg = @(xx, mode) spg_wrapper(xx, mode, funA, funAT);
opt =  spgSetParms('iterations', 100);

[s,r,g,info] = spg_bpdn( funSpg, zvec, norm(zvec(:))/20, opt );

sMat = reshape(s, prod(wave.siz), meas.num_color, []);
xMat=0*sMat;
for kk=1:tcount
    for qq=1:meas.num_color
        tmp = waverec2(sMat(:, qq, kk), wave.Cbook, wave.name);
        xMat(:, qq, kk) = tmp(:);
    end
end

xMat = reshape(xMat, [wave.siz meas.num_color tcount]);
figure
montage(xMat);
implay(xMat)
