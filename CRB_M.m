%CRB�������޽磨һάDOA���ƣ�---��Ԫ��M

clc
clear

snr=10;%�����(dB)
source_number=1;%�ź�Դ��Ŀ
sensor_number=2:12;%��Ԫ��Ŀ
N_x=1024;
snapshot_number=N_x;%������
w=pi/4;%��Ƶ��
l=2*pi*3e8/w;%����lamda
d=0.5*l;%��Ԫ���
sigma = 0.4;%��������

source_doa=[50]*pi/180;%�ź�Դ�Ĳ��﷽��

crb = zeros(1,length(sensor_number));
for kk = 1:length(sensor_number)
    A = zeros(source_number,sensor_number(kk));%����D��M�о���
    for k = 1:source_number
        A(k,:) = exp(-1i*2*pi*d*sin(source_doa(k))/l*[0:sensor_number(kk)-1]);
    end
    A = A.';%��ת������
    
    %A��theta����ΪD
    D = zeros(sensor_number(kk),source_number);
    for k1 = 1:source_number
        for k2 = 0:sensor_number(kk)-1
            D(k2+1,k1) = (-1i*2*pi*d*cos(source_doa(k1))/l*k2*pi/180)*exp(-1i*2*pi*d*sin(source_doa(k1))/l*k2);
        end
    end
    S = sqrt(sigma*10.^(snr/10))*exp(1i*w*[0:N_x-1]);
    
    P = S*S'/N_x;%�����źŵ�Э�������
    
    R = A*P*A' + sigma*eye(sensor_number(kk));
    
    crb(:,kk) = sqrt(sigma/(2*N_x)*inv((real(D'*(eye(sensor_number(kk))-A*inv(A'*A)*A')*D).*(P*A'*inv(R)*A*P).')));
    
end

%��ͼ
plot(sensor_number,crb(1,:), '--rd',  'LineWidth', 1.2, 'MarkerSize', 8)
xlabel('��Ԫ��M')
ylabel('�������޽�CRB')
title('�������޽�CRB����Ԫ����ϵ����')
grid on








