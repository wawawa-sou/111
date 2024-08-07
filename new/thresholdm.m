function out = thresholdm(img)
%% 阈值分割
mm = 3;
m = mean2(img);
s = std2(img);
mx = max(max(img));
% T = h + k*s;

switch mm
    case 1
        T = m + 0.5*(mx - m);
    case 2
        ratio = 0.6;
        T = ratio * mx;
    case 3
        k = 8; %可调
        T = m+ k*s;
end
bw = img < T;
[m,n] = size(bw);
for i=1 : m
    for j=1 : n
        if bw(i,j) == 1
            img(i,j) = 0;
        end
    end
end
out = img;