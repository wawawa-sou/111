clc;
clearvars; %清除内存中的变量
close all;
flag = 1;
flagw = 0;
mm = 1;
num = 10;
% scrg = zeros(num,1);
% k = 3;%阈值分割k值
% CoreNum=8; %设定机器CPU核心数量
% if isempty(gcp('nocreate'))
%     parpool(CoreNum);
% end

elapsedTime = 0;
for kk = 1:num %图片编号
% kk = 112;
    fold = '.\time\640\';% 27 images
    % try
        img = imread([fold, num2str(kk), '.png']);
    % catch
        % img = imread([fold, num2str(kk), '.bmp']);
    % end
    img = img(:,:,1);
    img = double(img);


    % 原始图像3D图
    % [m,n] = size(img);
    % x = 1:1:n;
    % y = 1:1:m;
    % [X,Y] = meshgrid(x,y);
    
    out1 = Guafilter1(img);%变换高斯
    out2 = Guafilter2(img);%高斯
    s1 = (out1-min(min(out1)))./(max(max(out1))-min(min(out1)));
    s2 = (out2-min(min(out2)))./(max(max(out2))-min(min(out2)));
    img_sub = s1-s2;
    img_sub2 = abs(img_sub);%差

   % 
   % figure,
   % surf(X,Y,img_sub2);
   % shading interp%smooth
   % saveas(gcf, '112_i.png');
    


    img_T = thresholdm(img_sub2);%阈值分割
    tic;
    img_FCM = iFCM(img_T);%聚类
    elapsedTime = elapsedTime+toc;

    % figure,
    % surf(X,Y,img_FCM);
    % shading interp%smooth

    % figure,
    % surf(X,Y,img_T);
    % shading interp%smooth
     

    %计算信噪比增益
    % scrg(kk,1) = snrg(img,img_FCM);



%     refold = ['.\result\'];
%     if flag
%         figure; imshow(uint8(img)); title('original image');
%         figure; imshow(uint8(img_sub2)); title('difference image');
% %         figure; imshow(uint8(img_T)); title('denoised image');
%         figure; imshow(uint8(img_FCM)) ; title('cluster image');
%         imwrite(uint8(img_sub2), [refold, num2str(kk), '.png']);
%         imwrite(uint8(img_FCM), [refold, num2str(kk), '.png']);
%     end
%     if flagw
% %       refold = ['.\result1\', num2str(kk), '\'];
%         refold = ['.\fold\'];
%         if exist(refold,'dir') == 0
%             mkdir(refold);
%         end
% %       imwrite(uint8(img), [refold, num2str(kk), '1.png']);
%     try
%         img = imread([fold, num2str(kk), '.png']);
%         imwrite(uint8(img_FCM), [refold, num2str(kk), '.png']);
%     catch
%         img = imread([fold, num2str(kk), '.bmp']);
%         imwrite(uint8(img_FCM), [refold, num2str(kk), '.bmp']);
%     end
% %       imwrite(uint8(img_FCM), [refold, num2str(kk), '.png']);
% %       imwrite(bw, [refold, num2str(kk), '3.png']);
%     end
end
fprintf('图像处理程序运行时间: %.4f 秒\n', elapsedTime);