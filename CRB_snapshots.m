%CRB�������޽磨һάDOA���ƣ�---������

clc
clear

snr=10;%�����(dB)
source_number=1;%�ź�Դ��Ŀ
sensor_number=8;%��Ԫ��Ŀ
N_x=100:200:4096;%������
w=pi/4;%��Ƶ��
l=2*pi*3e8/w;%����lamda
d=0.5*l;%��Ԫ���
sigma = 0.4;%��������

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

crb = zeros(1,length(N_x));
for kk = 1:length(N_x)
    S = sqrt(sigma*10.^(snr/10))*exp(1i*w*[0:N_x(kk)-1]);
       
    P = S*S'/N_x(kk);%�����źŵ�Э�������
    
    R = A*P*A' + sigma*eye(sensor_number);
    
    crb(:,kk) = sqrt(sigma/(2*N_x(kk))*inv((real(D'*(eye(sensor_number)-A*inv(A'*A)*A')*D).*(P*A'*inv(R)*A*P).')));
    
end

%��ͼ
plot(N_x,crb(1,:), '--rd',  'LineWidth', 1.2, 'MarkerSize', 8)
xlabel('������')
ylabel('�������޽�CRB')
title('�������޽�CRB���������ϵ����')
grid on

