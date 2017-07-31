function comp_meas = forward_compressive_measurements(img, timlist, meas)

%OLD SLOW VERSION
% if strcmp(meas.meas_type, 'hadamard+kron')
%     comp_meas = zeros(length(timlist), meas.num_color);
%     for kk=1:length(timlist)
%         tim = timlist(kk);
%         fil = reshape(meas.kron_matrix(:,tim), meas.D);
%         
%         im_sm = imfilter(img, fil(end:-1:1, end:-1:1));
%         im_sm = im_sm(ceil(meas.D(1)/2):meas.D(1):end, ceil(meas.D(2)/2):meas.D(2):end, :);
%         
%         comp_meas(kk, :) = meas.had_mat(meas.had_indx(tim), meas.col_perm)*reshape(im_sm, [], meas.num_color);
%     end
% end

%FAST FAST VERSION
if strcmp(meas.meas_type, 'hadamard+kron')
    comp_meas = zeros(length(timlist), meas.num_color);
    img = reshape(img, [], meas.num_color);
    
    for kk=1:length(timlist)
        tim = timlist(kk);
        fil = reshape(meas.kron_matrix(:,tim), meas.D);
        
        hselec = meas.had_indx(timlist(kk));
        hvec = reshape(meas.had_mat(hselec, meas.col_perm), meas.siz./meas.D);
        
        
        mVec = kron(hvec, fil(end:-1:1, end:-1:1));
        
        for qq=1:meas.num_color
            comp_meas(kk, qq) = mVec(:)'*img(:,qq);
        end
    end
end


if strcmp(meas.meas_type, 'hadamard+kron+repeat')
    comp_meas = zeros(length(timlist), meas.num_color);
    kk = 1;
    while (kk <= length(timlist))
        tim = timlist(kk);
        kron_tim = ceil(tim/meas.rep_num);
        fil = reshape(meas.kron_matrix(:,kron_tim), meas.D);
        
        im_sm = imfilter(img, fil(end:-1:1, end:-1:1));
        im_sm = im_sm(ceil(meas.D(1)/2):meas.D(1):end, ceil(meas.D(2)/2):meas.D(2):end, :);
        
        kron_span = tim:min(timlist(end), kron_tim*meas.rep_num);
        comp_meas(kk-1+(1:length(kron_span)), :) = meas.had_mat(meas.had_indx(kron_span), meas.col_perm)*reshape(im_sm, [], meas.num_color);
        
        kk = kk + length(kron_span);
    end
end

if strcmp(meas.meas_type, 'RealData+Smatrix+kron')
    comp_meas = zeros(length(timlist), meas.num_color);
    img = reshape(img, [], meas.num_color);
    
    for kk=1:length(timlist)
        tim = timlist(kk);
        fil = reshape(meas.kron_matrix(:,tim), meas.D);
        
        hselec = meas.had_indx(timlist(kk));
        hvec = reshape(meas.had_mat(hselec, meas.col_perm), meas.siz./meas.D);
        
        
        mVec = kron(hvec, fil(end:-1:1, end:-1:1));
        
        for qq=1:meas.num_color
            comp_meas(kk, qq) = mVec(:)'*img(:,qq);
        end
    end
end


