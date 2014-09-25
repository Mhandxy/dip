ss=zeros(5,3);
for o=1:5
    for s=1:3
    [x,y]=find(DiffMinMaxMap{o,s});
    ss(o,s)=size(x,1);
    end
end
ss
for o=1:5
    for s=1:3
    [x,y]=find(DiffMinMaxMapAccurate{o,s});
    ss(o,s)=size(x,1);
    end
end
ss