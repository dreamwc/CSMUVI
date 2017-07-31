function yvec = forwardAMatrix_Oflow_img(s, wave, meas, OfStk, med_length, of_cons_len)

ocount = length(OfStk);
num_color = meas.num_color;

sMat= reshape(s, prod(wave.siz), num_color, []);
tcount = size(sMat, 3);

xMat= 0*sMat;

%wavelet to image space
for kk=1:tcount
    for qq=1:num_color
        tmp = waverec2(squeeze(sMat(:, qq, kk)), wave.Cbook, wave.name);
        xMat(:, qq, kk) = tmp(:);
    end
end



assignment = floor((med_length(1:end-1)+med_length(2:end))/2);
assignment = [0 assignment meas.M ];

parfor qq=1:tcount
    img = reshape(xMat(:, :, qq), [wave.siz num_color]);
    
    timlist = (assignment(qq)+1):assignment(qq+1);
    ztmp = forward_compressive_measurements(img, timlist, meas);
    
    ymeas{qq} = ztmp;
end

ynew = [];
for qq=1:tcount
    ynew = [ynew; ymeas{qq}];
end;

ovec = zeros(of_cons_len, 1);
qcount = 0;
for kk=1:ocount
    i1 = OfStk{kk}.sImg;
    i2 = OfStk{kk}.dImg;
    Fmat1 = OfStk{kk}.Fmat1;
    Fmat2 = OfStk{kk}.Fmat2;
    for qq=1:num_color
        b = Fmat1*xMat(:, qq, i1)-Fmat2*xMat(:, qq, i2);
        ovec(qcount+(1:length(b))) =  b;
        qcount = qcount + length(b);
    end
end
if (qcount ~= of_cons_len)
    disp('Error');
    keyboard
end


yvec = [ ynew(:); ovec; ];