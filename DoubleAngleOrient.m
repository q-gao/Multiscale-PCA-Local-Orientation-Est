%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation method used in R. Wilson's approach
% 02/18/2003, FINAL Version, By Xiaoguang Feng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [angle,w]=DoubleAngleOrient(Gx,Gy)
    % use 'double angle' representation to calculate vector angle
    angle=0.5*atan2(sum(2*Gx.*Gy),sum(Gx.*Gx)-sum(Gy.*Gy));
    
    if angle<0
        angle=angle+pi;
    end
    
    % 'w' is the 'average value of the magnitude square of the gradient estimate', used in propagation
    w=mean(Gx.*Gx+Gy.*Gy);
