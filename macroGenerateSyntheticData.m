clear all
close all

addpath('functions');


num_images = 2048;
folder = 'C:\Users\as48\work\data\highspeed\CardAndMonster_LowRes\';
imlist = dir(folder); imlist = imlist(3:end);
imlist = imlist(2048+(1:num_images));

siz = [128 128]; %[256 256];
M = prod(siz); %256*256;
num_color = 3;

meas_type = 'hadamard+kron+repeat'; %'hadamard+kron';
D = [4 4];


%%%Create structures
grtr.type = 'imagefolder';
grtr.folder = folder;
grtr.num_images = length(imlist);
grtr.image_names = imlist;
grtr.num_color = num_color;
grtr.meas_per_frame = ceil(M/num_images);
grtr.num_images = num_images;

meas.meas_type = meas_type;
meas.siz = siz;
meas.D = D;
meas.M = grtr.meas_per_frame*num_images;
M = meas.M;
meas.num_color = num_color;

opt = [];
if strcmp(meas_type, 'hadamard+kron+repeat')
    opt.rep_num = min(32, grtr.meas_per_frame);
end

meas = create_measurement_structure(meas, opt);

%%%%obtain compressive measurements
zmeas = zeros(grtr.meas_per_frame, grtr.num_color, grtr.num_images);
parfor kk=1:grtr.num_images
    if strcmp(grtr.type, 'imagefolder')
        img = imread([grtr.folder grtr.image_names(kk).name]);
        img = double(img)/255;
        img = imresize(img, meas.siz, 'bilinear');
%         if mod(kk, 100) == 0
%             imshow(img); drawnow
%         end
        if grtr.num_color == 1
            img = mean(img, 3);
        end
    end
    
    timlist = (kk-1)*grtr.meas_per_frame + (1:grtr.meas_per_frame);
    ztmp = forward_compressive_measurements(img, timlist, meas);
    
    zmeas(:,:,kk) = ztmp;
    
end
zmeas = permute(zmeas,[1 3 2]);
comp_meas = reshape(zmeas, [], meas.num_color);


%%%check preview
slide_length = meas.had_length/2;
[pv_stk, tcount] = get_preview_image_stack(comp_meas, slide_length, meas);
montage(pv_stk)

%%%SAVE COMMAND
%save vanilla_had_kron.mat comp_meas meas grtr

