w = 300;h = 400;
NN = m_boxfilter_uint16(uint16(ones(h, w))); 

N = uint16(zeros(1,w*h));
for i = 1:w*h
    N(i) = NN(i);
end

n = length(N);

f = fopen('NL.mif','wt');
fprintf(f,'depth = %d;\n',65536);
fprintf(f,'width = %d;\n',16);
fprintf(f,'address_radix = UNS;\n');
fprintf(f,'data_radix = DEC;\n');
fprintf(f,'content begin\n');
for i = 1 : 65536
    fprintf(f,'%d:%d;\n',i-1,N(i) );
end
fprintf(f, 'end;');
fclose(f);

f = fopen('NH.mif','wt');
fprintf(f,'depth = %d;\n',65536);
fprintf(f,'width = %d;\n',16);
fprintf(f,'address_radix = UNS;\n');
fprintf(f,'data_radix = DEC;\n');
fprintf(f,'content begin\n');
for i = 1 : 65536
    if(i+65536<=n)
        fprintf(f,'%d:%d;\n',i-1,N(i+65536) );
    else
        fprintf(f,'%d:%d;\n',i-1,0 );
    end
end
fprintf(f, 'end;');
fclose(f);

%% 
function imDst = m_boxfilter_uint16(imSrc)

% 注意：如果只做了一个方向上的美化，则最终的图片会有明显的横纹/竖纹
h = 400;    w = 300;
imTmp = uint16(zeros(h,w));
imDst = uint16(zeros(h,w));

% 横向美化
sum = uint16(zeros(1,w));
for i = 1:h+40
    if (i<=h)
        sum = sum + imSrc(i,:);
    end
    
    if (i>40)
        sum = sum - imSrc(i-40,:);
    end
    
    if (i>20 && i<=h+20)
        imTmp(i-20,:) = sum;
    end
end

% 纵向美化
sum = uint16(zeros(h,1));
for i = 1:w+40
    if (i<=w)
        sum = sum + imTmp(:,i);
    end
    
    if (i>40)
        sum = sum - imTmp(:,i-40);
    end
    
    if (i>20 && i<=w+20)
        imDst(:,i-20) = sum;
    end
end

end