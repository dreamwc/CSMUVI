function [OfStk, ocount, OfAux] = getOpticalFlowConstraints(pv_stk, siz, opt)


ocount = 0;
tcount = size(pv_stk, 4);

num_of_window = opt.num_of_window;
hard_reset = opt.hard_reset;
if (hard_reset)
    hard_reset_val = opt.hard_reset_val;
end


for kk=1:tcount-1
    for kk1=min(tcount, kk+opt.start_indx):min(tcount, kk+num_of_window)
        tic
        im1 = imresize(squeeze(pv_stk(:, :, :, kk)),   siz, 'bicubic');
        im2 = imresize(squeeze(pv_stk(:, :, :, kk1)),  siz, 'bicubic');
        
        
        
        % set optical flow parameters (see Coarse2FineTwoFrames.m for the definition of the parameters)
        alpha = 0.0375;    ratio = .75;        minWidth = 30;    nOuterFPIterations = 20;
        nInnerFPIterations = 1;   nCGIterations = 50;
        
        para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nCGIterations];
        
        %forward flow
        [u1, v1, warpI1] = Coarse2FineTwoFrames(im1,im2,para);

        %reverse flow
        [u2, v2, warpI2] = Coarse2FineTwoFrames(im2,im1,para);

        if (hard_reset)
            tflag = find(abs(u1)+abs(v1) < hard_reset_val);
            u1(tflag) = 0; v1(tflag) = 0;
            tflag = find(abs(u2)+abs(v2) < hard_reset_val);
            u2(tflag) = 0; v2(tflag) = 0;
        end 
        %smooth optical flow
        u1 = conv2(u1, ones(3,3)/9, 'same'); v1 = conv2(v1, ones(3,3)/9, 'same');
        u2 = conv2(u2, ones(3,3)/9, 'same'); v2 = conv2(v2, ones(3,3)/9, 'same');
        
        %detect flow drift by forward-backward stuff
        [X, Y] = meshgrid(1:size(im1, 2), 1:size(im1, 1));
        delx = u1+interp2(X, Y,  u2, X+u1, Y+v1, 'bilinear');
        dely = v1+interp2(X, Y,  v2, X+u1, Y+v1, 'bilinear');
        oFlag1 = (abs(delx)+abs(dely)) <  1;
        
        [Fmat1, Fmat2, idx] = opticalFlowToWeightMatrix(u1, v1, oFlag1);
        
        ocount = ocount + 1;
        
        OfStk{ocount}.sImg = kk;
        OfStk{ocount}.dImg = kk1;
        OfStk{ocount}.Fmat1 = Fmat1;
        OfStk{ocount}.Fmat2 = Fmat2;
        OfStk{ocount}.idx = idx;
        
        OfAux{ocount}.vx = u1;
        OfAux{ocount}.vy = v1;
        OfAux{ocount}.oFlag = oFlag1;
        
        if (opt.reverse)
            %do the same for reverse flow
            [X, Y] = meshgrid(1:size(im1, 2), 1:size(im1, 1));
            delx = u2+interp2(X, Y,  u1, X+u2, Y+v2, 'bilinear');
            dely = v2+interp2(X, Y,  v1, X+u2, Y+v2, 'bilinear');
            oFlag2 = (abs(delx)+abs(dely)) <  1;
            
            [Fmat1, Fmat2, idx] = opticalFlowToWeightMatrix(u2, v2, oFlag2);
            
            ocount = ocount + 1;
            
            OfStk{ocount}.sImg = kk1;
            OfStk{ocount}.dImg = kk;
            OfStk{ocount}.Fmat1 = Fmat1;
            OfStk{ocount}.Fmat2 = Fmat2;
            OfStk{ocount}.idx = idx;
            
            OfAux{ocount}.vx = u2;
            OfAux{ocount}.vy = v2;
            OfAux{ocount}.oFlag = oFlag2;
        end
        
        if (opt.display)
            subplot 221
            imshow([im1 warpI1]);
            subplot 223
            imshow([im2 warpI2]);
            
            subplot 222
            fl1(:,:,1) = u1; fl1(:,:,2) = v1;
            flow1 = flowToColor(fl1);
            fl1(:,:,1) = u2; fl1(:,:,2) = v2;
            flow2 = flowToColor(fl1);
            
            imshow([flow1 flow2])
            
            subplot 224
            if (opt.reverse)
                imshow([ oFlag1;oFlag2 ]);
            else
                imshow(oFlag1);
            end
            
            drawnow
        end
        if (opt.verbose)
            disp([kk tcount toc])
        end
        
    end
end