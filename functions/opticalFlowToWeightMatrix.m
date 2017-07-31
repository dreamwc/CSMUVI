function [Fmat1, Fmat2, idx] = opticalFlowToWeightMatrix(u, v, oFlag)

siz = size(u);

[X, Y] = meshgrid(1:siz(2), 1:siz(1));


Xu_f = floor(X+u);
Yv_f = floor(Y+v);

dx1 = X+u-Xu_f;
dy1 = Y+v-Yv_f;

w1 = (1-dx1).*(1-dy1);
w2 = (1-dx1).*dy1;
w3 = dx1.*(1-dy1);
w4 = dx1.*dy1;

of1 = (Xu_f < 1) | (Yv_f < 1) | (Xu_f >= siz(2)) | (Yv_f >= siz(1));

oFlag(find(of1)) = 0;
idx = find(oFlag);
idx = idx(:);

Fmat1 = sparse((1:length(idx))', idx, ones(length(idx),1), length(idx), prod(siz));
i2_idx = sub2ind(siz, Yv_f(idx), Xu_f(idx));
i2_idx = i2_idx(:);

Fmat2 = sparse( repmat((1:length(idx))', [4 1]), [i2_idx; i2_idx+1; i2_idx+siz(2); i2_idx+siz(2)+1], ...
        [ w1(idx); w2(idx); w3(idx); w4(idx)], length(idx), prod(siz));
    
