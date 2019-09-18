%��������MUSIC�㷨��Ӱ��
clc
clear 
format long
lamda = 150;%���Ƶ���źŵĲ���
d = lamda/2;%��Ԫ���
%�˴���ע��length(theta) = length(w)
theta = [20,30,60]/180*pi;%�ź�����Ƕ�
w = [pi/6,pi/4,pi/3];%��Ƶ��
w = w';
snapshots = 100;%������
snapshots2 = 500;
snapshots3 = 1000;
D = length(w);%�ź�Դ��Ŀ
M = 12;%������Ԫ��Ŀ
SNR = 20;%�����Ϊ20dB
A = zeros(D,M);%����D��M�о���
for k = 1:D
      A(k,:) = exp(-1i*2*pi*d*sin(theta(k))/lamda*[0:M-1]);
end

A = A.';%��÷������
S = 4*exp(1i*(w*[1:snapshots]));%��÷����ź�(����խ���źŵĶ���ʽ)
S2 = 4*exp(1i*(w*[1:snapshots2]));
S3 = 4*exp(1i*(w*[1:snapshots3]));

X = awgn(A*S,SNR,'measured');%�����ź�
X2 = awgn(A*S2,SNR,'measured');
X3 = awgn(A*S3,SNR,'measured');

Rx = X*X'/snapshots;%�����źŵ�Э�������
Rx2 = X2*X2'/snapshots2;
Rx3 = X3*X3'/snapshots3;

[Ve,Va] = eig(Rx);%��ȡЭ������������ֵVa�Լ���������Ve
En = Ve(:,1:M-D);%ȡ��M-D����Ӧ����ֵΪ�����������������

[Ve2,Va2] = eig(Rx2);%��ȡЭ������������ֵVa�Լ���������Ve
En2 = Ve2(:,1:M-D);%ȡ��M-D����Ӧ����ֵΪ�����������������

[Ve3,Va3] = eig(Rx3);%��ȡЭ������������ֵVa�Լ���������Ve
En3 = Ve3(:,1:M-D);%ȡ��M-D����Ӧ����ֵΪ�����������������

theta1 = -90:0.5:90;


%ʹ������forѭ������Ƕ�ף��������Ƕ����δ�������׷�����
for a = 1:length(theta1)
    AA = zeros(1,M);
    for b = 0:M-1
        AA(:,b+1) = exp(-1*1i*2*pi*d*sin(theta1(a)/180*pi)/lamda*b); %ע����matlab�����Ǻ�������ʹ�õ��ǻ���ֵ
    end
    AA = AA.';
    P = AA'*En*En'*AA;
    P2 = AA'*En2*En2'*AA;
    P3 = AA'*En3*En3'*AA;
    Pmusic(a) = abs(1/P);%�׺���
    Pmusic2(a) = abs(1/P2);
    Pmusic3(a) = abs(1/P3);
end

Pmusic = 10*log10(Pmusic/max(Pmusic));%����õ��׺�����һ������м���dB����
Pmusic2 = 10*log10(Pmusic2/max(Pmusic2));
Pmusic3 = 10*log10(Pmusic3/max(Pmusic3));
plot(theta1,Pmusic,'-r')
hold on
plot(theta1,Pmusic2,'--g')
hold on
plot(theta1,Pmusic3,'-.b')
hold off
xlabel('�Ƕ� \theta/degree')
ylabel('�׺��� P(\theta)/dB')
title('����MUSIC�㷨��DOA����')
legend('������Ϊ100','������Ϊ500','������Ϊ1000')
grid on







