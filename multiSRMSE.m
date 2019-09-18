%MUSIC ALOGRITHM
%多信号源的MUSIC算法的均方根误差RMSE
clc
clear 

bbb=zeros(1,11);%用于存储各个信噪比下的均方根误差
for kk=1:11
    
    snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];%信噪比(dB)
    aaa=zeros(2,300);%用于存储估计的波达方向角度
    for k=1:300
        
        source_number=2;%信号源数目
        sensor_number=8;%阵元数目
        N_x=1024; 
        snapshot_number=N_x;%快拍数
        w=[pi/4,pi/6];%角频率
        w = w.';
        l=2*pi*3e8;%波长lamda
        d=0.5*l;%阵元间距
        
        source_doa=[20,50];%信号源的波达方向
        A = zeros(source_number,sensor_number);
        for c = 1:length(source_doa)
            A(c,:)=exp(-1i*[0:sensor_number-1]*d*2*pi*sin(source_doa(c)*pi/180)/l);%构造方向矩阵
        end
        A = A.';%作转置运算
        
%         s=10.^((snr(kk)/2)/10)*exp(1i*w*[0:N_x-1]);%入射信号   
%         x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1i*randn(sensor_number,N_x));%接收信号（叠加了高斯噪声）
        s=2*exp(1i*w*[0:N_x-1]);
        x = awgn(A*s,snr(kk),'measured');
        
        R=x*x'/N_x;
        
        [V,D]=eig(R);%对X的协方差矩阵进行特征值分解（V为特征向量，D为特征值）
        D=diag(D);%将D转换为一个以特征值为对角线的对角矩阵
        disp(D);%
        Un=V(:,1:sensor_number-source_number);%噪声部分所对应的特征向量构成的噪声子空间
        Gn=Un*Un';
        
        searching_doa=-90:0.1:90;%
        
        for i=1:length(searching_doa)
            a_theta=exp(-1i*(0:sensor_number-1)'*2*pi*d*sin(pi*searching_doa(i)/180)/l);%构造阵列流型
            Pmusic(i)=1./abs((a_theta)'*Gn*a_theta);%构造谱函数
        end
        
        %找出使得Pmusic最大时所对应的角度值
        %----找出Pmusic这组数中的极大值-----
        aa=diff(Pmusic);%Pmusic事实上是1*length(searching_doa)矩阵，用后一个数依次减去前一个数得到aa
        aa=sign(aa);%获得符号函数（aa<0时变为-1，aa=0时变为0，aa>0时取为1）
        aa=diff(aa);
        bb=find(aa==-2)+1;
        %-------------------------------------------
        
        [t1,t2]=sort(Pmusic(bb),'ascend');
        estimated_source_doa=sort([searching_doa(bb(t2(length(t2)))),searching_doa(bb(t2(length(t2)-1)))].');
        aaa(:,k)=estimated_source_doa;
        
  %倘若只有一个信号源，可以直接使用下列代码段，但是在实际应用中，信号源数并不是已知的      
%          [a1,a2]=max(Pmusic);
%         estimated_source_doa=searching_doa(a2);
%         aaa(:,k)=estimated_source_doa;
        
    end
    disp(aaa);
    
    %
    E_source_doa=sum(aaa(1,:))/300;
    disp('E_source_doa');
    
%     RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%均方根误差
%     disp('RMSE_source_doa');
%     disp(RMSE_source_doa);
    
    RMSE_source_doa1=sqrt(sum((aaa(1,:)-source_doa(1)).^2)/300);
    RMSE_source_doa2=sqrt(sum((aaa(2,:)-source_doa(2)).^2)/300);
    RMSE_source_doa3 = (RMSE_source_doa1 + RMSE_source_doa2)/2;
    
    bbb(:,kk)=RMSE_source_doa3;
end
disp(bbb);

plot(snr,bbb(1,:),'k*-');
xlabel('信噪比SNR/dB')
ylabel('均方根误差RMSE/degree')
title('经典MUSIC算法DOA估计的RMSE曲线')
grid on


