%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Orientation Estimation (Block-based method)
% BlkSVDOrient(A,sz,ol,option)
% A: the image
% sz: the size of estimation block
% ol: the size of block overlap
% option: the option of whether show the result or not
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Orient=BlkSVDOrient(A,sz,ol,option)
    BlkSize=sz;
    
    % calculate the gradient map
    [fx,fy]=gradient(A);
    G=fx+i*fy;
    
    % Load the SVD method by blocks
    Orient=blkproc(G,[BlkSize,BlkSize],[ol,ol],'SVD_Orientation');

    % show the estimation result
    if option==1
        ShowOrientation(Orient,A);    
    end
