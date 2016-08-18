function [w,C] = nglearning(X,tmax,n,epszi,epszf,Ti,Tf,lambdai,lambdaf,K)

%rand('seed',0);
%Initialization
C=zeros(n,n);
t=zeros(n,n);

[dim N]=size(X); % dimension and number of the input data


%step1

w=(repmat((max(X')'-min(X')'),1,n).*rand(dim,n))+repmat(min(X')',1,n); 


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
    
    %step6
    for j=2:K
        if sqrt(sum((w(:,index(j))-w(:,index(j+1))).^2))<sqrt(sum((w(:,index(1))-w(:,index(j+1))).^2))
            C(index(j),index(j+1))=1;
            C(index(j+1),index(j))=1;
            t(index(j),index(j+1))=0;
            t(index(j+1),index(j))=0;
        else
            C(index(1),index(j+1))=1;
            C(index(j+1),index(1))=1;
            t(index(1),index(j+1))=0;
            t(index(j+1),index(1))=0;
        end
    end
    
    %step7
    for j=1:K
        connectsh=find(C(index(j),:));
        t(index(1),connectsh)=t(index(1),connectsh)+1;
        connectsv=find(C(:,index(j)));
        t(connectsv,index(1))=t(connectsv,index(1))+1;
    
        T=Ti*(Tf/Ti)^(i/tmax);
    
   
        deleteh=find(t(index(j),:)>T);
        C(index(j),deleteh)=0;
        t(index(j),deleteh)=0;
        deletev=find(t(:,index(j))>T);
        C(deletev,index(j))=0;
        t(deletev,index(j))=0;
    end
   
    %figdrawn(w,w,C,'a');
end