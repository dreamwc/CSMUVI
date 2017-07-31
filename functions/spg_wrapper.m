function y = spg_wrapper(x, mode, A, At)

if (mode == 1)
    y = A(x);
end
if (mode == 2)
    y = At(x);
end

%   v = A(w,mode)   which returns  v = A *w  if mode == 1;
%                                  v = A'*w  if mode == 2. 
%   
%   X 