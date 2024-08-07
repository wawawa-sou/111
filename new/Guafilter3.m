function out = Guafilter3( img )
%% 原始高斯高通滤波
%% inputs:
% img: the original image
%% output:
% out: output Guassian filtered image
%% 
img = double(img);
%% 实现n0*n0的高斯低通模板
k = 5; %需调  一般为1或2   2
N_size = 2*k;  %size模板长度，假设为5
center_N = N_size/2; %模板中心位置，这里假设模板长度为奇数
N_row = N_size;
N_col = N_size;
% array_sigma = 0.7:0.2:2.5; %标准差数组，对模板的影响很大
% Map_X = 1:N_row; Map_Y = 1:N_col; % 作3维图的横坐标
%% 根据模板大小对原图像边缘进行填充
img_P = padarray(img,[k,k],'symmetric'); %扩充数值方式可调
%% 高斯模板处理前后对比图
sigma = 5; %需调   0.5
for i=1 : N_row
    for j=1 : N_col
        distance_s = double((i-center_N)^2 + (j-center_N)^2);
        w(i,j)=1-exp((-1) * distance_s/(2*sigma^2))/(2*pi*(sigma^2));
    end
end

w_Img = imfilter(img_P,w);
[m,n] = size(w_Img);
out = w_Img(k+1:m-k,k+1:n-k);
%     w_Img = uint8(w_Img);
%     imshow(w_Img);title(num2str(sigma));
