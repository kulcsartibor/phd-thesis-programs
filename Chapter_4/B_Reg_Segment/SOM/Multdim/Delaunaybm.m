%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delaunay model based control
%for Box Jenkins Data !!!!!!!!!!!!!!!!!!!!
%%J. ABonyi, TUDelft, Control Lab. Nov. 1999
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%using multidimensional triangulation

clear all

global modelpar tri node par

rand('seed',0)

data=[];
load boxjen.dat
nd=4;
data(:,1)=boxjen(nd:296-1,3); %y(k)
data(:,2)=boxjen(nd-2:296-nd+1,2); %u(k-3)
data(:,3)=boxjen(nd-3:296-nd,2);  %u(k-4)
data(:,4)=boxjen(nd+1:296,3); %y(k+1)

dnorm=1; %Data normalization flag
tic

if dnorm
   data(:,[1 4])=(data(:,[1 4])-53.05)./7.46;
	data(:,2:3)=(data(:,2:3)-0.059)./2.78;
end


%      nf1=4;
%      nf2=4;
%      nf3=4;

%      a1=[-1 -0.2 0.2 +1];
%      a2=[-1 -0.2 0.2 +1];
%      a3=[-1 -0.2 0.2 +1];

      nf1=3;
      nf2=3;
      nf3=3;

      a1=[-1 0 +1];
      a2=[-1 0 +1];
      a3=[-1 0 +1];


      node=[];
      for i=1:nf1
         for j=1:nf2
   	      for k=1:nf3
               node=[node; a1(i) a2(j) a3(k)];
            end  
         end
      end
      

  
ndata=size(data,1);
nnode=size(node,1);

node=node+rand(size(node))*0.001-0.0005

for j=1:1

%delaunay partitioning the input space 
tri = DELAUNAY(node); 
ntri=size(tri,1); %number of the triangules

%Assign the truangules
T=zeros(ndata,1);
for i=1:ntri
   RV=node(tri(i,:),:);  				%nodes of the triagule
	NF = spx2fac([1 2 3 4]);
   IS=INPOLYHD(data(:,1:3),RV,NF);
   T(find(IS>0))=i;
end
TT=sort(T)
TT=TT(find(TT(1:end-1)~=TT(2:end)>0)); %in these triangules we have data
Ttri=tri(TT,:); 
NT=sort(Ttri(:)); %Around these nodes we have data
NT=NT(find(NT(1:end-1)~=NT(2:end)>0)); 
node=node(NT,:);
nnode=size(node,1);

end


dnnode=25; %the number of the desired node

nnodei=size(node,1);
newnode=[];
AIC=[];
GCV=[];


for nadd=1:dnnode-nnodei+1;
   
   
nadd
   node=[node; newnode];
   nnode=size(node,1);
     
   
%_______________________________________
%delaunay partitioning the input space 
tri = DELAUNAY(node); 
ntri=size(tri,1); %number of the triangules
%Assign the truangules
T=zeros(ndata,1);
for i=1:ntri
   RV=node(tri(i,:),:);  				%nodes of the triagule
	NF = spx2fac([1 2 3 4]);
   IS=INPOLYHD(data(:,1:3),RV,NF);
   T(find(IS>0))=i;
end



