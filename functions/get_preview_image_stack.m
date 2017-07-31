function [pv_stk, tcount, median_val] = get_preview_image_stack(comp_meas, slide_length, meas)


if strcmp(meas.meas_type, 'hadamard+kron')
    tcount = 0;
    for kk=1:slide_length:(meas.M-meas.had_length+1)
        cmeas = comp_meas (kk-1+(1:meas.had_length), :);
        cmeas1 = 0*cmeas;
        cmeas1(meas.had_indx(kk-1+(1:meas.had_length)), :) = cmeas;
        
        pv_tmp = meas.had_mat'*cmeas1/(prod(meas.D)/2);
        pv_tmp = pv_tmp(meas.col_perm, :);
        tcount = tcount + 1;
        pv_stk(:,:,:,tcount) = reshape(pv_tmp, [meas.siz./meas.D meas.num_color]);
        
        median_val(tcount) = kk-1+floor(meas.had_length/2);
    end
end

if strcmp(meas.meas_type, 'hadamard+kron+repeat')
    tcount = 0;
    for kk=1:slide_length:(meas.M-meas.had_length+1)
        cmeas = comp_meas (kk-1+(1:meas.had_length), :);
        cmeas1 = 0*cmeas;
        cmeas1(meas.had_indx(kk-1+(1:meas.had_length)), :) = cmeas;
        
        pv_tmp = meas.had_mat'*cmeas1/(prod(meas.D)/2);
        pv_tmp = pv_tmp(meas.col_perm, :);
        tcount = tcount + 1;
        pv_stk(:,:,:,tcount) = reshape(pv_tmp, [meas.siz./meas.D meas.num_color]);
        
        median_val(tcount) = kk-1+floor(meas.had_length/2);
    end
end

if strcmp(meas.meas_type, 'RealData+Hmatrix+kron')
    tcount = 0;
    for kk=1:slide_length:(meas.M-meas.had_length+1)
        cmeas = comp_meas (kk-1+(1:meas.had_length), :);
        cmeas1 = 0*cmeas;
        cmeas1(meas.had_indx(kk-1+(1:meas.had_length)), :) = cmeas;
        
        hzero = find(meas.had_indx(kk-1+(1:meas.had_length)) == 1);
        
        
        pv_tmp = meas.inv_mat*cmeas1/(prod(meas.D)/2);
        pv_tmp = pv_tmp(meas.col_perm, :);
        pv_tmp(meas.col_perm ==1) = 0;
        
        tcount = tcount + 1;
        pv_stk(:,:,:,tcount) = reshape(pv_tmp, [meas.siz./meas.D meas.num_color]);
        
        median_val(tcount) = kk-1+floor(meas.had_length/2);
    end
end