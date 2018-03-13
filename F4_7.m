%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F4_7.m
% To produce the orientation map in Figure 4.7
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=double(imread('fprint.jpg'));
% block size 6, overlap 0, layer 3,gradient pyramid
OM=Pyramid(I,6,3,3,0,2,2);
imagesc(angle(OM));
axis image;
axis off;
colormap(hsv);
