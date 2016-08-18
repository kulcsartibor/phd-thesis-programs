function [Sm,np]=vetit(D,S,vj,q) %adat,kov.matrix,csop.kozeppont,hipersikdim.

%close all
[n p]=size(D);
mu=mean(D);
%D  = D-ones(n,1)*mu;
%S	= D'*D/n;

[U v V]	= svd(S,0);
dv	= diag(v);

err=cumsum(dv)/sum(dv)*100;
dumm=find(err >= q);
if isempty(dumm)
    dumm=1:length(dv);
else 
    dumm=1:dumm(1);
end    

Wk = U(:,dumm); 
np = length(dumm);

Sm = Wk*diag(ones(np,1)./dv(dumm))*Wk'; %EZ MAR AZ INVERZ


