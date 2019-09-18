%����PM�������ӻ�ȡ�����ӿռ䣬��������ֵ�ֽ�
%���ô��ۺ���ȥ���ƴ�������P
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
%��Э���������зֿ�
G = Rx(:,1:D);
H = Rx(:,D+1:M);

%�����������������ͨ�����ۺ�����ȡ�Ĵ������ӵĹ���ֵ

P = inv(G'*G)*G'*H;

Q = [P;-eye(M-D)];%�����ӿռ�

%ʹ�������������Q��ȡ��ԭ����Q��ʹ�����������������ӱƽ�ԭ���������ӿռ�
Q0 = Q*(Q'*Q)^(-1/2);

Gn = Q0*Q0';


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
hold on
xlabel('�Ƕ� \theta/degree')
ylabel('�׺��� P(\theta)/dB')
title('����MUSIC�㷨��DOA����(PM�������ֵ�ֽ��ȡ�����ӿռ�)')
axis([-90,90,-50,0])
grid on

