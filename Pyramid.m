%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pyramid-based orientation estimation
% Pyramid(A,sz,ol,nl,option,option2)
% A: the image
% sz: the estimation block size
% ol: the block overlap size
% nl: the number of layers in the pyramid
% option: the option of whether show the result or not
% option2: the option of orientation propagation
% option3: =1: build image pyramid; =2: build gradient pyramid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sept 12, 2002, xiaoguang feng:
% The propagation is changed from angles to vectors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sept 21, 2002, xiaoguang feng:
% Add the option of build gradient pyramid (instead of image pyramid)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FINAL VERSION: 02/18/2003
% By Xiaoguang Feng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Orient=Pyramid(A,sz,ol,nl,option,option2,option3)
    MinSize=sz; % the block size
    OverLap=ol; % the overlap of the blocks
    NumOfLayer=nl; % the number of layers in the pyramid
    
    % build up the pyramid
    if option3==1 % build the image pyramid
        if option==1
            disp('Building IMAGE pyramid, please wait...');
        end
        LP{1}=A; % bottom layer of the low pass pyramid (Gaussian Pyramid)
        for I=2:NumOfLayer
            [LP{I},HP{I-1}]=BuildPyramid(LP{I-1});
        end
        [tmpLP,HP{NumOfLayer}]=BuildPyramid(LP{NumOfLayer});
        if option==1
            disp('Image pyramid done');
        end
    elseif option3==2 % build the gradient pyramid
        if option==1
            disp('Building GRADIENT pyramid, please wait...');
        end
        [fx fy]=gradient(A);
        LP{1}=fx+i*fy;
        for I=2:NumOfLayer
            [LP{I},HP{I-1}]=BuildPyramid(LP{I-1});
        end
        [tmpLP,HP{NumOfLayer}]=BuildPyramid(LP{NumOfLayer});
        if option==1
            disp('Gradient pyramid done');
        end
    end
    
    % select using which pyramid to do the estimation (LP:Low Pass Pyramid, HP: High Pass Pyramid)
    P=LP; %Gaussian Pyramid
    %P=HP; %Laplacian Pyramid
    
    % first estimate in the top layer
    NumBlk=ceil(size(P{NumOfLayer},1)/MinSize);
    Orient=zeros(NumBlk);
    % calculate the gradient map
    if option3==1
        [fx,fy]=gradient(P{NumOfLayer});
        G=fx+i*fy;
    elseif option3==2
        G=P{NumOfLayer};
    end
    % divide into blocks
    fun = inline('x(:)');
    subimages=blkproc(G,[MinSize MinSize],[OverLap, OverLap],fun);

    index=1;
    % for each sub-block
    if option==1
        h=waitbar(0,sprintf('Processing the layer %d, please wait...',NumOfLayer));
    end
    count=1;
    for J=1:NumBlk
        for K=1:NumBlk
            % get the gradients for current block
            itemp=(K-1)*(MinSize+2*OverLap)*(MinSize+2*OverLap);
            CurImage=subimages(itemp+1:itemp+(MinSize+2*OverLap)*(MinSize+2*OverLap),J);
            CurImage=reshape(CurImage,MinSize+2*OverLap,MinSize+2*OverLap);
            % load the SVD method to estimate in current block
            [a,sv]=SVD_Orientation(CurImage);
            Orient(K,J)=a; % now 'a' is not angle, but a unit vector
            EnergyRate(K,J)=(sv(1)-sv(2))/(sv(1)+sv(2));
            if option==1
                waitbar(count/(NumBlk*NumBlk),h);
            end
            count=count+1;
        end
    end
    if option==1
        close(h);
    end
    
    % for every other layers:
    for I=NumOfLayer-1:-1:1
        % double size the orientation matrix & the sv matrix
        Orient=imresize(Orient,2);
        EnergyRate=imresize(EnergyRate,2);
        NumBlk=ceil(size(P{I},1)/MinSize);
        if option3==1
            [fx,fy]=gradient(P{I});
            G=fx+i*fy;
        elseif option3==2
            G=P{I};
        end
        subimages=blkproc(G,[MinSize MinSize],[OverLap, OverLap],fun);
        if option==1
            h=waitbar(0,sprintf('Processing the layer %d, please wait...',I));
        end
        count=1;
        % for each sub-block
        for J=1:NumBlk
            for K=1:NumBlk
                % get the gradient map for current block 
                itemp=(K-1)*(MinSize+2*OverLap)*(MinSize+2*OverLap);
                CurImage=subimages(itemp+1:itemp+(MinSize+2*OverLap)*(MinSize+2*OverLap),J);
                CurImage=reshape(CurImage,MinSize+2*OverLap,MinSize+2*OverLap);
                % load SVD method
                [a,sv]=SVD_Orientation(CurImage);
                % two options of orientation propagation:
                % one is use singular value rates as propagation weights
                % the other is use singular value rates as selection criterion
                if option2==1
                    if (sv(1)-sv(2))/(sv(1)+sv(2))>EnergyRate(K,J)
                        Orient(K,J)=a;
                        EnergyRate(K,J)=(sv(1)-sv(2))/(sv(1)+sv(2));
                    end
                else
                    % to prevent the error propagations
                    if real(Orient(K,J))>0 & real(a)<-imag(Orient(K,J))
                        a=-a;
                    elseif real(Orient(K,J))<0 & real(a)>imag(Orient(K,J))
                        a=a+pi;
                    end
                    % linear combination
                    ER=(sv(1)-sv(2))/(sv(1)+sv(2));PropWeight(K,J)=ER/(ER+EnergyRate(K,J));
                    Orient(K,J)=a*ER/(ER+EnergyRate(K,J))+Orient(K,J)*EnergyRate(K,J)/(ER+EnergyRate(K,J));
                    if imag(Orient(K,J))<0
                        Orient(K,J)=-Orient(K,J);
                    end
                    EnergyRate(K,J)=ER*ER/(ER+EnergyRate(K,J))+EnergyRate(K,J)*EnergyRate(K,J)/(ER+EnergyRate(K,J));
                end
                if option==1
                    waitbar(count/(NumBlk*NumBlk),h);
                end
                count=count+1;
            end
         end
         if option==1
            close(h);
        end
    end

    if option==1
        ShowOrientation(Orient,A);
    end
    