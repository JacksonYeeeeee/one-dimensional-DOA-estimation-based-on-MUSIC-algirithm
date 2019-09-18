%MUSIC
clc
clear 
format long
lamda = 150;%���Ƶ���źŵĲ���
m1 = 5;
m2 = 6;%��֤m1��m2��������Ϊ����
d1 = m1*lamda/2;%��Ԫ���
d2 = m2*lamda/2;%��Ԫ���
%�˴���ע��length(theta) = length(w)
theta = [20,60]/180*pi;%�ź�����Ƕ�
w = [pi/6,pi/4];%��Ƶ��
w = w';
snapshots = 200;%������
D = length(w);%�ź�Դ��Ŀ
M = 12;%������Ԫ��Ŀ
SNR = 10;%�����Ϊ10dB
A1 = zeros(D,M);%����D��M�о���
A2 = zeros(D,M);
for k = 1:D
      A1(k,:) = exp(-1i*2*pi*d1*sin(theta(k))/lamda*[0:M-1]);
      A2(k,:) = exp(-1i*2*pi*d2*sin(theta(k))/lamda*[0:M-1]); 
end

A1 = A1.';%��÷������
A2 = A2.';

S = 4*exp(1i*(w*[1:snapshots]));%��÷����ź�(����խ���źŵĶ���ʽ)
X1 = awgn(A1*S,SNR,'measured');%�����ź�
X2 = awgn(A2*S,SNR,'measured');%�����ź�
Rx1 = X1*X1'/snapshots;%�����źŵ�Э�������
Rx2 = X2*X2'/snapshots;
[Ve1,Va1] = eig(Rx1);%��ȡЭ������������ֵVa�Լ���������Ve
[Ve2,Va2] = eig(Rx2);
En1 = Ve1(:,1:M-D);%ȡ��M-D����Ӧ����ֵΪ�����������������
En2 = Ve2(:,1:M-D);

theta1 = -90:0.5:90;


%ʹ������forѭ������Ƕ�ף��������Ƕ����δ�������׷�����
for a = 1:length(theta1)
    AA1 = zeros(1,M);
    AA2 = zeros(1,M);
    for b = 0:M-1
        AA1(:,b+1) = exp(-1*1i*2*pi*d1*sin(theta1(a)/180*pi)/lamda*b); %ע����matlab�����Ǻ�������ʹ�õ��ǻ���ֵ
        AA2(:,b+1) = exp(-1*1i*2*pi*d2*sin(theta1(a)/180*pi)/lamda*b);
    end
   AA1 = AA1.';
   AA2 = AA2.';
    P1 = AA1'*En1*En1'*AA1;
    P2 = AA2'*En2*En2'*AA2;
    Pmusic1(a) = abs(1/P1);%�׺���
    Pmusic2(a) = abs(1/P2);
end

Pmusic1 = 10*log10(Pmusic1/max(Pmusic1));%����õ��׺�����һ������м���dB����
Pmusic2 = 10*log10(Pmusic2/max(Pmusic2));
plot(theta1,Pmusic1,'-r')
hold on
plot(theta1,Pmusic2,'.-k')
hold off
xlabel('�Ƕ� \theta/degree')
ylabel('�׺��� P(\theta)/dB')
title('����MUSIC�㷨��DOA����(��������������������������Ԫ�����ڰ벨������ĽǶ�ģ��)')
legend('d1=m1*lamda/2,(m1=5)','d2=m2*lamda/2,(m2=6)')
grid on

