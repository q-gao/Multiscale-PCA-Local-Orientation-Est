%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F4_3.m
% To produce the orientation map in Figure 4.3
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=double(imread('fprint.jpg'));
% block size 6, overlap 0, layer 3,gradient pyramid
OM=Pyramid(I,6,0,3,1,2,2);