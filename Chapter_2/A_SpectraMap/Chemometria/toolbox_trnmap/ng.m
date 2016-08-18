function [w] = ng(X,tmax,n,epszi,epszf,lambdai,lambdaf)

%rand('seed',0);
%Initialization
t=zeros(n);

[dim N]=size(X); % dimension and number of the input data
range=1.2; % factor of the data range


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
    
end