%MUSIC�㷨��RMSE��Root-MUSIC�㷨��RMSE�Ա�
clc
clear 

bbb=zeros(1,11);%���ڴ洢����������µľ��������
for kk=1:11
    
    snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];%�����(dB)
    aaa=zeros(1,300);%���ڴ洢���ƵĲ��﷽��Ƕ�
    for k=1:300
        
        source_number=1;%�ź�Դ��Ŀ
        sensor_number=8;%��Ԫ��Ŀ
        N_x=1024; 
        snapshot_number=N_x;%������
        w=pi/4;%��Ƶ��
        l=2*pi*3e8/w;%����lamda
        d=0.5*l;%��Ԫ���
        
        source_doa=50;%�ź�Դ�Ĳ��﷽��
        A=[exp(-1i*(0:sensor_number-1)*d*2*pi*sin(source_doa*pi/180)/l)];%���췽�����
        A = A.';%��ת������
        
%         s=10.^((snr(kk)/2)/10)*exp(1i*w*[0:N_x-1]);%�����ź�   
%         x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1i*randn(sensor_number,N_x));%�����źţ������˸�˹������
        s=2*exp(1i*w*[0:N_x-1]);
        x = awgn(A*s,snr(kk),'measured');
        
        R=x*x'/N_x;
        
        [V,D]=eig(R);%��X��Э��������������ֵ�ֽ⣨VΪ����������DΪ����ֵ��
        D=diag(D);%��Dת��Ϊһ��������ֵΪ�Խ��ߵĶԽǾ���
        disp(D);%
        Un=V(:,1:sensor_number-source_number);%������������Ӧ�������������ɵ������ӿռ�
        Gn=Un*Un';
        
        searching_doa=-90:0.1:90;%
        
        for i=1:length(searching_doa)
            a_theta=exp(-1i*(0:sensor_number-1)'*2*pi*d*sin(pi*searching_doa(i)/180)/l);%������������
            Pmusic(i)=1./abs((a_theta)'*Gn*a_theta);%�����׺���
        end
        
        %�ҳ�ʹ��Pmusic���ʱ����Ӧ�ĽǶ�ֵ
        %----�ҳ�Pmusic�������еļ���ֵ-----
        aa=diff(Pmusic);%Pmusic��ʵ����1*length(searching_doa)�����ú�һ�������μ�ȥǰһ�����õ�aa
        aa=sign(aa);%��÷��ź�����aa<0ʱ��Ϊ-1��aa=0ʱ��Ϊ0��aa>0ʱȡΪ1��
        aa=diff(aa);
        bb=find(aa==-2)+1;
        %-------------------------------------------
        
        [t1,t2]=max(Pmusic(bb));
        estimated_source_doa=searching_doa(bb(t2));
        aaa(:,k)=estimated_source_doa;
        
  %����ֻ��һ���ź�Դ������ֱ��ʹ�����д���Σ�������ʵ��Ӧ���У��ź�Դ����������֪��      
%          [a1,a2]=max(Pmusic);
%         estimated_source_doa=searching_doa(a2);
%         aaa(:,k)=estimated_source_doa;
        
    end
    disp(aaa);
    
    %
    E_source_doa=sum(aaa(1,:))/300;
    disp('E_source_doa');
    
    RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%���������
    disp('RMSE_source_doa');
    disp(RMSE_source_doa);
    
    bbb(:,kk)=RMSE_source_doa;
end
disp(bbb);

plot(snr,bbb(1,:),'k*-');
hold on
save MUSIC_RMSE.mat


%ROOT_MUSIC�㷨��RMSE
bbb=zeros(1,11);
for kk=1:11
    snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];%�����(dB)
    
    aaa=zeros(1,300);
    for k=1:300
        
%         s=10.^((snr(kk)/2)/10)*exp(j*w*[0:N_x-1]);%�����ź�
%         x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+j*randn(sensor_number,N_x));%������Ԫ�����ź�
        
        s=10*exp(j*w*[0:N_x-1]);%�����ź�
        x=awgn(A*s,snr(kk),'measured');%������Ԫ�����ź�
        
        R=(x*x')/snapshot_number;
        %��Э��������������ֵ�ֽ�
        [V,D]=eig(R);
        Un=V(:,1:sensor_number-source_number);
        Gn=Un*Un'
        %��ȡ����ʽ��ϵ��
        a=zeros(1,15);
        a(15) = sum( diag(Gn,-7));
        a(14) = sum( diag(Gn,-6));
        a(13) = sum( diag(Gn,-5));
        a(12) = sum( diag(Gn,-4));
        a(11) = sum( diag(Gn,-3));
        a(10) = sum( diag(Gn,-2));
        a(9) = sum( diag(Gn,-1));
        a(8) = sum( diag(Gn,0));
        a(7) = sum( diag(Gn,1));
        a(6) = sum( diag(Gn,2));
        a(5) = sum( diag(Gn,3));
        a(4) = sum( diag(Gn,4));
        a(3) = sum( diag(Gn,5));
        a(2) = sum( diag(Gn,6));
        a(1) = sum( diag(Gn,7));
        %�����������������ʽ�ĸ�
        a1=roots(a)
        %�ҵ���Щ�����ڵ�λԲ���Ҿ��뵥λԲ������ź�Դ������
        a2=a1(abs(a1)<1);
        [lamda,I]=sort(abs(abs(a2)-1));
        f=a2(I(1:source_number));
        
        estimated_source_doa=[-asin(angle(f(1))/pi)*180/pi];
        aaa(:,k)=estimated_source_doa;
        
        disp('estimated_source_doa');
        disp(estimated_source_doa);
    end
    disp(aaa);
    
    
    E_source_doa=sum(aaa(1,:))/300;
    disp('E_source_doa');
    
    RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%���������
    disp('RMSE_source_doa');
    disp(RMSE_source_doa);
    
    bbb(:,kk)=RMSE_source_doa;
end
disp(bbb);


plot(snr,bbb(1,:),'bs-');
save Root_MUSIC_RMSE.mat
hold on

%-------------------------CRB-------------------------------

%CRB�������޽磨һάDOA���ƣ�

clc
clear

snr=-10:2:10;%�����(dB)
source_number=1;%�ź�Դ��Ŀ
sensor_number=8;%��Ԫ��Ŀ
N_x=1024;
snapshot_number=N_x;%������
w=pi/4;%��Ƶ��
l=2*pi*3e8/w;%����lamda
d=0.5*l;%��Ԫ���
sigma = 2;%��������

source_doa=[50]*pi/180;%�ź�Դ�Ĳ��﷽��
A = zeros(source_number,sensor_number);%����D��M�о���
for k = 1:source_number
      A(k,:) = exp(-1i*2*pi*d*sin(source_doa(k))/l*[0:sensor_number-1]);
end
A = A.';%��ת������

%A��theta����ΪD
D = zeros(sensor_number,source_number);
for k1 = 1:source_number
    for k2 = 0:sensor_number-1
        D(k2+1,k1) = (-1i*2*pi*d*cos(source_doa(k1))/l*k2*pi/180)*exp(-1i*2*pi*d*sin(source_doa(k1))/l*k2);
    end
end

crb = zeros(1,length(snr));
for kk = 1:length(snr)
    S = sqrt(sigma*10.^(snr(kk)/10))*(randn(source_number,N_x) + 1j*randn(source_number,N_x));
       
    P = S*S'/N_x;%�����źŵ�Э�������
    
    R = A*P*A' + sigma*eye(sensor_number);
    
    crb(:,kk) = sqrt(sigma/(2*N_x)*inv((real(D'*(eye(sensor_number)-A*inv(A'*A)*A')*D).*(P*A'*inv(R)*A*P).')));
    
end

%��ͼ
plot(snr,crb(1,:), '--rd',  'LineWidth', 1.2, 'MarkerSize', 8)
hold off

xlabel('�����SNR/dB')
ylabel('���������RMSE(CRB)/degree')
title('MUSIC�㷨��Root-MUSIC�㷨��RMSE����ͼ')
legend('MUSIC-RMSE','ROOT-MUSIC-RMSE','CRB')
grid on


