%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function of use average method to estimate the orientation
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function a=Average_Orientation(fx,fy)
    % generalize all the vectors point: 0 to pi
    fx(fy<0)=-fx(fy<0);fy(fy<0)=-fy(fy<0);
    % average the vector
    y=mean(fy(:));x=mean(fx(:));
    % calculate the angle
    a=atan2(y,x);

    if a<0
        a=a+pi;
    end
