%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F4_4.m
% To produce the orientation map in Figure 4.4
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=double(imread('fprint.jpg'));

% block size 6, overlap 0
OM1=BlkSVDOrient(I,6,0,0);

% block size 6, overlap 0, layer 3,gradient pyramid
OM2=Pyramid(I,6,0,3,0,2,2);

subplot(1,2,1);
imagesc(angle(OM1));
axis image;
axis off;
colormap(hsv);
subplot(1,2,2);
imagesc(angle(OM2));
axis image;
axis off;
colormap(hsv);
