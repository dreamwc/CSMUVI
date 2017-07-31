function s = reverseAMatrix_Oflow_img(yvec, wave, meas, OfStk, med_length, of_cons_len)

num_color = meas.num_color;
ocount = length(OfStk);

yy = reshape(yvec(1:meas.M*num_color), [], num_color);
tcount = length(med_length);

ovec = yvec( num_color*meas.M+1:end);

xMat_y = zeros(prod(wave.siz), num_color, tcount);
xMat_o = zeros(prod(wave.siz), num_color, tcount);

assignment = floor((med_length(1:end-1)+med_length(2:end))/2);
assignment = [0 assignment meas.M ];

parfor qq=1:tcount

    timlist = (assignment(qq)+1):assignment(qq+1);
    comp_meas = yy(timlist, :);
    junk = reverse_compressive_measurements(comp_meas, timlist, meas);
    xMat_y(:,:, qq) = reshape(junk, prod(wave.siz), num_color);
    
end

qCount = 0;
for kk=1:ocount
    i1 = OfStk{kk}.sImg;
    i2 = OfStk{kk}.dImg;
    Fmat1 = OfStk{kk}.Fmat1;
    Fmat2 = OfStk{kk}.Fmat2;
    for qq=1:num_color
        b = ovec(qCount+(1:size(Fmat1, 1)));
        qCount = qCount+size(Fmat1, 1);
        
        xMat_o(:, qq, i1) = xMat_o(:, qq, i1) + Fmat1'*b;
        xMat_o(:, qq, i2) = xMat_o(:, qq, i2) - Fmat2'*b;
    end
    
end

if (qCount ~= of_cons_len)
    disp('Error');
    keyboard
end


xMat = xMat_y + xMat_o;

sMat = 0*xMat;
for kk=1:tcount
    for ee=1:num_color
        tmp = wavedec2(reshape(xMat(:, ee, kk), wave.siz), wave.level, wave.name);
        sMat(:, ee, kk) = tmp(:);
    end
end

s = sMat(:);

