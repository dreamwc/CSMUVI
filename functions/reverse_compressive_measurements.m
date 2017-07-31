function img = reverse_compressive_measurements(comp_meas, timlist, meas)

if strcmp(meas.meas_type, 'hadamard+kron')
    
    img = zeros([meas.siz meas.num_color]);
    q_img = zeros([meas.siz meas.num_color]);

    for kk=1:length(timlist)
        hselec = meas.had_indx(timlist(kk));
        hvec = reshape(meas.had_mat(hselec, meas.col_perm), meas.siz./meas.D);
        
        fil = meas.kron_matrix(:, timlist(kk));
        fil = reshape(fil, meas.D);
        
        mVec = kron(hvec, fil(end:-1:1, end:-1:1));
        
        q_img = 0*q_img;
        for ee = 1:meas.num_color
            q_img(:, :, ee) =  mVec*comp_meas(kk, ee);
        end
        
        img = img+q_img;
    end
end

if strcmp(meas.meas_type, 'hadamard+kron+repeat')
    
    img = zeros([meas.siz meas.num_color]);
    q_img = zeros([meas.siz meas.num_color]);
    kk = 1;
    while (kk <= length(timlist))
        tim = timlist(kk);
        kron_tim = ceil(tim/meas.rep_num);
        fil = reshape(meas.kron_matrix(:,kron_tim), meas.D);
        
        kron_span = tim:min(timlist(end), kron_tim*meas.rep_num);
        img_sm = meas.had_mat(meas.had_indx(kron_span), meas.col_perm)'*comp_meas(kk-1+(1:length(kron_span)), :);
        img_sm = reshape(img_sm, [ meas.siz./meas.D meas.num_color]);
        
        q_img = 0*q_img;
        for ee = 1:meas.num_color
            q_img(:, :, ee) = kron( squeeze(img_sm(:,:,ee)),  fil(end:-1:1, end:-1:1));
        end
        
        img = img+q_img;
        kk = kk + length(kron_span);

    end
end

if strcmp(meas.meas_type, 'RealData+Smatrix+kron')
    
    img = zeros([meas.siz meas.num_color]);
    q_img = zeros([meas.siz meas.num_color]);

    for kk=1:length(timlist)
        hselec = meas.had_indx(timlist(kk));
        hvec = reshape(meas.had_mat(hselec, meas.col_perm), meas.siz./meas.D);
        
        fil = meas.kron_matrix(:, timlist(kk));
        fil = reshape(fil, meas.D);
        
        mVec = kron(hvec, fil(end:-1:1, end:-1:1));
        
        q_img = 0*q_img;
        for ee = 1:meas.num_color
            q_img(:, :, ee) =  mVec*comp_meas(kk, ee);
        end
        
        img = img+q_img;
    end
end
