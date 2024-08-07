function [c, U,J] = FCM(num_data,num_clusters,iter,m,dataSet)  
 %五个输入：样本个数、类别数、迭代次数、指数和数据集
 %三个输出：聚类中心、隶属度矩阵和目标函数
%--初始化隶属度u，条件是每一列和为1 
U = rand(num_clusters,num_data);  %返回一个在0-1之间均匀分布的随机数
col_sum = sum(U);
U = U./col_sum; 
% 循环--规定迭代次数作为结束条件
for i = 1:iter
    %更新c 聚类中心的迭代公式
    for j = 1:num_clusters
        u_ij_m = U(j,:).^m;
        sum_u_ij = sum(u_ij_m);
       c(j,:) = u_ij_m*dataSet./sum_u_ij;
    end
    %-计算目标函数J
    temp1 = zeros(num_clusters,num_data);
    for j = 1:num_clusters
        for k = 1:num_data
            temp1(j,k) = U(j,k)^m*(norm(dataSet(k,:)-c(j,:)))^2;
        end
    end
    J(i) = sum(sum(temp1));
    %更新U
    for j = 1:num_clusters
        for k = 1:num_data
            sum1 = 0;
            for j1 = 1:num_clusters
                temp = (norm(dataSet(k,:)-c(j,:))/norm(dataSet(k,:)-c(j1,:))).^(2/(m-1));
                sum1 = sum1 + temp;
            end
            U(j,k) = 1./sum1;
        end
    end
end