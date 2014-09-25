%ºØÃÂ’’∆¥Ω”
target=imread('all.jpg');
source=imresize(imread('images\f4.jpg'),0.26);
source=source(3:end-20,80:end-50,:);
pos=[980 1400];
target=imfusion(target,source,pos);

source=imresize(imread('images\f5.jpg'),0.1);
source=source(60:end-10,10:end-10,:);
% imshow(source);
pos=[940 2820];
target=imfusion(target,source,pos);

source=imresize(imread('images\f2.jpg'),1.1);
source=source(100:end-170,50:end-220,:);
pos=[830 2710];
target=imfusion(target,source,pos);

source=imresize(imread('images\f1.jpg'),0.27);
source=source(20:end-420,10:end-10,:);
pos=[970 1810];
target=imfusion(target,source,pos);

source=imresize(imread('images\f3.jpg'),0.34);
source=source(20:end-260,180:end-240,:);
pos=[830 3010];
target=imfusion(target,source,pos);

imwrite(target,'fusion.jpg');