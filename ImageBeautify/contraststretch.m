function [csimg] = contraststretch(img)
%contrast stretch

imgmin=min(min(min(double(img))));
imgmax=max(max(max(double(img))));
csimg=zeros(size(img));
for i=1:size(img,3)
    csimg(:,:,i)=(double(img(:,:,i))-imgmin)/(imgmax-imgmin)*255;
end
csimg=uint8(csimg);