%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F3_8.m
% To produce the orientation map in Figure 3.8
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=double(imread('fprint.jpg'));
% block size 6, overlap 0
OM=BlkSVDOrient(I,6,0,1);