%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F5_6.m
% To produce the orientation map in Figure 5.6
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    A=double(imread('45degree.jpg'));
    CorrectAnswer=3*pi/4;
    J=1;
    for I=0:0.02:0.8
        J
        for k=1:100
            B=double(imnoise(uint8(A),'gaussian',0,I));
            
            temp=angle(Pyramid(B,4,0,3,0,1,2));
            temp=temp(5:12,5:12); % eliminate the border effect
            temp=abs(temp-CorrectAnswer);
            b1((k-1)*64+1:(k-1)*64+64)=temp(:);
            
            temp=angle(Pyramid(B,4,0,3,0,2,2));
            temp=temp(5:12,5:12); % eliminate the border effect
            temp=abs(temp-CorrectAnswer);
            b2((k-1)*64+1:(k-1)*64+64)=temp(:);
        end
        method1_mean(J)=mean(b1);
        method1_std(J)=std(b1)/sqrt(size(b1,2));
        method2_mean(J)=mean(b2);
        method2_std(J)=std(b2)/sqrt(size(b2,2));
        J=J+1;
    end
    save 'result_selection_vs_average';
    figure;
    hold on;
    errorbar(0:0.02:0.8,method1_mean,method1_std,'r');
    errorbar(0:0.02:0.8,method2_mean,method2_std,'g');
    hold off;
