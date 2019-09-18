%MUSIC ALOGRITHM
%���ź�Դ��MUSIC�㷨�ľ��������RMSE
clc
clear 

bbb=zeros(1,11);%���ڴ洢����������µľ��������
for kk=1:11
    
    snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];%�����(dB)
    aaa=zeros(2,300);%���ڴ洢���ƵĲ��﷽��Ƕ�
    for k=1:300
        
        source_number=2;%�ź�Դ��Ŀ
        sensor_number=8;%��Ԫ��Ŀ
        N_x=1024; 
        snapshot_number=N_x;%������
        w=[pi/4,pi/6];%��Ƶ��
        w = w.';
        l=2*pi*3e8;%����lamda
        d=0.5*l;%��Ԫ���
        
        source_doa=[20,50];%�ź�Դ�Ĳ��﷽��
        A = zeros(source_number,sensor_number);
        for c = 1:length(source_doa)
            A(c,:)=exp(-1i*[0:sensor_number-1]*d*2*pi*sin(source_doa(c)*pi/180)/l);%���췽�����
        end
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
        
        [t1,t2]=sort(Pmusic(bb),'ascend');
        estimated_source_doa=sort([searching_doa(bb(t2(length(t2)))),searching_doa(bb(t2(length(t2)-1)))].');
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
    
%     RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%���������
%     disp('RMSE_source_doa');
%     disp(RMSE_source_doa);
    
    RMSE_source_doa1=sqrt(sum((aaa(1,:)-source_doa(1)).^2)/300);
    RMSE_source_doa2=sqrt(sum((aaa(2,:)-source_doa(2)).^2)/300);
    RMSE_source_doa3 = (RMSE_source_doa1 + RMSE_source_doa2)/2;
    
    bbb(:,kk)=RMSE_source_doa3;
end
disp(bbb);

plot(snr,bbb(1,:),'k*-');
xlabel('�����SNR/dB')
ylabel('���������RMSE/degree')
title('����MUSIC�㷨DOA���Ƶ�RMSE����')
grid on


