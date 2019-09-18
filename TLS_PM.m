%����TLS׼��ȥ���ƴ�������P
clc
clear

lamda = 100;%������Ϊ100
d = lamda/2;%��Ԫ���ȡΪ�벨��
theta = [20,30,60];%�ź�Դ����Ƕ�
M = 12;%��Ԫ����
SNR = 10;%�����Ϊ10dB
w = [pi/6,pi/4,pi/3];%��Ƶ��
w = w';
snapshots = 1024;%������
D = length(theta);%�ź�Դ��

%���췽�����
A = zeros(M,D);

for k = 1:D
    A(:,k) = exp(-1i*2*pi*d*sin(theta(k)*pi/180)*[0:M-1]/lamda);
end

S = 4*exp(1i*(w*[1:snapshots]));%��÷����ź�(����խ���źŵĶ���ʽ)
X = awgn(A*S,SNR,'measured');%�����ź�
Rx = X*X'/snapshots;%�����źŵ�Э�������

%��ȡ��������
R = Rx'*Rx;
%��R��������ֵ�ֽ�
[Ve,Va] = eig(R);

Vb = Ve(:,1:M-D);

% %��Vb���зֿ鴦��
% V1b = Vb(1:D,:);
% V2b = Vb(D+1:M,:);
% 
% P = -V1b*inv(V2b);
% 
% Q = [P;-eye(M-D)];%�����ӿռ�

%�˴���Qʹ�������淽������������ȡ��
Q = -Vb;
Gn = Q*Q';


Stheta = -90:0.5:90;
    
for k1 = 1:length(Stheta)
    AA = zeros(1,M);
    for k2 = 0:M-1
        AA(:,k2+1) = exp(-1i*2*pi*d*sin(Stheta(k1)*pi/180)/lamda*k2);
    end
    
    AA = AA.';
    Pmusic(k1) = 1/abs(AA'*Gn*AA);
    
end

%��ͼ
Pmusic = 10*log10(Pmusic/max(Pmusic));
plot(Stheta,Pmusic,'-r')
xlabel('�Ƕ� \theta/degree')
ylabel('�׺��� P(\theta)/dB')
title('����MUSIC�㷨��DOA����(PM�������ֵ�ֽ��ȡ�����ӿռ�)')
axis([-90,90,-60,0])
grid on

