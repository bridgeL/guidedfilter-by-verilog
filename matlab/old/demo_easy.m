%% main code
I0 = imread('img450x320.jpg');

% 先只做单通道
I0 = I0(:,:,1);

I1 = double(I0);
I2 = uint8(m_guidedfilter(I1,I1));

imshow([I0 I2]);

%% 导向滤波
function q = m_guidedfilter(I, p)
 
[h, w] = size(I);
N = m_boxfilter(ones(h, w)); 
 
mean_I = m_boxfilter(I) ./ N;
mean_p = m_boxfilter(p) ./ N;
mean_Ip = m_boxfilter(I.*p) ./ N;

% this is the covariance of (I, p) in each local patch.
cov_Ip = mean_Ip - mean_I .* mean_p; 
 
mean_II = m_boxfilter(I.*I) ./ N;
var_I = mean_II - mean_I .* mean_I;
 
a = cov_Ip ./ (var_I + 100); 
b = mean_p - a .* mean_I; 
 
mean_a = m_boxfilter(a) ./ N;
mean_b = m_boxfilter(b) ./ N;
 
q = mean_a .* I + mean_b; 
end

%% 图像均值
function imDst = m_boxfilter(imSrc)

r = 20; % 雾化半径
 
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
