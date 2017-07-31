function meas = create_measurement_structure(meas, opt)
siz = meas.siz;
D = meas.D;

if strcmp(meas.meas_type, 'hadamard+kron')
    meas.had_length = prod(siz./D);
    meas.had_siz = siz./D;
    
    meas.col_perm = randperm(meas.had_length);
    meas.had_mat = hadamard(meas.had_length)/sqrt(meas.had_length);
    
    had_indx = randperm(meas.had_length);
    had_indx = repmat(had_indx(:), ceil(meas.M/meas.had_length), 1);
    meas.had_indx = had_indx(1:meas.M);
    
    meas.kron_matrix = zeros(prod(D), meas.M);
    for kk=1:meas.M
        fil = -ones(D);
        tmp = randperm(prod(D));
        tmp = tmp(1:ceil(length(tmp)*3/4));
        fil(tmp) = 1;
        meas.kron_matrix(:, kk) = fil(:);
    end
end

if strcmp(meas.meas_type, 'hadamard+kron+repeat')
    meas.had_length = prod(siz./D);
    meas.had_siz = siz./D;
    
    meas.col_perm = randperm(meas.had_length);
    meas.had_mat = hadamard(meas.had_length)/sqrt(meas.had_length);
    
    had_indx = randperm(meas.had_length);
    had_indx = repmat(had_indx(:), ceil(meas.M/meas.had_length), 1);
    meas.had_indx = had_indx(1:meas.M);
    
    meas.rep_num = opt.rep_num;
    meas.kron_num = ceil(meas.M/opt.rep_num);
    meas.kron_matrix = zeros(prod(D), meas.kron_num);
    
    for kk=1:meas.kron_num
        fil = -ones(D);
        tmp = randperm(prod(D));
        tmp = tmp(1:ceil(length(tmp)*3/4));
        fil(tmp) = 1;
        meas.kron_matrix(:, kk) = fil(:);
    end
end

