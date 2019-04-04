%% Clear workspace.
clear all;
close all;

%% Load data.
data=imread('n01641577_247.JPEG');   % ���ݼ�Ϊ���Լ��ĺڰ���Ƭ256*256*3��Ϊ����ֻȡ256*256*1

%% form the measurement matrix.
% imagesc(data);    % ����ԭͼ

img=im2double(data(:,:,1));   % ȡ��3ά�ȵĵ�1��256*256����ת������0,1)
[height,width]=size(img);     % ��ǳ����
Phi=randn(floor(height/2),width);   % ѡ��A�����height
Phi = Phi./repmat(sqrt(sum(Phi.^2,1)),[floor(height/2),1]);  % ��ÿ�б�׼��
dct=zeros(84,84);  % building the DCT basis (corresponding to each column)
for i=0:1:83   % ����DFT���������ֲ��ô���������ʹ��DCT������ɢ���ұ任
     %x=(0:width-1)'*(0:width-1);   % ԭ����Ҷ�任�Ĳ��֣����ѷ���ʹ��
     %W=(exp(2*pi*1i*x/width)/width);  % ԭ����Ҷ�任�Ĳ��֣��ַ���ʹ��
    dct_1d=cos([0:1:83]'*i*pi/84);
    if i>0
        dct_1d=dct_1d-mean(dct_1d); 
    end
    dct(:,i+1)=dct_1d/norm(dct_1d);
end

%% Use IHT.
learning_rate = 0.1;  % learning rate ����Ϊ0.1
iterations = 100;  % Ϊ��ʡʱ�䣬������������Ϊ100
s = 42;  % ���ó�ʼ������s����IHT��Hs��������s��
Y = Phi*img;
A = Phi*dct;
X = zeros(84,84);  % building the sparse matrix X
for i = 1: width  % ��ͼ��ÿ�ж�ϡ��任������IHT����
    y = Y(:,i);
    X(:,i) = IHT(A, y, s, learning_rate,iterations);
end

IHT_result = dct*X;
figure(1)
subplot(2,2,1),imshow(img),title('original image')
subplot(2,2,2),imagesc(Phi),title('measurement mat')
subplot(2,2,3),imagesc(dct),title('dct mat')
subplot(2,2,4),imshow(IHT_result),title('IHT recover image')



