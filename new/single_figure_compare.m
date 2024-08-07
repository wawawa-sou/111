% 计算小目标区域与周围背景区域的对比度
clc;
clearvars; %清除内存中的变量
% close all;
% k = 8;%阈值分割k值

kk = 17;
fold = '.\figure\';% 27 images
img = imread([fold, num2str(kk), '.png']);
img = img(:,:,1);
img = double(img);
% figure; imshow(uint8(img));

out1 = Guafilter1(img);%变换高斯
out2 = Guafilter2(img);%高斯
s1 = (out1-min(min(out1)))./(max(max(out1))-min(min(out1)));
s2 = (out2-min(min(out2)))./(max(max(out2))-min(min(out2)));
img_sub = s1-s2;
img_sub2 = abs(img_sub);%差

% 定义小目标区域的坐标 (这里假设为矩形区域)
target_x = 216; % 小目标区域左上角的x坐标
target_y = 276; % 小目标区域左上角的y坐标
target_width = 4; % 小目标区域的宽度
target_height = 3; % 小目标区域的高度

% 提取小目标区域
target_region_out2 = out2(target_y:(target_y+target_height-1), target_x:(target_x+target_width-1));
target_region_img_sub2 = img_sub2(target_y:(target_y+target_height-1), target_x:(target_x+target_width-1));

% 定义背景区域的坐标 (这里假设为矩形区域)
background_x = 195; % 背景区域左上角的x坐标
background_y = 263; % 背景区域左上角的y坐标
background_width = 45; % 背景区域的宽度
background_height = 35; % 背景区域的高度

% 提取背景区域
background_region_out2 = out2(background_y:(background_y+background_height-1), background_x:(background_x+background_width-1));
background_region_img_sub2 = img_sub2(background_y:(background_y+background_height-1), background_x:(background_x+background_width-1));

% 计算小目标区域和背景区域的平均灰度值
mean_target_out2 = mean(target_region_out2(:));
mean_background_out2 = mean(background_region_out2(:));

mean_target_img_sub2 = mean(target_region_img_sub2(:));
mean_background_img_sub2 = mean(background_region_img_sub2(:));

% 计算对比度
contrast_out2 = abs(mean_target_out2 - mean_background_out2) / mean_background_out2;
contrast_img_sub2 = abs(mean_target_img_sub2 - mean_background_img_sub2) / mean_background_img_sub2;

% 显示计算结果
fprintf('小目标与背景的对比度变换高斯滤波: %.4f\n', contrast_out2);
fprintf('小目标与背景的对比度差值图像: %.4f\n', contrast_img_sub2);

% figure,
% surf(X,Y,out1);
% shading interp%smooth
% 
% figure,
% surf(X,Y,img_sub2);
% shading interp%smooth
% saveas(gcf, '112_i.png');

% img_T = thresholdm(img_sub2);%阈值分割
% img_FCM = iFCM(img_T);%聚类
