%正交化的Q与未正交化的Q的RMSE对比
%利用PM传播因子进行谱峰搜索的算法的RMSE曲线(利用代价函数估计的传播算子P)
%Q正交化
clc
clear 

bbb=zeros(1,11);%用于存储各个信噪比下的均方根误差
for kk=1:11
    
    snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];%信噪比(dB)
    aaa=zeros(1,300);%用于存储估计的波达方向角度
    for k=1:300
        
        source_number=1;%信号源数目
        sensor_number=8;%阵元数目
        N_x=1024; 
        snapshot_number=N_x;%快拍数
        w=pi/4;%角频率
        l=2*pi*3e8/w;%波长lamda
        d=0.5*l;%阵元间距
        
        source_doa=50;%信号源的波达方向
        A=[exp(-1i*(0:sensor_number-1)*d*2*pi*sin(source_doa*pi/180)/l)];%构造方向矩阵
        A = A.';%作转置运算
        
%         s=10.^((snr(kk)/2)/10)*exp(1i*w*[0:N_x-1]);%入射信号   
%         x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1i*randn(sensor_number,N_x));%接收信号（叠加了高斯噪声）
        s=2*exp(1i*w*[0:N_x-1]);
        x = awgn(A*s,snr(kk),'measured');
        
        R=x*x'/N_x;
        
        %获取传播算子
        %将协方差矩阵进行分块
        G = R(:,1:source_number);
        H = R(:,source_number+1:sensor_number);

        %根据在有噪声情况下通过代价函数获取的传播算子的估计值

        P = inv(G'*G)*G'*H;

        Q = [P;-eye(sensor_number-source_number)];%噪声子空间

        %使用其正交化后的Q来取代原来的Q，使其列向量正交，更加逼近原来的噪声子空间
        Q = Q*(Q'*Q)^(-1/2);

        Gn = Q*Q';
        
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
        
        [t1,t2]=max(Pmusic(bb));
        estimated_source_doa=searching_doa(bb(t2));
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
    
    RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%均方根误差
    disp('RMSE_source_doa');
    disp(RMSE_source_doa);
    
    bbb(:,kk)=RMSE_source_doa;
end
disp(bbb);

plot(snr,bbb(1,:),'rp-');
hold on

%Q正交化
clc
clear 

bbb=zeros(1,11);%用于存储各个信噪比下的均方根误差
for kk=1:11
    
    snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];%信噪比(dB)
    aaa=zeros(1,300);%用于存储估计的波达方向角度
    for k=1:300
        
        source_number=1;%信号源数目
        sensor_number=8;%阵元数目
        N_x=1024; 
        snapshot_number=N_x;%快拍数
        w=pi/4;%角频率
        l=2*pi*3e8/w;%波长lamda
        d=0.5*l;%阵元间距
        
        source_doa=50;%信号源的波达方向
        A=[exp(-1i*(0:sensor_number-1)*d*2*pi*sin(source_doa*pi/180)/l)];%构造方向矩阵
        A = A.';%作转置运算
        
%         s=10.^((snr(kk)/2)/10)*exp(1i*w*[0:N_x-1]);%入射信号   
%         x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1i*randn(sensor_number,N_x));%接收信号（叠加了高斯噪声）
        s=2*exp(1i*w*[0:N_x-1]);
        x = awgn(A*s,snr(kk),'measured');
        
        R=x*x'/N_x;
        
        %获取传播算子
        %将协方差矩阵进行分块
        G = R(:,1:source_number);
        H = R(:,source_number+1:sensor_number);

        %根据在有噪声情况下通过代价函数获取的传播算子的估计值

        P = inv(G'*G)*G'*H;

        Q = [P;-eye(sensor_number-source_number)];%噪声子空间

        Gn = Q*Q';
        
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
        
        [t1,t2]=max(Pmusic(bb));
        estimated_source_doa=searching_doa(bb(t2));
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
    
    RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%均方根误差
    disp('RMSE_source_doa');
    disp(RMSE_source_doa);
    
    bbb(:,kk)=RMSE_source_doa;
end
disp(bbb);

plot(snr,bbb(1,:),'k*-');
hold on

%-------------------------CRB-------------------------------

%CRB克拉美罗界（一维DOA估计）

clc
clear

snr=-10:2:10;%信噪比(dB)
source_number=1;%信号源数目
sensor_number=8;%阵元数目
N_x=1024;
snapshot_number=N_x;%快拍数
w=pi/4;%角频率
l=2*pi*3e8/w;%波长lamda
d=0.5*l;%阵元间距
sigma = 2;%噪声方差

source_doa=[50]*pi/180;%信号源的波达方向
A = zeros(source_number,sensor_number);%构建D行M列矩阵
for k = 1:source_number
      A(k,:) = exp(-1i*2*pi*d*sin(source_doa(k))/l*[0:sensor_number-1]);
end
A = A.';%作转置运算

%A对theta的求导为D
D = zeros(sensor_number,source_number);
for k1 = 1:source_number
    for k2 = 0:sensor_number-1
        D(k2+1,k1) = (-1i*2*pi*d*cos(source_doa(k1))/l*k2*pi/180)*exp(-1i*2*pi*d*sin(source_doa(k1))/l*k2);
    end
end

crb = zeros(1,length(snr));
for kk = 1:length(snr)
    S = sqrt(sigma*10.^(snr(kk)/10))*(randn(source_number,N_x) + 1j*randn(source_number,N_x));
       
    P = S*S'/N_x;%入射信号的协方差矩阵
    
    R = A*P*A' + sigma*eye(sensor_number);
    
    crb(:,kk) = sqrt(sigma/(2*N_x)*inv((real(D'*(eye(sensor_number)-A*inv(A'*A)*A')*D).*(P*A'*inv(R)*A*P).')));
    
end

%画图
plot(snr,crb(1,:), '--rd',  'LineWidth', 1.2, 'MarkerSize', 8)
hold off

%---------------------------------------------------------

xlabel('信噪比SNR/dB')
ylabel('均方根误差RMSE(CRB)/degree')
title('MUSIC类算法DOA估计的RMSE曲线')
legend('PM-MUSIC-噪声子空间Q正交化','PM-MUSIC-噪声子空间Q未正交化','CRB')
grid on