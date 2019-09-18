clear all;
clc;


%CLASSIC MUSIC RMSE
bbb=zeros(1,10);
for kk=1:10
sensor_number=[3 4 6 8 10 12 14 16 18 20];%����Ԫ��ĿΪ�Ա���

aaa=zeros(1,300); %ÿһ����Ԫ���£�����300��MonteCarlo����
for k=1:300

N_x=1024;
snapshot_number=N_x;%������
w=pi/4;
l=2*pi*3e8/w;
d=0.5*l;%��Ԫ���
snr=0;%�����(dB)
source_number=1; %һ���ź�Դ
source_doa=50;%�ź�Դ������Ƕ�
A=[exp(-j*(0:sensor_number(kk)-1)*d*2*pi*sin(source_doa*pi/180)/l)].';
s=10.^((snr/2)/10)*exp(j*w*[0:N_x-1]);
x=A*s+(1/sqrt(2))*(randn(sensor_number(kk),N_x)+j*randn(sensor_number(kk),N_x));%���˸�˹��������Ľ�������ʸ��
R=x*x'/snapshot_number;


[V,D]=eig(R);
D=diag(D);

Un=V(:,1:sensor_number(kk)-source_number); %�����ӿռ�
Gn=Un*Un';

searching_doa=-90:0.1:90;
 for i=1:length(searching_doa)
   a_theta=exp(-j*(0:sensor_number(kk)-1)'*2*pi*d*sin(pi*searching_doa(i)/180)/l);
   Pmusic(i)=1./abs((a_theta)'*Gn*a_theta); %��������MUSIC�Ŀռ���
 end

%�ҳ��׷�����Ӧ�ļ�ֵ�㣬�����Ƴ�����Ƕ�
aa=diff(Pmusic);
aa=sign(aa);
aa=diff(aa);
bb=find(aa==-2)+1;
[t1 t2]=max(Pmusic(bb));
estimated_source_doa=searching_doa(bb(t2));

aaa(:,k)=estimated_source_doa;

end  %�ڲ�ѭ������

%�����������
RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%�ڸ���Ԫ���£���300������ľ��������
bbb(:,kk)=RMSE_source_doa;

end  %���ѭ������


plot(sensor_number,bbb(1,:),'rs-');  %����MUSIC�㷨RMSE����Ԫ���仯������
save CLASSICAL_MUSIC_zhenyuan.mat;




%ROOT MUSIC RMSE
bbb=zeros(1,10);
for kk=1:10
sensor_number=[3 4 6 8 10 12 14 16 18 20];  %����Ԫ��ĿΪ�Ա���

aaa=zeros(1,300);
for k=1:300
    
A=[exp(-j*(0:sensor_number(kk)-1)*d*2*pi*sin(source_doa*pi/180)/l)].';
s=10.^((snr/2)/10)*exp(j*w*[0:N_x-1]);
x=A*s+(1/sqrt(2))*(randn(sensor_number(kk),N_x)+j*randn(sensor_number(kk),N_x));
R=(x*x')/snapshot_number;

[V,D]=eig(R);%��Э���������������ֽ�
Un=V(:,1:sensor_number(kk)-source_number);
Gn=Un*Un'
%�ҳ�����ʽ��ϵ�������������Ӹ���������
a = zeros(2*sensor_number(kk)-1,1)';
for i=-(sensor_number(kk)-1):(sensor_number(kk)-1)
    a(i+sensor_number(kk)) = sum( diag(Gn,i) );
end

%ʹ��ROOTS�����������ʽ�ĸ�
a1=roots(a)
%�ҳ��ڵ�λԲ������ӽ���λԲ��N����
a2=a1(abs(a1)<1);
%��ѡ����ӽ���λԲ��N����
[lamda,I]=sort(abs(abs(a2)-1));
f=a2(I(1:source_number));
%�����źŵ��﷽���
estimated_source_doa=[asin(angle(f(1))/pi)*180/pi];
aaa(:,k)=estimated_source_doa;

end  %�ڲ�ѭ������

%�����������
RMSE_source_doa=sqrt(sum((aaa(1,:)-source_doa).^2)/300);%�ڸ���Ԫ���£���300������ľ��������
bbb(:,kk)=RMSE_source_doa;

end %���ѭ������


hold on
plot(sensor_number,bbb(1,:),'gp-'); %��ͬһ��ͼ�л���ROOT-MUSIC�㷨RMSE����Ԫ���仯������

save ROOT_MUSIC_zhenyuan.mat;

legend('����MUSIC','ROOT-MUSIC');
xlabel('��Ԫ��Ŀ/��');
ylabel('���ƾ��������/��');
grid on;