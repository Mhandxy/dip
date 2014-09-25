function [ hrimg ] = hazsremoval( img )
%single image haze removal

w0=0.6;                    
t0=0.1;
[h,w,channel]=size(img);

darkchannel=zeros(h,w);
for i=1:h                 
    for j=1:w
        darkchannel(i,j)=min(img(i,j,:));
    end
end
darkchannel=double(darkchannel);
maxdc=double(max(max(darkchannel)));
t=1-w0*(darkchannel/maxdc);
t=max(t,t0);
hrimg=zeros(size(img));
for i=1:channel
    hrimg(:,:,i)=(double(img(:,:,i))-(1-t)*maxdc)./t;
end
hrimg=uint8(hrimg);

