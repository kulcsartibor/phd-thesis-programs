function [w,C,tc] = trn(X,tmax,n,epszi,epszf,Ti,Tf,lambdai,lambdaf)

%rand('seed',10);
%Initialization
C=zeros(n);
t=zeros(n);
tc=zeros(n);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dim N]=size(X); % dimension and number of the input data
range=1.2; % factor of the data range


%step1
% minx=min(X(1,:));
% maxx=max(X(1,:));
% miny=min(X(2,:));
% maxy=max(X(2,:));
% if size(X,1)==2
%     w=[(maxx-minx)*1.1*rand(1,n)+minx; (maxy-miny)*1.1*rand(1,n)+miny];
% elseif size(X,1)==3
%     minz=min(X(3,:));
%     maxz=max(X(3,:));
%     w=[(maxx-minx)*1.1*rand(1,n)+minx; (maxy-miny)*1.1*rand(1,n)+miny; (maxy-miny)*1.1*rand(1,n)+minz];   
% end
w=(repmat((max(X')'-min(X')'),1,n).*rand(dim,n))+repmat(min(X')',1,n); %*((range-1)/2) %*range


for i=1:tmax
    
    %step2
    v=X(:,floor(N*rand)+1);
    
    %step3
    dist=[];
    dist=sum((w-repmat(v,1,size(w,2))).^2,1)';
    [dist2,index]=sort(dist);
    [index2,kindex]=sort(index);
    
    %step4
    lambda=lambdai*((lambdaf/lambdai)^(i/tmax));
    epsz=epszi*((epszf/epszi)^(i/tmax));
    for k=1:n
        w(:,k)=w(:,k)+epsz.*exp(-(kindex(k)-1)/lambda)*(v-w(:,k));
    end
    
    %step5
    C(index(1),index(2))=1;
    C(index(2),index(1))=1;
    t(index(1),index(2))=0;
    t(index(2),index(1))=0;
    tc(index(1),index(2))=tc(index(1),index(2))+(i/tmax);%%%%%%%%%%%%%%%%%%
    tc(index(2),index(1))=tc(index(2),index(1))+(i/tmax);%%%%%%%%%%%%%%%%%%
    
    
    %step6
    connectsh=find(C(index(1),:));
    t(index(1),connectsh)=t(index(1),connectsh)+1;
    connectsv=find(C(:,index(1)));
    t(connectsv,index(1))=t(connectsv,index(1))+1;
    
    
   %step7
   T=Ti*(Tf/Ti)^(i/tmax);
   deleteh=find(t(index(1),:)>T);
   C(index(1),deleteh)=0;
   t(index(1),deleteh)=0;
   deletev=find(t(:,index(1))>T);
   C(deletev,index(1))=0;
   t(deletev,index(1))=0;
   
end


