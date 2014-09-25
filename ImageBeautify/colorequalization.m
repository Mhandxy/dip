function [ eqimg ] = colorequalization( img )
%Histogram Equalization

Igray=img;
if size(img,3)==3
    Igray=rgb2gray(img);
end
[h,w]=size(Igray);
pdf=zeros(256,1);
for i=1:h
    for j=1:w
        pdf(Igray(i,j)+1)=pdf(Igray(i,j)+1)+1;  
    end
end
cdf=zeros(256,1);
cdf(1)=pdf(1);
for i=2:256
    cdf(i)=cdf(i-1)+pdf(i);
end
lut=floor(cdf/cdf(256)*255);
eqimg=zeros(size(img));
for i=1:h  
    for j=1:w  
        for c=1:size(img,3)
            eqimg(i,j,c)=lut(img(i,j,c)+1);
        end
    end  
end
eqimg=uint8(eqimg);