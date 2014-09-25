Img1=imread('1.jpg');
Img2=imread('2.jpg');

subplot(2,3,1);
imshow(Img1)

subplot(2,3,4)
imshow(fourierspectrum(Img1))