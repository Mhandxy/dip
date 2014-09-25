function simg=stiching(imgfile1,imgfile2,Homo)

%读取图像
img1=imread(imgfile1);
img2=imread(imgfile2);

%计算新图像大小和位置
[m1,n1,channel]=size(img1);
[m2,n2,~]=size(img2);
corner1=[1 1;1 n2;m2 1;m2 n2]';
corner2=[1 1 1;1 n2 1;m2 1 1;m2 n2 1]'; 
trcorner=Homo*corner2;
trcorner=trcorner(1:2,:);
corner=[trcorner corner1];
stmin=floor(min(corner,[],2));
newsize=ceil(max(corner,[],2)-min(corner,[],2))';
simg=zeros(newsize(1),newsize(2),channel);
%图像变换
for i=1:newsize(1)
    for j=1:newsize(2)
        opos=floor(Homo\[i+stmin(1)-1;j+stmin(2)-1;1]);
        if(~(opos(1)<1||opos(1)>size(img2,1)||opos(2)<1||opos(2)>size(img2,2)))
            simg(i,j,:)=img2(opos(1),opos(2),:);
        end
    end
end
simg=uint8(simg);
simg(1-stmin(1)+1:size(img1,1)-stmin(1)+1,1-stmin(2)+1:size(img1,2)-stmin(2)+1,:)=img1;
end
