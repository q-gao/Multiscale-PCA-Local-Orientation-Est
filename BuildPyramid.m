%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function of building the image/gradient pyramid
% 02/18/2003 FINAL Version, By Xiaoguang Feng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [LP,HP]=BuildPyramid(In)
    % Build the Pyramid without overlap 
    fun = inline('ones(2).*mean(x(:))');
    LP=blkproc(In,[2 2],fun);
    HP=In-LP;
    LP=LP(1:2:size(In,1),1:2:size(In,2));

    % Build the Pyramid with convolution
    %    H=[0.25 0.25;0.25 0.25];
    %    LP=conv2(In,H,'same');
    %    HP=In-LP;
    %    LP=LP(1:2:size(In,1),1:2:size(In,2));
    