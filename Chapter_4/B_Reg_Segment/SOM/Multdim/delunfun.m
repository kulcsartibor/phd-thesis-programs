function yk1=delunfun(uk,yk);

global modelpar tri node par
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delaunay function evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uk=max(min(node(:,1)),uk);
yk=max(min(node(:,2)),yk);
uk=min(max(node(:,1)),uk);
yk=min(max(node(:,2)),yk);



nnode=size(node,1);
T=tsearch(node(:,1),node(:,2),tri,uk,yk); %this is the active traingular
w=zeros(nnode,1);

anode=tri(T,:); %vector of the actual nodes

modindex=find(modelpar(:,1)==T);%the index of the active models
wl=zeros(nnode,1);
wl(anode)=(modelpar(modindex,3:end)*[[uk yk] 1]')';
yk1=wl'*par;

if yk1<min(node(:,2))
   yk1=min(node(:,2));
end

if yk1>max(node(:,2))
   yk1=max(node(:,2));
end
