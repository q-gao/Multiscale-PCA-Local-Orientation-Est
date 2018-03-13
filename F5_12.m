%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F5_12.m
% To produce the orientation map in Figure 5.12
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    clear;
    A=double(imread('45degree.jpg'));
    CorrectAnswer=3*pi/4;
    J=1;
    for I=0:0.02:0.8
        J
        for k=1:10000
            B=double(imnoise(uint8(A),'gaussian',0,I));
            [fx fy]=gradient(B);
            %fx=fx(2:size(B,1)-1,2:size(B,2)-1);
            %fy=fy(2:size(B,1)-1,2:size(B,2)-1);
            fx=fx(2:9,2:9);
            fy=fy(2:9,2:9);
            
            A1(k)=abs(Average_Orientation(fx,fy)-CorrectAnswer);
            A2(k)=SVD_Orientation(fx+i*fy);
            A2(k)=angle(A2(k));
            if A2(k)<0
                A2(k)=A2(k)+pi;
            end
            A2(k)=abs(A2(k)-CorrectAnswer);
        end
        method1_mean(J)=mean(A1);
        method1_std(J)=std(A1)/sqrt(size(A1,2));
        method2_mean(J)=mean(A2);
        method2_std(J)=std(A2)/sqrt(size(A2,2));
        J=J+1;
    end
    save 'result_average_VS_SVD';
    figure;
    hold on;
    errorbar(0:0.02:0.8,method1_mean,method1_std,'r');
    errorbar(0:0.02:0.8,method2_mean,method2_std,'g');
    hold off;
