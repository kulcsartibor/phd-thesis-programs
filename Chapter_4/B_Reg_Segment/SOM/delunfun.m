function yk1=delunfun(uk,yk);

global modelpar tri node par
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delaunay function evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uk=max(min(node(:,2)),uk);
yk=max(min(node(:,1)),yk);
uk=min(max(node(:,2)),uk);
yk=min(max(node(:,1)),yk);



nnode=size(node,1);

T=tsearch(node(:,1),node(:,2),tri,yk,uk); %these are the active traingulars
if isnan(T) 
    nodek=zeros(size(node(tri(:,1),:)));
    for i=1:size(tri,2)
         nodek=nodek+node(tri(:,i),:);
    end
    nodek=nodek/size(tri,2);
    distan=sum((abs(repmat([yk uk],length(nodek),1)-nodek))')';    
    T=find(distan==min(distan));  
end

w=zeros(nnode,1);

anode=tri(T,:); %vector of the actual nodes

modindex=find(modelpar(:,1)==T);%the index of the active models
wl=zeros(nnode,1);
wl(anode)=(modelpar(modindex,3:end)*[[yk uk] 1]')';
yk1=wl'*par;

if yk1<min(node(:,1))
   yk1=min(node(:,1));
end

if yk1>max(node(:,1))
   yk1=max(node(:,1));
end
