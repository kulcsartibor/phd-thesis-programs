%partial defuzzification
clear all
%close all

load valtozok

x2=0%(0-0.059)./2.78;
x3=0%(0-0.059)./2.78;
x1=-1.1:0.005:1.1;

if dnorm
   node(:,[1])=(node(:,[1])-53.05)./7.46;
	node(:,2:3)=(node(:,2:3)-0.059)./2.78;
end



data=[x1' ones(size(x1,2),1)*x2 ones(size(x1,2),1)*x3];
ndata=size(data,1);

%Assign the truangules
T=zeros(ndata,1);
for i=1:ntri
   RV=node(tri(i,:),:);  				%nodes of the triagule
	NF = spx2fac([1 2 3 4]);
   IS=INPOLYHD(data(:,1:3),RV,NF);
   T(find(IS>0))=i;
end
TT=sort(T);
TT=TT(find(TT(1:end-1)~=TT(2:end)>0)); %in these triangules we have data

w=[];
for i=1:ndata
  if T(i)>0 
   anode=tri(T(i),:); 					%vector of the actual nodes
   modindex=find(modelpar(:,1)==T(i));%the index of the active models
   w(i,anode)=(modelpar(modindex,3:end)*[data(i,1:3) 1]')';
  else 
   w(i,:)=0;
  end
end   


if dnorm
%Renormalization for the figures!

node(:,2:3)=node(:,2:3)*2.78+0.059;
node(:,1)=node(:,1)*7.46+53.05;

data(:,2:3)=data(:,2:3)*2.78+0.059;
data(:,[1])=data(:,[1])*7.46+53.05;

par=par*7.46+53.05;

end


plot(data(:,1),w,'k')
xlabel('y(k)')
ylabel('A_i(y(k))')

