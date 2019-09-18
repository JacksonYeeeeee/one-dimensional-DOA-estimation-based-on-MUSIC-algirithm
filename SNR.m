%�����SNR��MUSIC�㷨�Ĺ�ϵ
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
SNR = 20;%�����Ϊ20dB
SNR2 = 40;
SNR3 = 80;
A = zeros(D,M);%����D��M�о���
for k = 1:D
      A(k,:) = exp(-1i*2*pi*d*sin(theta(k))/lamda*[0:M-1]);
end

A = A';%���ͶӰ����
S = 4*exp(1i*(w*[1:snapshots]));%��÷����ź�(����խ���źŵĶ���ʽ)
X = A*S + awgn(A*S,SNR);%�����ź�
X2 = A*S + awgn(A*S,SNR2);%�����ź�
X3 = A*S + awgn(A*S,SNR3);%�����ź�

Rx = X*X'/snapshots;%�����źŵ�Э�������
Rx2 = X2*X2'/snapshots;%�����źŵ�Э�������
Rx3 = X3*X3'/snapshots;%�����źŵ�Э�������
[Ve,Va] = eig(Rx);%��ȡЭ������������ֵVa�Լ���������Ve
[Ve2,Va2] = eig(Rx2);
[Ve3,Va3] = eig(Rx3);



En = Ve(:,1:M-D);%ȡ��M-D����Ӧ����ֵΪ�����������������
En2 = Ve2(:,1:M-D);
En3 = Ve3(:,1:M-D);


theta1 = -90:0.5:90;


%ʹ������forѭ������Ƕ�ף��������Ƕ����δ�������׷�����
for a = 1:length(theta1)
    AA = zeros(1,M);
    for b = 0:M-1
        AA(:,b+1) = exp(-1*1i*2*pi*d*sin(theta1(a)/180*pi)/lamda*b); %ע����matlab�����Ǻ�������ʹ�õ��ǻ���ֵ
    end
    P = AA*En*En'*AA';
    Pmusic(a) = abs(1/P);%�׺���
    
    P2 = AA*En2*En2'*AA';
    Pmusic2(a) = abs(1/P2);%�׺���
    
    P3 = AA*En3*En3'*AA';
    Pmusic3(a) = abs(1/P3);%�׺���
end

Pmusic = 10*log10(Pmusic/max(Pmusic));%����õ��׺�����һ������м���dB����
Pmusic2 = 10*log10(Pmusic2/max(Pmusic2));
Pmusic3 = 10*log10(Pmusic3/max(Pmusic3));
plot(theta1,Pmusic,'-r')
hold on
plot(theta1,Pmusic2,'--k')
hoold on
plot(theta1,Pmusic3,'-.k')
hold off
xlabel('�Ƕ� \theta/degree')
ylabel('�׺��� P(\theta)/dB')
title('����MUSIC�㷨��DOA����')
legend('SNR=20','SNR=40','SNR=80')
grid on

%c = find(Pmusic == max(Pmusic));
%text(theta1(c),Pmusic(c),['(',num2str(theta1(c)),',',num2str(Pmusic(c)),')'],'color','b');






