function out = iFCM(img)
%% 模糊c均值聚类
% img=rgb2gray(img);
[l,n] = size(img); 

dataSet = img(:);
num_clusters = 4;%类别数  4
iter = 50;%迭代次数
m = 2;%指数
num_data = size(dataSet,1);%样本个数
[c,U,J] = FCM(num_data,num_clusters, iter,m,dataSet);
[m,o] = max(U); %找到所属的类
index1 = find(o==1);   %索引第一类
index2 = find(o==2); 
index3 = find(o==3);
index4 = find(o==4);
%%%%%%
dataSet(index1) = c(1);
dataSet(index2) = c(2);
dataSet(index3) = c(3);
dataSet(index4) = c(4);
img_FCM = reshape(dataSet,l,n);
c = sort(c);

for i=1 : l
    for j=1 : n
        if img_FCM(i,j) > c(2)
            img_FCM(i,j) = 255;
        else 
            img_FCM(i,j) = 0;
        end
    end
end
out = img_FCM;
% figure;
% plot(J);
% grid on