I0 = imread('1.jpg');
I2 = m_imguidedfilter(I0);
H = I2 - I0 + 128;
core = [    0.1111    0.1111    0.1111
    0.1111    0.1111    0.1111
    0.1111    0.1111    0.1111];
G = imfilter(double(H),core);
opacity = 50; 
% Dest = (I1*(100 - opacity)+(I1+2*G - 256)*opacity)/100;
Dest = uint8((G - 128) * opacity / 50) + I0;
imshow([I0 I2 Dest]);