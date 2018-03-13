%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% script of orientation estimation
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
% input parameters
% ----------------------------------------------------------------------
img_opt=input('Test Image:\n   1) Get test image from image file.\n   2) Create test image.\n');
if img_opt==1
    % image file path
    image_file=input('Image file path:\n','s');
    I=imread(image_file);
elseif img_opt==2
    ImgSize=input('Test image size (square image): for example, 64.\n');
    PatSize=input('Orientation pattern size: for example, 8.\n');
    PatAngle=input('Pattern rotation angle(in degree): for example, 30.\n');
    I=CreateTestImage(ImgSize,PatSize,PatAngle);
end

% additive noise variance
noisevar=input('Additive noise variance (enter for the default: 0):\n');
if isempty(noisevar)
    noisevar=0;
end
I=double(imnoise(I,'gaussian',0,noisevar));
% if the input image is not a square image, fill zeros to make it square
if size(I,1)~=size(I,2)
    disp('The image is not square image, fill with zeros.');
    for i=min(size(I,1),size(I,2))+1:max(size(I,1),size(I,2))
        if size(I,1)>size(I,2)
            I(:,i)=0;
        else
            I(i,:)=0;
        end
    end
end
% choose estimation method
method=input('Select estimation method:\n   1) Block-based method\n   2) Pyramid-based method\n ');
if method==2
    % for pyramid method, choose number of layers
    numoflayers=input('Number of layers in pyramid (enter for the default: 2):\n');
    if isempty(numoflayers)
        numoflayers=2;
    end
    % for pyramid method, choose pyramid (gradient or image)
    PyramidType=input('Select pyramid type (enter for the default:1):\n   1) Image Pyramid\n   2) Gradient Pyramid\n');
    if isempty(PyramidType)
        PyramidType=1;
    end
    % for pyramid method, choose propagation option
    propagation_option=input('Options of orientation propagation (enter for the default: 2):\n   1) Orientation selection (based on singular value rates)\n   2) Weighted Propagation\n');
    if isempty(propagation_option)
        propagation_option=2;
    end
elseif method==3
    numoflayers=input('Number of layers (enter for the default: 2):\n');
    if isempty(numoflayers)
        numoflayers=2;
    end
end
% block size (in both the pyramid method and block-based method)
blksize=input('Estimation block size (enter for the default: 8):\n');
if isempty(blksize)
    blksize=8;
end
% block overlap size
overlap=input('Block overlap size (enter for the default: 0):\n');
if isempty(overlap)
    overlap=0;
end
% display the options
disp('-----------------------------------------');
if img_opt==1
    disp(sprintf('Image file name: %s',image_file));
elseif img_opt==2
    disp(sprintf('Created test image: %d, %d, %f',ImgSize,PatSize,PatAngle));
end
disp(sprintf('Additive noise variance: %f',noisevar));
if method==2
    disp('Pyramid-based method');
    disp(sprintf('Number of layers: %d',numoflayers));
    disp(sprintf('Pyramid type: %d',PyramidType));
    disp(sprintf('Propagation option: %d',propagation_option));
elseif method==1
    disp('Block-based method');
elseif method==3
    disp('Multiscale method based on Kalman Filter');
    disp(sprintf('Number of layers: %d',numoflayers));
end
disp(sprintf('Estimation block size: %d',blksize));
disp(sprintf('Overlap size: %d',overlap));
disp('-----------------------------------------');

disp('Start...');
% doing estimation
% ----------------------------------------------------------------------
if method==1 % block-based method
    OM=BlkSVDOrient(I,blksize,overlap,1);
elseif method==2 % pyramid-based method
    OM=Pyramid(I,blksize,overlap,numoflayers,1,propagation_option,PyramidType);
end

%clear;
