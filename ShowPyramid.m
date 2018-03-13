% To show the result images of Pyramid Decomposition     
function ShowPyramid(P)
    width=0;
    for I=1:size(P,2)
        width=width+size(P{I},2)+1;
    end
    Display=zeros(size(P{1},1),width);
    start=1;
    for I=1:size(P,2)
        Display(1:1:size(P{I},2),start:1:start+size(P{I},1)-1)=P{I};
        start=start+size(P{I},2)+1;
    end
    figure;
    imagesc(Display);
    axis image;axis off;
    colormap(gray);
