%��Hermite�����ع�ΪToeplitz����
clc
clear 
format long
lamda = 150;%���Ƶ���źŵĲ���
d = lamda/2;%��Ԫ���
%�˴���ע��length(theta) = length(w)
theta = [20,30,60]/180*pi;%�ź�����Ƕ�
w = [pi/6,pi/6,pi/4];%��Ƶ��
w = w';
snapshots = 200;%������
D = length(w);%�ź�Դ��Ŀ
M = 12;%������Ԫ��Ŀ
SNR = 20;%�����Ϊ20dB
A = zeros(D,M);%����D��M�о���
for k = 1:D
      A(k,:) = exp(-1i*2*pi*d*sin(theta(k))/lamda*[0:M-1]);
end

A = A.';%��÷������
S = 4*exp(1i*(w*[1:snapshots]));%��÷����ź�(����խ���źŵĶ���ʽ)
X = awgn(A*S,SNR,'measured');%�����ź�
Rx = X*X'/snapshots;%�����źŵ�Э�������

%��Rx�ع�ΪToeplitz����
B = fliplr(eye(M));
Rx = Rx + B*conj(Rx)*B;

[Ve,Va] = eig(Rx);%��ȡЭ������������ֵVa�Լ���������Ve
En = Ve(:,1:M-D);%ȡ��M-D����Ӧ����ֵΪ�����������������

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

Pmusic = 10*log10(Pmusic/max(Pmusic));%����õ��׺�����һ������м���dB����
plot(theta1,Pmusic,'-r')
xlabel('�Ƕ� \theta/degree')
ylabel('�׺��� P(\theta)/dB')
title('����MUSIC�㷨��DOA����')
grid on






