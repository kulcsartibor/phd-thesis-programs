function [M] = isotop_map(w,D,Gk,alfai,alfaf,lambdai,lambdaf,tmax)
%rossz!!!!!!

%The IsoTop function
%dfva

[n dim]=size(w);
M=(rand(2,n)-repmat([0.5;0.5],1,n))*2;

% alfai=0.9;
% alfaf=0.1;
% lambdai=10;
% lambdaf=2;

%step1 VQ
% [w] = neural_gas(X',n, 20);

%step2 building a graph
dist_eu=L2_distance(w',w');
% Gk = knngraph2(dist_eu, kepszvalue, kepsz);
% D=geo_dist(w',Gk);

%step3 mapping
for i=1:tmax
    
    %g=M(:,floor(n*rand)+1);
    g=rand(2,1)-[0.5;0.5];
    
    dist=[];
    dist=sum((M-repmat(g,1,size(M,2))).^2,1)';
    [dist2,index]=sort(dist);
    
    
    alfa=alfai*((alfaf/alfai)^(i/tmax));
    lambda=lambdai*((lambdaf/lambdai)^(i/tmax));
    
    for j=1:n
%        distC=dist_eu.*Gk;
%        meandist=mean(distC(:,index(1)));
%        v=exp(-(0.5*(D(index(1),j)^2/(lambda*meandist)^2)));
       v=exp(-0.5*(D(index(1),j)/lambda)^2);
       M(:,j)=alfa*v*(g-M(:,j));
    end
    
    
    
end