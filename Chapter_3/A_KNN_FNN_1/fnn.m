function fnnr = fnn(Xx,ye)
%Calculate the FNN 

nXx=(Xx-repmat(mean(Xx),size(Xx,1),1))./repmat(std(Xx),size(Xx,1),1); %normalize X
ny=(ye-mean(ye))./(std(ye));    %normalize y
reldist=zeros(size(nXx,1),1);
fnnv=[]; distv=[]; distyv=[]; reldist=[];
for i=1:size(nXx,1)
    [fnnv(i),distv(i)] =fnnf(nXx,i);
    distyv(i)=abs(ny(i)-ny(fnnv(i)));
    reldist(i)=(distyv(i)+eps)/(distv(i)+eps);
end
par=nXx\ny;
%K=norm(par);
%K=K*1e-4;
K=1e-1;
%figure(3)
%plot(sort(reldist))
%K=10;
fnnr=length(find(reldist>K*1))/length(ny);



function [fnni,disti] = fnnf(X,in)
%X adatmatrix
%in : szomszedja kerestetik
%fnni: O a szomdszed
%disti:a szomszedtol valo tavolsag
T=X-repmat(X(in,:),size(X(:,:),1),1);
dist=sqrt(sum(T.*T,2));
[dist,indx]=sort(dist);
fnni=indx(2);
disti=dist(2);

