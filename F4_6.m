%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F4_6.m
% To produce the orientation map in Figure 4.6
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=double(imread('fprint.jpg'));
% block size 6, overlap 0, layer 3,gradient pyramid
OM=Pyramid(I,6,3,3,1,2,2);