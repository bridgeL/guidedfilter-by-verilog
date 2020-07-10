%% main code
%% ר��Ϊ��ƶ�Ӧ��verilog������Ż�����m����
% �����Ʒ������������׿�ƣ�����ΰ
I0 = imread('img300x210.jpg');

% ��ֻ����ͨ��
I0 = I0(:,:,3);

%% �����˲�
h = 300;    w = 210;

% ��ȡ���ݣ�����32λ300x210 ram��
I = uint32(I0);
II = I.*I; 

mean_I = test(I);
mean_II = test(II);

rt = 128; % ����������������
cov_Ip = mean_II -  mean_I .* mean_I; 
a = (cov_Ip * rt) ./ (cov_Ip + 400) ;
b = (mean_I * rt) - a .* mean_I; 
 
mean_a = test(a);
mean_b = test(b);

I2 = (mean_a .* I + mean_b)/rt ; 

%% չʾ
I3 = uint8(I2);

imshow([I0 I3]);

%% ��ֵ�˲�
function q = test(p)

h = 300;    w = 210;

for i = 1:h
    for j = 1:w
        aa((i-1)*w+j) = uint32(p(i,j));
    end
end

% fprintf('============');
% max(aa)

for i = 1:w*h
    if(i>=8 && i<=w*h-8)
        bb(i) = sum(aa(i-7:i+8));
    else
        bb(i) = 0;
    end
end

for i = 1:w*h
    if(i>=8*w && i<=w*h-8*w)
        aa(i) = sum(bb(i-7*w:w:i+8*w));
    else
        aa(i) = 0;
    end
end

for i = 1:h
    for j = 1:w
        q(i,j) = aa((i-1)*w+j)/256;
    end
end

% max(aa)

end

