%% Clear workspace.
clear all;
close all;

%% Load data.
data=imread('n02013706_65.JPEG'); 

%% form the measurement matrix.
% imagesc(data);    % Create a colored plot of the orginal matrix values

img=im2double(data(:,:,3));    % 取第3维度的第1组256*256，并转换到（0,1)
[height,width]=size(img);    % 标记长宽度
Phi=randn(floor(height/2),width);  % choose to keep a half of X
Phi = Phi./repmat(sqrt(sum(Phi.^2,1)),[floor(height/2),1]); % normalize each column's weight

dct=zeros(84,84);  % building the DCT basis (corresponding to each column)
for i=0:1:83 
    % x=(0:width-1)'*(0:width-1);
    % W=(exp(2*pi*1i*x/width)/width);
    dct_1d=cos([0:1:83]'*i*pi/84);
    if i>0
        dct_1d=dct_1d-mean(dct_1d); 
    end
    dct(:,i+1)=dct_1d/norm(dct_1d);
end

%% Use OMP.
s = 42;
Y = Phi*img;
A = Phi*dct;
X = zeros(84,84);  % build the sparse matrix X
for i = 1: width
    y = Y(:,i);
    X(:,i) = OMP(A, y, s);  % 对每列使用OMP
end
OMP_result = dct*X;

figure(1)
subplot(2,2,1),imshow(img),title('original image')
subplot(2,2,2),imagesc(Phi),title('measurement mat')
subplot(2,2,3),imagesc(dct),title('dct mat')
subplot(2,2,4),imshow(OMP_result),title('OMP recover image')


