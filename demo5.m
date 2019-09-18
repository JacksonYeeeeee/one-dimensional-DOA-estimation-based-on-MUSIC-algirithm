%the relationship between DOA estimation and SNR

clc
clear all
format long
N=200;
doa=[20 60]/180*pi;
w=[pi/4 pi/3]';
M=10;
P=length(w);
lambda=150;
d=lambda/2;
snr1=-20;
snr2=0;
snr3=20;
D=zeros(P,M);
for k=1:P
D(k,:)=exp(-j*2*pi*d*sin(doa(k))/lambda*[0:M-1]);
end
D=D';
xx=2*exp(j*(w*[1:N]));
x=D*xx;
x1=x+awgn(x,snr1);
x2=x+awgn(x,snr2);
x3=x+awgn(x,snr3);
R1=x1*x1';
R2=x2*x2';
R3=x3*x3';
[N1,V1]=eig(R1);
[N2,V2]=eig(R2);
[N3,V3]=eig(R3);
NN1=N1(:,1:M-P);
NN2=N2(:,1:M-P);
NN3=N3(:,1:M-P);
theta=-90:0.5:90;
for ii=1:length(theta)
SS=zeros(1,length(M));
for jj=0:M-1
SS(1+jj)=exp(-j*2*jj*pi*d*sin(theta(ii)/180*pi)/lambda);
end
PP1=SS*NN1*NN1'*SS';
PP2=SS*NN2*NN2'*SS';
PP3=SS*NN3*NN3'*SS';
Pmusic1(ii)=abs(1/ PP1);
Pmusic2(ii)=abs(1/ PP2);
Pmusic3(ii)=abs(1/ PP3);
end
Pmusic1=10*log10(Pmusic1/max(Pmusic1));
Pmusic2=10*log10(Pmusic2/max(Pmusic2));
Pmusic3=10*log10(Pmusic3/max(Pmusic3));
plot(theta,Pmusic1,'--k','linewidth',2.0)
hold on
plot(theta,Pmusic2,'-k','linewidth',1.0)
hold on
plot(theta,Pmusic3,'-.k','linewidth',0.1)
hold off
xlabel('angle \theta/degree')
ylabel('spectrum function P(\theta) /dB')
title('DOA estimation based on MUSIC algorithm')
legend('the SNR is -20 dB','the SNR is 0 dB','the SNR is 20 dB')
grid on