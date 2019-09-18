%MUSIC ALOGRITHM 
%DOA ESTIMATION BY CLASSICAL_MUSIC 
clear all; 
%close all; 
clc; 
 
bbb=zeros(1,11); 
for kk=1:11 
snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];%�����(dB) 
 
aaa=zeros(1,300); 
for k=1:300 
 
source_number=1;%�ź�Դ�� 
sensor_number=8;%��Ԫ��Ŀ
N_x=1024; 
snapshot_number=N_x;%������
w=pi/4;%��Ƶ�� 
l=2*pi*3e8/w;%���� 
d=0.5*l;%��Ԫ���
 
source_doa=50;%����Ƕ�
A=[exp(-1i*(0:sensor_number-1)*d*2*pi*sin(source_doa*pi/180)/l)].'; 
 
s=10.^((snr(kk)/2)/10)*exp(1i*w*[0:N_x-1]);%�����ź� 
x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1i*randn(sensor_number,N_x));%�����ź�
 
R=x*x'/N_x; 
 

[V,D]=eig(R); 
D=diag(D); 
disp(D); 
Un=V(:,1:sensor_number-source_number); 
Gn=Un*Un'; 
 
searching_doa=-90:0.1:90;

 for i=1:length(searching_doa) 
   a_theta=exp(-1i*(0:sensor_number-1)'*2*pi*d*sin(pi*searching_doa(i)/180)/l); 
   Pmusic(i)=1./abs((a_theta)'*Gn*a_theta); 
 end 
 
%��ȡ����ֵ�Ӷ�������ֵʱ�ĽǶ�ֵ
aa=diff(Pmusic); 
aa=sign(aa); 
aa=diff(aa); 
bb=find(aa==-2)+1; 
[t1,t2]=max(Pmusic(bb)); 
estimated_source_doa=searching_doa(bb(t2)); 
aaa(:,k)=estimated_source_doa; 
end 
disp(aaa); 
 

E_source_doa=sum(aaa(1,:))/300;
disp('E_source_doa'); 
 
RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%������RMSE
disp('RMSE_source_doa'); 
disp(RMSE_source_doa); 
 
bbb(:,kk)=RMSE_source_doa; 
end 
disp(bbb); 
 
plot(snr,bbb(1,:),'k*-'); 
save CLASSICAL_MUSIC_snr_rmse.mat; 


%WMUSIC 
 
bbb=zeros(1,11); 
for kk=1:11 
snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];%�����(dB) 
 
aaa=zeros(1,300); 
for k=1:300 
 
s=10.^((snr(kk)/2)/10)*exp(1i*w*[0:N_x-1]);
x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1i*randn(sensor_number,N_x));
 
R=x*x'/N_x; 
 

[V,D]=eig(R); 
D=diag(D); 
disp(D); 
Un=V(:,1:sensor_number-source_number); 
Gn=Un*Un'; 
 
e=[1 zeros(1,sensor_number-1)].'; 
W=e*e.'; 
 
searching_doa=-90:0.1:90;
 for i=1:length(searching_doa) 
   a_theta=exp(-1i*(0:sensor_number-1)'*2*pi*d*sin(pi*searching_doa(i)/180)/l); 
   Pmusic(i)=1./abs((a_theta)'*Gn*W*Gn*a_theta); 
 end 
 
% 
aa=diff(Pmusic); 
aa=sign(aa); 
aa=diff(aa); 
bb=find(aa==-2)+1; 
[t1,t2]=max(Pmusic(bb)); 
estimated_source_doa=searching_doa(bb(t2)); 
aaa(:,k)=estimated_source_doa; 
end 
disp(aaa); 
 

E_source_doa=sum(aaa(1,:))/300; 
disp('E_source_doa'); 
 
RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);
disp('RMSE_source_doa'); 
disp(RMSE_source_doa); 
 
bbb(:,kk)=RMSE_source_doa; 
end 
disp(bbb); 
hold on 
plot(snr,bbb(1,:),'rs-'); 
 
save WMUSIC_snr_rmse.mat; 


%ROOT_MUSIC 
bbb=zeros(1,11); 
for kk=1:11 
snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];
 
aaa=zeros(1,300); 
for k=1:300 
 
s=10.^((snr(kk)/2)/10)*exp(1i*w*[0:N_x-1]);
x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1i*randn(sensor_number,N_x));
 
