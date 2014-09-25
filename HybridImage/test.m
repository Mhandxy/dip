Img1=imread('2.jpg');
Img2=imread('1.jpg');
Img1(:,:,1)=Img1(:,:,1)/3+Img1(:,:,2)/3+Img1(:,:,3)/3;
Img1(:,:,2)=Img1(:,:,1);
Img1(:,:,3)=Img1(:,:,1);
Img2(:,:,1)=Img2(:,:,1)/3+Img2(:,:,2)/3+Img2(:,:,3)/3;
Img2(:,:,2)=Img2(:,:,1);
Img2(:,:,3)=Img2(:,:,1);
[m1,n1]=size(Img1(:,:,1));
[m2,n2]=size(Img2(:,:,1));
m=min([m1,m2]);
n=min([n1,n2]);
%Img1=imresize(Img1,[m,n]);
%Img2=imresize(Img2,[m,n]);
subplot(2,3,1);
imshow(Img1);
subplot(2,3,2);
imshow(Img2);
LP=fspecial('gaussian',max([m n]),4); 
if m>n
    LP=LP(:,floor((m-n)/2+1):floor((m+n)/2));
else
    LP=LP(floor((n-m)/2+1):floor((n+m)/2),:);
end
LP=(LP-min(min(LP)))/(max(max(LP))-min(min(LP)));

LPImg=zeros(m,n,3);
LPImg(:,:,1)=ifft2(fftshift(fft2(Img1(:,:,1),m,n)).*LP);
LPImg(:,:,2)=ifft2(fftshift(fft2(Img1(:,:,2),m,n)).*LP);
LPImg(:,:,3)=ifft2(fftshift(fft2(Img1(:,:,3),m,n)).*LP);
LPImg=uint8(abs(LPImg));
subplot(2,3,4)
imshow(LPImg);

HP=ones(size(LP))-LP*0.6;
%HP=LP;
HPImg=zeros(m,n,3);
HPImg(:,:,1)=ifft2(fftshift(fft2(Img2(:,:,1),m,n)).*HP);
HPImg(:,:,2)=ifft2(fftshift(fft2(Img2(:,:,2),m,n)).*HP);
HPImg(:,:,3)=ifft2(fftshift(fft2(Img2(:,:,3),m,n)).*HP);
HPImg=uint8(abs(HPImg));
subplot(2,3,5)
imshow(HPImg);

subplot(2,3,3);
HImg=abs(ifft2(fft2(LPImg,m,n)+fft2(HPImg,m,n))/1.5);
imshow(uint8(HImg));
imwrite(uint8(HImg),'sd.png')