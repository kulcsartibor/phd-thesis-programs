function [w,C,z] = oving(X,tmax,n,epszi,epszf,Ti,Tf,lambdai,lambdaf, alfai, alfaf, szigmai, szigmaf)

rand('seed',10);
%Initialization
C=zeros(n);
t=zeros(n);

[dim N]=size(X); % dimension and number of the input data

w=(repmat((max(X')'-min(X')'),1,n).*rand(dim,n))+repmat(min(X')',1,n);

%z=rand(2,n); 
cd_eu=L2_distance(w,w);
for i=1:length(w)
    cd_eu(i,i)=0;
end
[Y_trn,stress] = mdscale(cd_eu,2,'criterion','metricstress');
z=Y_trn';

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

   
    %step8
    distz=[];
    distz=sum((z-repmat(z(:,index(1)),1,size(z,2))).^2,1)';
    [distz2,indexz]=sort(distz);
    [indexz2,kindexz]=sort(indexz);
    
    distw=sum((w-repmat(w(:,index(1)),1,size(w,2))).^2,1)';
   
    %step9
    alfa=alfai*((alfaf/alfai)^(i/tmax));
    szigma=szigmai*((szigmaf/szigmai)^(i/tmax));
    for k=1:n
        if k~=index(1)
            z(:,k)=z(:,k)+alfa*exp(-((kindexz(k)-1)/szigma))*((sqrt(distz(k))-sqrt(distw(k)))/sqrt(distz(k))).*(z(:,index(1))-z(:,k));
        end
    end
    
end