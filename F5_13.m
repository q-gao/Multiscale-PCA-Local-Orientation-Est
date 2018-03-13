%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file: F5_13.m
% To produce the orientation map in Figure 5.13
% By Xiaoguang Feng. 02/18/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    A=double(CreateTestImage(96,16,30));
    CorrectAnswer=pi/3;
    J=1;
    x=0:0.02:0.6;
    ts=100;
    for I=x
        I
        h=waitbar(0,sprintf('Now the additive noise variance is %f, please wait...',I));
        for k=1:ts
            B=double(imnoise(uint8(A),'gaussian',0,I));
            % the sub-blk on the border will have large bias (for overlap blk)
            % so we only consider the middle sub-blks
            
            %non-overlap-pyramid
            temp=angle(Pyramid(B,8,0,3,0,2,2));temp=temp(4:9,4:9);
            temp=min(abs(temp-CorrectAnswer),abs(pi-abs(temp-CorrectAnswer)));
            b1((k-1)*36+1:(k-1)*36+36)=temp(:);
            
            %overlap-pyramid
            temp=angle(Pyramid(B,8,4,3,0,2,2));temp=temp(4:9,4:9);
            temp=min(abs(temp-CorrectAnswer),abs(pi-abs(temp-CorrectAnswer)));
            b2((k-1)*36+1:(k-1)*36+36)=temp(:);

            %non-overlap-block
            temp=angle(BlkSVDOrient(B,8,0,0));temp=temp(4:9,4:9);
            temp=min(abs(temp-CorrectAnswer),abs(pi-abs(temp-CorrectAnswer)));
            b3((k-1)*36+1:(k-1)*36+36)=temp(:);

            %overlap-block 1
            temp=angle(BlkSVDOrient(B,8,4,0));temp=temp(4:9,4:9);
            temp=min(abs(temp-CorrectAnswer),abs(pi-abs(temp-CorrectAnswer)));
            b4((k-1)*36+1:(k-1)*36+36)=temp(:);

            %RW_method
            temp=RW_MultiResolutionEst(B,8,3,0);temp=temp(4:9,4:9);
            temp=min(abs(temp-CorrectAnswer),abs(pi-abs(temp-CorrectAnswer)));
            b5((k-1)*36+1:(k-1)*36+36)=temp(:);
           
            waitbar(k/ts,h);
        end
        save 'result_single_VS_multi'
        close(h);
        non_overlap_pyramid_mean(J)=mean(b1);
        non_overlap_pyramid_std(J)=std(b1)/sqrt(size(b1,2));
        overlap_pyramid_mean(J)=mean(b2);
        overlap_pyramid_std(J)=std(b2)/sqrt(size(b2,2));
        non_overlap_block_mean(J)=mean(b3);
        non_overlap_block_std(J)=std(b3)/sqrt(size(b3,2));
        overlap_block_mean(J)=mean(b4);
        overlap_block_std(J)=std(b4)/sqrt(size(b4,2));
        RW_method_mean(J)=mean(b5);
        RW_method_std(J)=std(b5)/sqrt(size(b5,2));
        J=J+1;
    end
    figure;
    hold on;
    errorbar(x,non_overlap_pyramid_mean,non_overlap_pyramid_std,'r');
    errorbar(x,overlap_pyramid_mean,overlap_pyramid_std,'g');
    errorbar(x,non_overlap_block_mean,non_overlap_block_std,'m');
    errorbar(x,overlap_block_mean,overlap_block_std,'b');
    errorbar(x,RW_method_mean,RW_method_std,'y');
    hold off;