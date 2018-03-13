%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F5_22.m
% To produce the orientation map in Figure 5.22
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=double(imread('noisy_feature.jpg'));

OM=Pyramid(I,8,4,3,0,2,2);
imagesc(angle(OM));
axis image;
axis off;
colorbar;