R=(x*x')/snapshot_number; 
[V,D]=eig(R); 
Un=V(:,1:sensor_number-source_number); 
Gn=Un*Un';
%�õ�����ʽ��ϵ��
a=zeros(1,15); 
a(15) = sum( diag(Gn,-7)); 
a(14) = sum( diag(Gn,-6)); 
a(13) = sum( diag(Gn,-5)); 
a(12) = sum( diag(Gn,-4)); 
a(11) = sum( diag(Gn,-3)); 
a(10) = sum( diag(Gn,-2)); 
a(9) = sum( diag(Gn,-1)); 
a(8) = sum( diag(Gn,0)); 
a(7) = sum( diag(Gn,1)); 
a(6) = sum( diag(Gn,2)); 
a(5) = sum( diag(Gn,3)); 
a(4) = sum( diag(Gn,4)); 
a(3) = sum( diag(Gn,5)); 
a(2) = sum( diag(Gn,6)); 
a(1) = sum( diag(Gn,7)); 
%����roots����������ʽ 
a1=roots(a) 
%�����õĸ����ҵ��ڵ�λԲ�����뵥λԲ�������Ԫ������
a2=a1(abs(a1)<1); 
[lamda,I]=sort(abs(abs(a2)-1)); 
f=a2(I(1:source_number)); 
%���ݸ��ı��ʽ��ȡ�����
estimated_source_doa=[-asin(angle(f(1))/pi)*180/pi]; 
aaa(:,k)=estimated_source_doa; 
 
disp('estimated_source_doa'); 
disp(estimated_source_doa); 
end 
disp(aaa); 
 

E_source_doa=sum(aaa(1,:))/300;
disp('E_source_doa'); 
 
RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%??300??????????????? 
disp('RMSE_source_doa'); 
disp(RMSE_source_doa); 
 
bbb(:,kk)=RMSE_source_doa; 
end 
disp(bbb); 
 
hold on 
plot(snr,bbb(1,:),'bd-'); 
 
save ROOT_MUSIC_snr_rmse.mat; 


%BEAMFORMING_MUSIC_BS1 
bbb=zeros(1,11); 
for kk=1:11 
snr=[-10 -8 -6 -4 -2 0 2 4 6 8 10];
 
aaa=zeros(1,300); 
for k=1:300 
B=4;
 
s=10.^((snr(kk)/2)/10)*exp(1i*w*[0:N_x-1]);
x=A*s+(1/sqrt(2))*(randn(sensor_number,N_x)+1i*randn(sensor_number,N_x));
 

T=1/sqrt(sensor_number)*[exp(-1i*(0:sensor_number-1)'*pi*sin(2/sensor_number)) exp(-1i*(0:sensor_number-1)'*pi*sin(4/sensor_number)) exp(-1i*(0:sensor_number-1)'*pi*sin(6/sensor_number)) exp(-1i*(0:sensor_number-1)'*pi*sin(8/sensor_number))];                                              
T1=T'*T; 
disp(T1); 
 
 
y=T'*x; 
 
R=y*y'/snapshot_number; 
 

[V,D]=eig(R); 
D=diag(D); 
disp(D); 
Un=V(:,1:B-source_number); 
Gn=Un*Un'; 
 
searching_doa=-90:0.1:90;
 for i=1:length(searching_doa) 
   a_theta=exp(-1i*(0:sensor_number-1)'*2*pi*d*sin(pi*searching_doa(i)/180)/l); 
   Pmusic(i)=1./abs((a_theta)'*T*Gn*T'*a_theta); 
 end 
 

aa=diff(Pmusic); 
aa=sign(aa); 
aa=diff(aa); 
bb=find(aa==-2)+1; 
[t1,t2]=max(Pmusic(bb)); 
estimated_source_doa=searching_doa(bb(t2)); 
aaa(:,k)=estimated_source_doa; 
end 
disp(aaa); 
 

E_source_doa=sum(aaa(1,:))/300; 
disp('E_source_doa'); 
disp(E_source_doa); 
 
RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);
disp('RMSE_source_doa'); 
disp(RMSE_source_doa); 
 
bbb(:,kk)=RMSE_source_doa; 
end 
disp(bbb); 
hold on 
plot(snr,bbb(1,:),'gx-'); 
save BEAMFORMING_MUSIC_BS1_snr_rmse.mat; 
 
legend('MUSIC','WMUSIC','ROOT-MUSIC','BEAMFORMING-MUSIC-BS1'); 
xlabel('�����SNR/dB'); 
ylabel('���������RMSE/degree'); 
grid on; 
 
 
 
