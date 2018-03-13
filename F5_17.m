%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F5_17.m
% To produce the orientation map in Figure 5.17
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=double(imread('circue2.jpg'));

OM1=BlkSVDOrient(I,8,4,0);

OM2=Pyramid(I,8,4,3,0,1,2);

subplot(1,2,1);
imagesc(angle(OM1));
axis image;
axis off;
subplot(1,2,2);
imagesc(angle(OM2));
axis image;
axis off;
