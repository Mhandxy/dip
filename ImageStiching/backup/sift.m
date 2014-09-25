%% initialize
clear;
img=imread('lena.jpg');
%gray 
[m,n,channel]=size(img);
if channel > 1
    img = rgb2gray(img);
end
img = double(img)/255;
%Parameters:S,Sigma0,k,OctaveNum
S=3;
Sigma0=1.6;
k=2^(1/S);
OctaveNum=floor(log(min(m,n))/log(2))+1;
OctaveNum=min(5,OctaveNum);
%% gaussian sigma
Sigma=cell(OctaveNum,S+3);
for o=1:OctaveNum
    if o==1
        Sigma{o,1}=0.5;
    else
        Sigma{o,1}=Sigma0*2^(o-2);
    end
    for s=2:S+3
        Sigma{o,s}=Sigma{o,s-1}*k;
    end
end
%% gaussian images
Gaussian=cell(OctaveNum,S+3);
for o=1:OctaveNum
    for s=1:S+3
        if o==1
            Gaussian{o,s}=gaussianblur(imresize(img,2,'nearest'),Sigma{o,s});
        else
            Gaussian{o,s}=imresize(gaussianblur(img,Sigma{o,s}),0.5^(o-2),'nearest');
        end
    end    
end
%% difference-of-gaussian images
DOG=cell(OctaveNum,S+2);
for o=1:OctaveNum
    for s=1:S+2
        DOG{o,s}=double(Gaussian{o,s+1})-double(Gaussian{o,s});
    end    
end
%% key point
KeyPoint=cell(OctaveNum,S);
for o=1:OctaveNum
    [tm,tn]=size(DOG{o,1});
    %temp包含每个点周围3*3*3=27个点
    temp=zeros(tm-2,tn-2,27);
    for s=2:S+1
        KeyPoint{o,s-1}= false(tm,tn);
        for k=1:9
            [i,j] = ind2sub([3,3],k);
            temp(:,:,k) = DOG{o,s-1}(i:end-3+i,j:end-3+j);
            temp(:,:,9+k) = DOG{o,s}(i:end-3+i,j:end-3+j);
            temp(:,:,18+k) = DOG{o,s+1}(i:end-3+i,j:end-3+j);
        end
%         %避免有多个最大值，在temp中心的值做微调
%         temp(14)=temp(14);
%         temp(14)=temp(14);
        [~,minind]=min(temp,[],3);
        minind=(minind==14);
        [~,maxind]=max(temp,[],3);
        maxind=(maxind==14);
        KeyPoint{o,s-1}(2:end-1,2:end-1)=maxind|minind;
    end
end
OldKP=KeyPoint;
%% Accurate keypoint localization
for o=1:OctaveNum
    for s=1:S
        [xind,yind]=find(KeyPoint{o,s});
        for i=1:length(xind)
            xi=xind(i);
            yi=yind(i);
            %差分代替偏导
            Dx=(DOG{o,s+1}(xi+1,yi)-DOG{o,s+1}(xi-1,yi))/2;
            Dxx=(DOG{o,s+1}(xi+1,yi)+DOG{o,s+1}(xi-1,yi)-2*DOG{o,s+1}(xi,yi));
            Dy=(DOG{o,s+1}(xi,yi+1)-DOG{o,s+1}(xi,yi-1))/2;
            Dyy=(DOG{o,s+1}(xi,yi+1)+DOG{o,s+1}(xi,yi-1)-2*DOG{o,s+1}(xi,yi));
            Ds=(DOG{o,s+2}(xi,yi)-DOG{o,s}(xi,yi))/2;
            D2s=(DOG{o,s+2}(xi,yi)+DOG{o,s}(xi,yi)-2*DOG{o,s+1}(xi,yi));
            %计算偏移量
            offset=[-Dx/Dxx,-Dy/Dyy,-Ds/D2s]';
            %出现无穷大，说明该点相邻3个点的值相同，偏移量取0
            offset(abs(offset)==Inf)=0;
            %暂不考虑极值点的移动
            D=DOG{o,s+1}(xi,yi)+1/2*[Dx,Dy,Ds]*offset;
            if abs(D)<0.03
                KeyPoint{o,s}(xi,yi)=0;
            end
        end
    end
end
%% Eliminating edge responses
r=10;
threshold=(r+1)^2/r;
for o=1:OctaveNum
    for s=1:S
        [xind,yind]=find(KeyPoint{o,s});
        for i=1:length(xind)
            xi=xind(i);
            yi=yind(i);
            %差分代替偏导
            Dxx=(DOG{o,s+1}(xi+1,yi)+DOG{o,s+1}(xi-1,yi)-2*DOG{o,s+1}(xi,yi));
            Dyy=(DOG{o,s+1}(xi,yi+1)+DOG{o,s+1}(xi,yi-1)-2*DOG{o,s+1}(xi,yi));
            Dxy=(DOG{o,s+1}(xi-1,yi+1)+DOG{o,s+1}(xi+1,yi-1)-DOG{o,s+1}(xi-1,yi-1)-DOG{o,s+1}(xi+1,yi+1))/4;
            offset=[-Dx/Dxx,-Dy/Dyy,-Ds/D2s]';
            if (Dxx+Dyy)/(Dxx*Dyy-Dxy^2)<threshold
                KeyPoint{o,s}(xi,yi)=0;
            end
        end
    end
end
%% direction of key point
for o=1:OctaveNum
    for s=1:S+2
    end
end
ss=zeros(5,3);
for o=1:5
    for s=1:3
    [x,y]=find(OldKP{o,s});
    ss(o,s)=size(x,1);
    end
end
ss
ss=zeros(5,3);
for o=1:5
    for s=1:3
    [x,y]=find(KeyPoint{o,s});
    ss(o,s)=size(x,1);
    end
end
ss
Img=imread('lena.jpg');
Img(KeyPoint{2,1}|KeyPoint{2,2}|KeyPoint{2,3})=255;
imshow(Img)