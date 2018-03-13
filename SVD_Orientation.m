%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function of use SVD to estimate the orientation 
% 9/12/2002: the return value of a is not angle, but unit vector (in complex number)
% 02/18/2003: FINAL VERSION. By Xiaoguang Feng.
% 04/04/2003: Comments out the step of mean removal
%             (Since I haven't found a good way to deal with the mean,
%              for safe consideration, I comments out the mean-removal
%              now. Later I can add options about whether remove mean
%              and how to deal with the removed mean. I will do that
%              next week.)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [a,c]=SVD_Orientation(gradientmap)
    fx=real(gradientmap);
    fy=imag(gradientmap);
    
    fxvec=fx(:);fyvec=fy(:);
    
    % remove the mean of the vectors
    %meanx=mean(fxvec);
    %meany=mean(fyvec);
    %fxvec=fxvec-meanx;
    %fyvec=fyvec-meany;
    
    % SVD
    gradf=[fxvec fyvec];
 	[U,C,W]=svd(gradf,0);
   
    c=diag(C);

    x=W(1,1);
    y=W(2,1);
    
    % normalize to 0 -- PI
    if y<0
        x=-x;
        y=-y;
    end
    
    a=x+i*y;
    

