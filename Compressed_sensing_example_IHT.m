%% Clear workspace.
clear all;
close all;

%% Load data.
data=imread('n01641577_247.JPEG');   % 数据集为我自己的黑白照片256*256*3，为方便只取256*256*1

%% form the measurement matrix.
% imagesc(data);    % 绘制原图

img=im2double(data(:,:,1));   % 取第3维度的第1组256*256，并转换到（0,1)
[height,width]=size(img);     % 标记长宽度
Phi=randn(floor(height/2),width);   % 选择A矩阵的height
Phi = Phi./repmat(sqrt(sum(Phi.^2,1)),[floor(height/2),1]);  % 对每列标准化
dct=zeros(84,84);  % building the DCT basis (corresponding to each column)
for i=0:1:83   % 由于DFT的虚数部分不好处理，在这里使用DCT来做离散余弦变换
     %x=(0:width-1)'*(0:width-1);   % 原傅里叶变换的部分，现已放弃使用
     %W=(exp(2*pi*1i*x/width)/width);  % 原傅里叶变换的部分，现放弃使用
    dct_1d=cos([0:1:83]'*i*pi/84);
    if i>0
        dct_1d=dct_1d-mean(dct_1d); 
    end
    dct(:,i+1)=dct_1d/norm(dct_1d);
end

%% Use IHT.
learning_rate = 0.1;  % learning rate 设置为0.1
iterations = 100;  % 为节省时间，迭代次数设置为100
s = 42;  % 设置初始化变量s，即IHT中Hs留下最大的s个
Y = Phi*img;
A = Phi*dct;
X = zeros(84,84);  % building the sparse matrix X
for i = 1: width  % 对图像每列都稀疏变换，进行IHT操作
    y = Y(:,i);
    X(:,i) = IHT(A, y, s, learning_rate,iterations);
end

IHT_result = dct*X;
figure(1)
subplot(2,2,1),imshow(img),title('original image')
subplot(2,2,2),imagesc(Phi),title('measurement mat')
subplot(2,2,3),imagesc(dct),title('dct mat')
subplot(2,2,4),imshow(IHT_result),title('IHT recover image')



