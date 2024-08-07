function out = Guafilter1( img )
%% 变换高斯滤波
%% inputs:
% img: the original image
%% output:
% out: output inverse Guassian filtered image
%% 
img = double(img);
%% 实现n0*n0的变换高斯模板
k = 2;  %需调1
N_size = 2*k;  %size模板长度，假设为6
center_N = N_size/2; %模板中心位置，这里假设模板长度为偶数
N_row = N_size;
N_col = N_size;
% array_sigma = 4:0.5:8; %标准差数组，对模板的影响很大
% Map_X = 1:N_row; Map_Y = 1:N_col; % 作3维图的横坐标
%% 根据模板大小对原图像边缘进行填充
img_P = padarray(img,[k,k],'symmetric'); %扩充数值方式可调
%% 高斯模板处理前后对比图
% figure('Name', '不同标准差滤波效果')

sigma = 3;  %需调0.5-6
for i=1 : N_row
    for j=1 : N_col
        % distance_s = double((sqrt((i-center_N)^2 + (j-center_N)^2)-k)^2);
        distance_s = double((sqrt((abs(i-center_N))^3+(abs(j-center_N))^3)-k)^2); %绝对值的3倍再开根号
        w(i,j)=exp((-1) * distance_s/(2*sigma^2))/(sqrt(2*pi)*sigma);
    end
end

% subplot(3,3,m);
w_Img = imfilter(img_P,w);
[m,n] = size(w_Img);
out = w_Img(k+1:m-k,k+1:n-k);
% out = uint8(out);
% imshow(w_Img);title(num2str(sigma));

