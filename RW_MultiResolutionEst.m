%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R. Wilson's orientation estimation method
% RW_MultiResolutionEst(A,sz,nl)
% A: image
% sz: block size
% nl: number of layers
% option: show or don't show the estimation result
% return: the orientation angle map
% 02/18/2003, FINAL version, By Xiaoguang Feng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result=RW_MultiResolutionEst(A,sz,nl,option)
    % construct the image pyramid
    LowpassKernel=[0.001 0.018 0.029 0.018 0.001;
                   0.018 0.067 0.088 0.067 0.018;
                   0.029 0.088 0.119 0.088 0.029;
                   0.018 0.067 0.088 0.067 0.018;
                   0.001 0.018 0.029 0.018 0.001];
    ImagePyramid{1}=A; % the lowest layer is the original image
    if option==1
        disp('Building image pyramid...');
    end
    for I=2:nl
        temp=conv2(ImagePyramid{I-1},LowpassKernel,'same');
        temp=temp(1:2:size(temp,1),1:2:size(temp,2));
        ImagePyramid{I}=temp;
    end
    if option==1
        disp('done');
    end
    
    % first calculate gradient orientation from each layer
    for I=1:nl
        NumBlk=ceil(size(ImagePyramid{I},1)/sz);
        Orient{I}=zeros(NumBlk);
        W{I}=zeros(NumBlk);%'W' is the 'average value of the magnitude square of the gradient estimate', used in propagation
        % calculate the gradient map of current layer (with sober operator)
        Sv=[1 0 -1;2 0 -2;1 0 -1];
        Sh=[1 2 1;0 0 0;-1 -2 -1];
        Gx=conv2(ImagePyramid{I},Sv,'same');
        Gy=conv2(ImagePyramid{I},Sh,'same');
        % divide the gradient map into blocks
        fun = inline('x(:)');
        gx=blkproc(Gx,[sz sz],fun);
        gy=blkproc(Gy,[sz sz],fun);
        if option==1
            h=waitbar(0,sprintf('Estimating the layer %d, please wait...',I));
        end
        count=1;
        for J=1:NumBlk
            for K=1:NumBlk
                % get the gradient map for current block
                itemp=(K-1)*sz*sz;
                CurGx=gx(itemp+1:itemp+sz*sz,J);
                CurGy=gy(itemp+1:itemp+sz*sz,J);
                % load the 'double angle' representation method to calculate orientatin angle
                [a,w]=DoubleAngleOrient(CurGx,CurGy);
                Orient{I}(K,J)=a;
                W{I}(K,J)=w;
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
    
    % from the top layer, propagate estimation from coarser layer to finer layer
    for I=nl-1:-1:1
        % double size the orientation matrix & the W matrix from the coarser layer
        CoarseOrient=imresize(Orient{I+1},2);
        CoarseW=imresize(W{I+1},2);
        FineOrient=Orient{I};
        FineW=W{I};
        if option==1
            h=waitbar(0,sprintf('Propagating to the layer %d, please wait...',I));
        end
        count=1;
        % for each block
        for J=1:size(FineOrient,2)
            for K=1:size(FineOrient,1)
                % propagation from upper layer
                weight=CoarseW(K,J)/(CoarseW(K,J)+FineW(K,J));
                Orient{I}(K,J)=weight*CoarseOrient(K,J)+(1-weight)*FineOrient(K,J);
                if option==1
                    waitbar(count/(size(FineOrient,2)*size(FineOrient,1)),h);
                end
                count=count+1;
            end
         end
         if option==1
            close(h);
        end
    end
    
    % show the result
    if option==1
        figure;
        imagesc(A);
        colormap(gray);
        axis image;
        axis off;
        hold on;
        step1=size(A,1)/size(Orient{1},1);
        step2=size(A,2)/size(Orient{1},2);
        [x,y]=meshgrid(step1/2:step1:size(A,1),...
            step2/2:step2:size(A,2));
        u=cos(Orient{1});  
        v=-sin(Orient{1});
        h=quiver(x,y,v,u);
        set(h,'color','red');
    end
    
    result=Orient{1};