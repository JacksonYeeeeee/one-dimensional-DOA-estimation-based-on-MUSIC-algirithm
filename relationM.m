%��Ԫ��Ŀ��MUSIC�㷨��Ӱ��
clc
clear 
format long
lamda = 150;%���Ƶ���źŵĲ���
d = lamda/2;%��Ԫ���
%�˴���ע��length(theta) = length(w)
theta = [20,30,60]/180*pi;%�ź�����Ƕ�
w = [pi/6,pi/4,pi/3];%��Ƶ��
w = w';
snapshots = 200;%������
D = length(w);%�ź�Դ��Ŀ
M = 12;%������Ԫ��Ŀ
M2 = 24;
M3 = 96;
SNR = 20;%�����Ϊ20dB
A = zeros(D,M);%����D��M�о���
A2 = zeros(D,M2);
A3 = zeros(D,M3);

for k = 1:D
      A(k,:) = exp(-1i*2*pi*d*sin(theta(k))/lamda*[0:M-1]);
      A2(k,:) = exp(-1i*2*pi*d*sin(theta(k))/lamda*[0:M2-1]);
      A3(k,:) = exp(-1i*2*pi*d*sin(theta(k))/lamda*[0:M3-1]);
end

A = A.';%��÷������
A2 = A2.';
A3 = A3.';

S = 4*exp(1i*(w*[1:snapshots]));%��÷����ź�(����խ���źŵĶ���ʽ)
X = awgn(A*S,SNR,'measured');%�����ź�
X2 = awgn(A2*S,SNR,'measured');%�����ź�
X3 = awgn(A3*S,SNR,'measured');%�����ź�


Rx = X*X'/snapshots;%�����źŵ�Э�������
Rx2 = X2*X2'/snapshots;
Rx3 = X3*X3'/snapshots;

[Ve,Va] = eig(Rx);%��ȡЭ������������ֵVa�Լ���������Ve
[Ve2,Va2] = eig(Rx2);
[Ve3,Va3] = eig(Rx3);

En = Ve(:,1:M-D);%ȡ��M-D����Ӧ����ֵΪ�����������������
En2 = Ve2(:,1:M2-D);
En3 = Ve3(:,1:M3-D);

theta1 = -90:0.5:90;


%ʹ������forѭ������Ƕ�ף��������Ƕ����δ�������׷�����
for a = 1:length(theta1)
    AA = zeros(1,M);
    
    for b = 0:M-1
        AA(:,b+1) = exp(-1*1i*2*pi*d*sin(theta1(a)/180*pi)/lamda*b); %ע����matlab�����Ǻ�������ʹ�õ��ǻ���ֵ
    end
    AA = AA.';
    P = AA'*En*En'*AA;
    Pmusic(a) = abs(1/P);%�׺���
end

for a = 1:length(theta1)
    AA3 = zeros(1,M3);
    
    for b = 0:M3-1
        AA3(:,b+1) = exp(-1*1i*2*pi*d*sin(theta1(a)/180*pi)/lamda*b); %ע����matlab�����Ǻ�������ʹ�õ��ǻ���ֵ
    end
    AA3 = AA3.';
    P3 = AA3'*En3*En3'*AA3;
    Pmusic3(a) = abs(1/P3);%�׺���
end

for a = 1:length(theta1)
    AA2 = zeros(1,M2);
    
    for b = 0:M2-1
        AA2(:,b+1) = exp(-1*1i*2*pi*d*sin(theta1(a)/180*pi)/lamda*b); %ע����matlab�����Ǻ�������ʹ�õ��ǻ���ֵ
    end
    AA2 = AA2.';
    P2 = AA2'*En2*En2'*AA2;
    Pmusic2(a) = abs(1/P2);%�׺���
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
legend('M=12','M=24','M=96')
axis([-90 90 -50 0])
grid on





