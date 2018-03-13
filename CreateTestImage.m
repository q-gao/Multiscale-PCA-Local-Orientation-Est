%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the function to create orientation pattern test image
% 02/18/2003, FINAL Version, By Xiaoguang Feng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function OutputImage=CreateTestImage(ImageSize,PatternSize,Angle)
    % First calculate the actual 'need' size of the image block 
    % (because there is rotation, so the actual size of the image need to be larger than the required size)
    if Angle<=90
        ImSize=ceil(ImageSize*(sin(pi*Angle/180)+cos(pi*Angle/180)));
    else
        ImSize=ceil(ImageSize*(sin(pi*(180-Angle)/180)+cos(pi*(180-Angle)/180)));
    end
    
    % Calculate how many pattern lines are needed
    NumofLines=ImSize/PatternSize;
    
    % Create those lines by sin function
    Step=2*pi/PatternSize;
    x=(1+sin(0:Step:NumofLines*2*pi))/2;
    
    % Create the image (without rotation)
    for i=1:ImSize
        A(i,:)=x(1:ImSize);
    end
    
    % Rotate the image
    B=imrotate(A,(Angle-90),'bicubic');
    
    % crop the need part (according to the required size)
    StartIndex=round((size(B,1)-ImageSize)/2)+1;
    OutputImage=B(StartIndex:StartIndex+ImageSize-1,StartIndex:StartIndex+ImageSize-1);
    OutputImage=uint8(OutputImage*255);
    
    %imagesc(OutputImage);axis image;colormap(gray)
    
    