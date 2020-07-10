%% 方法一
Img = imread('1.jpg');
%% 将图片转换为txt保存
s = size(Img);
f = fopen('img_in.txt','w');
fprintf(f,'%d\n%d\n%d\n',s(1),s(2),s(3));
for i = 1:s(1)
    for j = 1:s(2)
        for k = 1:s(3)
            fprintf(f,'%d\n',Img(i,j,k));
        end
    end
end
fclose(f);
%% 读取txt中的图片
a = importdata('img_in.txt');
s(1:3) = a(1:3);
I0 = uint8(zeros(s));
m = 1;
for i = 1:s(1)
    for j = 1:s(2)
        for k = 1:s(3)
            I0(i,j,k) = uint8(a(m));
            m = m + 1;
        end
    end
end
clear a;
%% 处理图片 -- 这一部分转换为verilog
% I0 = imread('1.jpg');
I1 = imguidedfilter(I0);
H = I1 - I0 + 128;
core = fspecial('gaussian',[3 3],100);
G = imfilter(double(H),core);
opacity = 100; % 美颜力度
% Dest = (I1*(100 - opacity)+(I1+2*G - 256)*opacity)/100;
Dest = uint8((G - 128) * opacity / 50) + I0;
% imshow([I0 I1 Dest]);

%% 将图片转换为txt保存
s = size(Img);
f = fopen('img_out.txt','w');
fprintf(f,'%d\n%d\n%d\n',s(1),s(2),s(3));
for i = 1:s(1)
    for j = 1:s(2)
        for k = 1:s(3)
            fprintf(f,'%d\n',Dest(i,j,k));
        end
    end
end
fclose(f);
%% 展示磨皮效果
a = importdata('img_out.txt');
s(1:3) = a(1:3);
I2 = uint8(zeros(s));
m = 1;
for i = 1:s(1)
    for j = 1:s(2)
        for k = 1:s(3)
            I2(i,j,k) = uint8(a(m));
            m = m + 1;
        end
    end
end
clear a;
imshow([I0 I1 I2]);

%% 方法二
% I= double(imread('1.jpg'));
% myFFT = fft2(I); 
% myLogAmplitude = log(abs(myFFT));
% myPhase = angle(myFFT);
% mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate'); 
% saliencyMap = abs(ifft2(exp(mySpectralResidual + i*myPhase))).^2;
% imshow([uint8(I) uint8(saliencyMap)]);