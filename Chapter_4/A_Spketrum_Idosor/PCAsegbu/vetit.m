function [Sm,np]=vetit(D,q) %adat,kov.matrix,csop.kozeppont,hipersikdim.

%close all
[n p]=size(D);
mu=mean(D);
D  = D-ones(n,1)*mu;
S	= D'*D/(n-1);
[U v V]	= svd(S,0);
dv	= diag(v);

dumm=1:q;
%transformation
%W	= U(:,1:q) * diag(sqrt(l(1:q) - P));
W	= U(:,1:q); 
Wk	= U(:,q+1:end); %elhagyott sajatvektorok


% adatok adott csop.kozepponttol valo tavolsaga; tavolsagmertek: az elhagyott sajatvektorok kov.matrixa
res=sum ( ( (D-ones(n,1)*vj) * (Wk*Wk') .* (D-ones(n,1)*vj)  )'  )';

%pcadp = ones(n,1)*mu) * W;

%res=D-((W*inv(W'*W)*pcadp')'+ones(n,1)*mu);

%res=D-((W*pcadp')'+ones(n,1)*mu);

%T2p=sum((D*Ci.*D)')'; 
%Hotelling Q
%Qp=sum(((Dep-D).*(Dep-D))')';

np=q;