%_______________________________________
%Local weigh of the models
modelpar=[];
for i=1:ntri;
   P=node(tri(i,:),:);  				%nodes of the triagule
   P=[P ones(4,1)];
   modelpar=[modelpar; [[i i i i]' [1 2 3 4]' (inv(P)*eye(4))']];
end

%__________________________________________
%Let's make the identification!

%Calculation of the rule weights
%T=tsearch(node(:,1),node(:,2),tri,data(:,1),data(:,2)); %these are the active traingulars


w=zeros(ndata,nnode);

for i=1:ndata
   anode=tri(T(i),:); 					%vector of the actual nodes
   modindex=find(modelpar(:,1)==T(i));%the index of the active models
   w(i,anode)=(modelpar(modindex,3:end)*[data(i,1:3) 1]')';
end   



%Least squares identification
par=w\data(:,4); 							%The parameters of the nodes

%
err=(data(:,4)-w*par).^2; 				%The a posteriori modelling error
errT=zeros(ntri,1);
nT=zeros(ntri,1);
for i=1:ndata
   errT(T(i))=err(i)+errT(T(i));  %ISE in a triangle
   nT(T(i))=1+nT(T(i));				 %number of samples in a triangle
end
     
errTn=zeros(ntri,1);
index=find(nT>0);                  %This is the trashhold on numbers of parameters (10)
errTn(index)=errT(index);%./nT(index);%This is the MSE 							%%%%%
Te=find(errTn==max(errTn)); 				%The index of the triangle with the biggest MSE


 RV=node(tri(Te,:),:);  				%nodes of the triagule
 ndim=size(RV,1);
 RV(ndim+1,:)= RV(1,:);
 maxi=0;
 maxd=0;
 for j=1:ndim
    dist=norm(RV(j+1,:)-RV(j,:))
    if dist>maxd
       maxi=j;
       maxd=dist;
    end
end   

newnode=mean(RV(maxi:maxi+1,:))+rand(1,ndim-1)*0.001-0.0005;

%inder=find(T==Te); 						%The index of the data where the error is big
%newnode=[sum(data(inder,1).*err(inder))/errT(Te)  sum(data(inder,2).*err(inder))/errT(Te) sum(data(inder,3).*err(inder))/errT(Te)];

if dnorm
   errdn=((data(:,4).*7.46+53.05)-((w*par).*7.46+53.05)).^2; %Denormalizalt error
  else
    errdn=sum(err);
end     
	nnode=size(node,1);
   MSE(nadd)=sum(errdn)/ndata
   
   %  AIC(nadd)=ndata*log10(MSE(nadd))+2*nnode; %+ndata*log10((ndata)/(ndata-nnode))
      AIC(nadd)=ndata*log(MSE(nadd))+log(ndata)*nnode; %+ndata*log10((ndata)/(ndata-nnode))

   
%   AIC(nadd)=log((1+2*nnode/ndata)*MSE(nadd))
   
H=w;
A=H'*H;
P=1-H*pinv(A)*H';
tP=trace(P);
gamma=ndata-tP;

GCV(nadd)=(ndata+gamma)/(ndata-gamma)*data(:,4)'*P*P*data(:,4)/ndata
end %end of the model building 

close all

if dnorm
%Renormalization for the figures!

node(:,2:3)=node(:,2:3)*2.78+0.059;
node(:,1)=node(:,1)*7.46+53.05;

data(:,2:3)=data(:,2:3)*2.78+0.059;
data(:,[1 4])=data(:,[1 4])*7.46+53.05;

par=par*7.46+53.05;

end

toc

figure(1) %plot the triangules
hold on
for i=1:ntri
   plot([node(tri(i,1),1) node(tri(i,2),1)], [node(tri(i,1),2) node(tri(i,2),2)])
   plot([node(tri(i,1),1) node(tri(i,3),1)], [node(tri(i,1),2) node(tri(i,3),2)])
   plot([node(tri(i,2),1) node(tri(i,3),1)], [node(tri(i,2),2) node(tri(i,3),2)])
end
plot(data(:,1),data(:,2),'rd');
hold off



figure(2) %plot the triangules

TRISURF(tri,node(:,1),node(:,2),par',par');
hold on
plot3(data(:,1),data(:,2),data(:,3),'k.')   
colormap([1 1 1]);
xlabel('u(k-3)');
ylabel('y(k)');
zlabel('y(k+1)');


hold off

figure(3) %plot the one-step ahead prediction
hold on
plot(w*par);
plot(data(:,4),'r');


figure(4) %plot the MSE
plot(nnodei:nnode, MSE,'k');
xlabel('number of rules')
ylabel('MSE')


figure(5) %plot the MSE
plot(nnodei:nnode, AIC,'k');
xlabel('number of rules')
ylabel('BIC')



   

