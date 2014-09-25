function  [img]=imfusion(varargin)
%image fusion from souce to target at pos
%   imfusion(target,source,pos) or imfusion(target,source,pos,mat) 
%   solve $$\Delta f=\Delta g |_{\Omega},f=f^*|_{\partial\Omega}$$
%   L*X=Lg

%% initialize
if nargin<3 || nargin>4
    error('wrong parameter input, use help for more details.')
end
target=double(varargin{1});
source=double(varargin{2});
[tm,tn,channel]=size(target);
[sm,sn,schannel]=size(source);
% mask为掩码 其中mat为0表示去除的点 为1表示保留的点
mask.pos=varargin{3};
if nargin == 3
    mask.mat=zeros(sm-2,sn-2);   
else
    mask.mat=varargin{4};
end
mask.size=size(mask.mat);
sizeofmask=mask.size(1)*mask.size(2);
maskmatreshape=reshape(mask.mat',sizeofmask,1);

if (mask.pos(1)+sm-1>tm) || (mask.pos(1)<2) || (mask.pos(2)+sn-1>tn) || (mask.pos(2)<2)
    error('mask out of range.');
end
if min(mask.size)<3
    error('mask is too small.');
end
if channel~=schannel
    error('channels of two images are different.');
end
%% 计算系数矩阵L
%稀疏矩阵表示
temp=repmat([ones(mask.size(2)-1,1);0],mask.size(1),1);
L0=[[1:sizeofmask]' [1:sizeofmask]' -4*ones(sizeofmask,1)];
Lu1=[[1:sizeofmask-1]' [2:sizeofmask]' temp(1:end-1)];
Ld1=[[2:sizeofmask]' [1:sizeofmask-1]' temp(1:end-1)];
Lu2=([[1:sizeofmask-mask.size(2)]' [mask.size(2)+1:sizeofmask]' ones(sizeofmask-mask.size(2),1)]);
Ld2=([[mask.size(2)+1:sizeofmask]' [1:sizeofmask-mask.size(2)]' ones(sizeofmask-mask.size(2),1)]);
Lall=[L0;Lu1;Lu2;Ld1;Ld2];
%去除多余方程 mask.mat==1 的点对应的方程
ind=find(maskmatreshape==1);
for i=1:length(ind)
    ti=length(ind)-i+1;
    Lall(Lall(:,1)==ind(ti),:,:)=[];
end
L=spconvert(Lall);
%% 计算Lg
%取gradf gradg最大的值对应的 Laplacian
tempimg=target(mask.pos(1)-1:mask.pos(1)+mask.size(1),mask.pos(2)-1:mask.pos(2)+mask.size(2),:);
gradfx=tempimg(2:end,2:end,:)-tempimg(1:end-1,2:end,:);
gradfy=tempimg(2:end,2:end,:)-tempimg(2:end,1:end-1,:);
gradgx=source(2:end,2:end,:)-source(1:end-1,2:end,:);
gradgy=source(2:end,2:end,:)-source(2:end,1:end-1,:);
gradgx(:,[1 end])=0;
gradgy([1 end],:)=0;
vx=gradgx;
vy=gradgy;
vx(abs(gradgx+gradgy)<0.5*abs(gradfx+gradfy))=gradfx(abs(gradgx+gradgy)<0.5*abs(gradfx+gradfy));
vy(abs(gradgx+gradgy)<0.5*abs(gradfx+gradfy))=gradfy(abs(gradgx+gradgy)<0.5*abs(gradfx+gradfy));
Lg=vx(2:end,1:end-1,:)-vx(1:end-1,1:end-1,:)+vy(1:end-1,2:end,:)-vy(1:end-1,1:end-1,:);
%% 求解位置区域颜色
%mask周围一圈补1
bmask=ones(mask.size(1)+2,mask.size(2)+2);
bmask(2:end-1,2:end-1)=mask.mat;
%对应位置的像素 边界补0
tempimg=zeros(tm+2,tn+2,3);
tempimg(2:end-1,2:end-1,:)=target;
timg=tempimg(mask.pos(1):mask.pos(1)+mask.size(1)+1,mask.pos(2):mask.pos(2)+mask.size(2)+1,:);
%分通道计算颜色
X=cell(3,1);
for i=1:channel
    %计算B 
    mimg=timg(:,:,i).*bmask;
    temp=zeros(mask.size(1),mask.size(2),4);
    temp(:,:,1)=mimg(1:end-2,2:end-1);
    temp(:,:,2)=mimg(3:end,2:end-1);
    temp(:,:,3)=mimg(2:end-1,1:end-2);
    temp(:,:,4)=mimg(2:end-1,3:end);
    B=-sum(temp,3);
    B=B+Lg(:,:,i);
    B=reshape(B',sizeofmask,1);
    B(maskmatreshape==1)=0;
    [Xi,~,~,~,~]=cgs(L,B,1e-5,300);
    X{i}=reshape(Xi,mask.size(2),mask.size(1))';
end
%确定边界
threshold=15;
A=logical((abs(X{1}-timg(2:end-1,2:end-1,1))>threshold).*(abs(X{2}-timg(2:end-1,2:end-1,2))>threshold).*(abs(X{3}-timg(2:end-1,2:end-1,3))>threshold));
LA=A;
RA=A;
UA=A;
DA=A;
for i=2:size(A,1);
    UA(i,:)=UA(i,:)+UA(i-1,:);
    DA(size(A,1)+1-i,:)=DA(size(A,1)+1-i,:)+DA(size(A,1)+2-i,:);
end
for j=2:size(A,2);
    LA(:,j)=LA(:,j)+LA(:,j-1);
    RA(:,size(A,2)+1-j)=RA(:,size(A,2)+1-j)+RA(:,size(A,2)+2-j);
end
mind=(UA.*RA.*LA.*DA>0);
%颜色填充
for i=1:channel
    ox=source(2:end-1,2:end-1,i);
    Xi=X{i};
%     Xi(mind)=ox(mind);
    target(mask.pos(1):mask.pos(1)+mask.size(1)-1,mask.pos(2):mask.pos(2)+mask.size(2)-1,i)=target(mask.pos(1):mask.pos(1)+mask.size(1)-1,mask.pos(2):mask.pos(2)+mask.size(2)-1,i).*mask.mat+Xi;
end
img=uint8(target);
end