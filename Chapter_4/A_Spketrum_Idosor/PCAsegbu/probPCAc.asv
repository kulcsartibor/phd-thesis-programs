function [res,P,Sm,np]=probPCAc(D,S,vj,q) %adat,kov.matrix,csop.kozeppont,hipersikdim.

%close all
[n p]=size(D);
mu=mean(D);
%D  = D-ones(n,1)*mu;
%S	= D'*D/n;

[U v V]	= svd(S,0);
dv	= diag(v);

err = cumsum(dv)/sum(dv)*100;
dumm = find(err >= q);
if isempty(dumm)
    q = length(dv);
else
    q = dumm(1);
end    

Wk	= U(:,q+1:end); %elhagyott sajatvektorok
np = q;

Sm = Wk*diag(ones(p-np,1)./dv(q+1:end))*Wk'; %EZ MAR AZ INVERZ

P	= sum(dv(q+1:end))/(p-q); % LESZ A SZORAS

%tavolsagmertek: az elhagyott sajatvektorok kov.matrixa
res = sum ( ( (D-ones(n,1)*vj) * (Wk*Wk') .* (D-ones(n,1)*vj)  )'  )';

