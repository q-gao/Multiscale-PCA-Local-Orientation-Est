%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% implementation of R Wilson's multiresolution orientation estimation scheme
% 02/18/2003, FINAL version, By Xiaoguang Feng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

image_file=input('Image file path:\n','s');
I=imread(image_file);
noisevar=input('Additive noise variance (enter for the default: 0):\n');
if isempty(noisevar)
    noisevar=0;
end
I=double(imnoise(I,'gaussian',0,noisevar));
BlkSz=input('Estimation Block Size:\n');
NumLayer=input('Number of pyramid layers:\n');
disp('Start...');
% load the estimation 
RW_MultiResolutionEst(I,BlkSz,NumLayer,1);

