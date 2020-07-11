%% main code
I0 = imread('img300x210.jpg');
I1 = double(I0);
s = size(I1);
I2 = uint8(zeros(s));
r = 16; % 雾化半径
eps = 1000;  % 雾化力度
for i = 1:s(3)
    I2(:,:,i) = uint8(m_guidedfilter(I1(:,:,i),I1(:,:,i),r,eps));
end

imshow([I0 I2]);

%% 导向滤波
function q = m_guidedfilter(I, p, r, eps)
 
%   - guidance image: I (should be a gray-scale/single channel image)
%   - filtering input image: p (should be a gray-scale/single channel image)
%   - local window radius: r
%   - regularization parameter: eps
 
[h, w] = size(I);
N = m_boxfilter(ones(h, w), r); 
 
mean_I = m_boxfilter(I, r) ./ N;
mean_p = m_boxfilter(p, r) ./ N;
mean_Ip = m_boxfilter(I.*p, r) ./ N;
% this is the covariance of (I, p) in each local patch.
cov_Ip = mean_Ip - mean_I .* mean_p; 
 
mean_II = m_boxfilter(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;
 
a = cov_Ip ./ (var_I + eps); 
b = mean_p - a .* mean_I; 
 
mean_a = m_boxfilter(a, r) ./ N;
mean_b = m_boxfilter(b, r) ./ N;
 
q = mean_a .* I + mean_b; 
end

%% 图像均值
function imDst = m_boxfilter(imSrc, r)
 
%   BOXFILTER   O(1) time box filtering using cumulative sum
%
%   - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));
%   - Running time independent of r; 
%   - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
%   - But much faster.
 
[h, w] = size(imSrc);
imDst = zeros(size(imSrc));
 
%cumulative sum over Y axis
imCum = cumsum(imSrc, 1);
%difference over Y axis
imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
imDst(r+2:h-r, :) = imCum(2*r+2:h, :) - imCum(1:h-2*r-1, :);
imDst(h-r+1:h, :) = repmat(imCum(h, :), [r, 1]) - imCum(h-2*r:h-r-1, :);
 
%cumulative sum over X axis
imCum = cumsum(imDst, 2);
%difference over Y axis
imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
imDst(:, r+2:w-r) = imCum(:, 2*r+2:w) - imCum(:, 1:w-2*r-1);
imDst(:, w-r+1:w) = repmat(imCum(:, w), [1, r]) - imCum(:, w-2*r:w-r-1);
end
