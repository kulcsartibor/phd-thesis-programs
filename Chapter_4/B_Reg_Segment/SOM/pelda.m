temp=node;
dist=sum((abs(repmat(x,length(node),1)-node))')';
ind1=find(dist==min(dist))          %legkozelebbi
dist(ind1)=max(dist);
ind2=find(dist==min(dist))          %masodik legkozelebbi

[i1,i2]=find(tri==ind1)         %melyik haromszogben van a legkozelebbi
[in1,in2]=find(tri(i1,:)==ind2)     %melyik haromszogben van a legkozelebbi ES a masodik 