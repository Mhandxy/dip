clear;
file={'I1.jpg','I2.jpg'};
[img1, desp1, loc1] = sift(file{1});
[img2, desp2, loc2] = sift(file{2});

%% matching
%�������н�����ƥ��̶�
threshold=0.4;
for i=1:size(desp1,1)
    %img1��ÿ���������128ά������img2������������ļн�
    angle=acos(desp1(i,:)*desp2');
    %���Ƕȴ�С����ƥ��
    [val,ind]=sort(angle);
    %ȷ��ƥ�� ��õ����������̫С���޷�����
    if val(1)<threshold*val(2)
        match(i)=ind(1);
    else
        match(i)=0;
    end
end
%ȥ����ƥ��
match=[1:size(desp1,1);match]';
match(match(:,2)==0,:)=[];
msize=size(match,1);
%RANSAC
sample=50;
Homo=cell(sample,1);
error=zeros(sample,1);
for i=1:sample
    %���ȡ����
    randmatch=match(randperm(msize,3),:);
    %���任����
    point1=loc1(randmatch(1:3,1),1:2);
    point2=loc2(randmatch(1:3,2),1:2);
    if det([point2 ones(3,1)])==0
        Homo{i}=zeros(2,3);
        error(i)=Inf;
    else
        Homo{i}=[[point2 ones(3,1)]\point1(:,1) [point2 ones(3,1)]\point1(:,2)]';
        %�������
        point1=[loc1(match(:,1),1:2)]';
        point2=[loc2(match(:,2),1:2) ones(msize,1)]';
        err=Homo{i}*point2-point1;
        error(i)=sum(err(1,:).^2+err(2,:).^2);
    end
end
[~,ind]=min(error);
H=[Homo{ind};0 0 1];
imwrite(stiching(file{1},file{2},H),'stiching.jpg');
