%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delaunay model based control
%for Box Jenkins Data !!!!!!!!!!!!!!!!!!!!
%%J. ABonyi, TUDelft, Control Lab. Nov. 1999
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

global modelpar tri node par

data=[];
load boxjen.dat
nd=3;
data(:,2)=boxjen(nd:296-1,3);
data(:,1)=boxjen(1:296-nd,2);
data(:,3)=boxjen(nd+1:296,3);

dnorm=0; %Data normalization flag

if dnorm
	data(:,1)=(data(:,1)-0.059)./2.78;
   data(:,2:3)=(data(:,2:3)-53.05)./7.46;
end



%initial partitioning

      nf1=3;
      nf2=3;
      a1=min(data(:,1)):(max(data(:,1))-min(data(:,1)))/(nf1-1):max(data(:,1));
      a2=min(data(:,2)):(max(data(:,2))-min(data(:,2)))/(nf2-1):max(data(:,2));
      
      node=[];
      for i=1:nf1
         for j=1:nf2
            node=[node; a1(i) a2(j)];
         end
      end
      
      
if dnorm      
     node=[-1 1;
	   	1 -1;
   		-1 0.2;
		   0 1;
		   1 -0.2;
		   0 -1];
  else
       	          
      node=[max(data(:,1)) 							min(data(:,2)); 
       		min(data(:,1)) 							max(data(:,2)); 
            (max(data(:,1))+min(data(:,1)))/2 	min(data(:,2)); 
            min(data(:,1)) 							(max(data(:,2))+min(data(:,2)))/2; 
            max(data(:,1)) 							(max(data(:,2))+min(data(:,2)))/2; 
            (max(data(:,1))+min(data(:,1)))/2  	max(data(:,2))];  
  end
 

ndata=size(data,1);
nnode=size(node,1);

dnnode=30; %the number of the desired node

nnodei=size(node,1);
newnode=[];
AIC=[];

%for nadd=1:dnnode-nnodei+1;
nadd=1;

   node=[node; newnode];
   nnode=size(node,1);
     
   
%_______________________________________
%delaunay partitioning the input space 
tri = DELAUNAY(node(:,1),node(:,2)); 
ntri=size(tri,1); %number of the triangules


%_______________________________________
%Local weigh of the models
modelpar=[];
for i=1:ntri;
   P=node(tri(i,:),:);  				%nodes of the triagule
   P=[P ones(3,1)];
   modelpar=[modelpar; [[i i i]' [1 2 3]' (inv(P)*eye(3))']];
end

%__________________________________________
%Let's make the identification!

%Calculation of the rule weights
T=tsearch(node(:,1),node(:,2),tri,data(:,1),data(:,2)); %these are the active traingulars

w=zeros(ndata,nnode);

for i=1:ndata
   anode=tri(T(i),:); 					%vector of the actual nodes
   modindex=find(modelpar(:,1)==T(i));%the index of the active models
   w(i,anode)=(modelpar(modindex,3:end)*[data(i,1:2) 1]')';
end   

%Least squares identification
par=w\data(:,3); 							%The parameters of the nodes

%QP!! (a priori knowledge!)

oH=2*w'*w;
oc=2*(-1*w'*data(:,3));

%Generating the constraint matrix
A=zeros(ntri*2,nnode);
b=zeros(ntri*2,1);

for i=1:ntri
   index=find(modelpar(:,1)==i);
   anodes=tri(i,:);
   A(2*(i-1)+1:2*(i-1)+2,anodes)=[-modelpar(index,3)'; modelpar(index,4)'];
   b1(2*(i-1)+1:2*(i-1)+2)=[-0.000000000001 0.0000000001]; %FOR BJ because it has negative gain !!!
  % b2(2*(i-1)+1:2*(i-1)+2)=[10^12 1];
end   

A=[-A];
b=[-b1];
%par=qp(oH,oc,[A],[b]);%,VLB,VUB
%
err=(data(:,3)-w*par).^2; 				%The a posteriori modelling error
errT=zeros(ntri,1);
nT=zeros(ntri,1);
for i=1:ndata
   errT(T(i))=err(i)+errT(T(i));  %ISE in a triangle
   nT(T(i))=1+nT(T(i));				 %number of samples in a triangle
end
     

errTn=zeros(ntri,1);
index=find(nT>0);                  %This is the trashhold on numbers of parameters (10)
errTn(index)=errT(index); %./nT(index);%This is the MSE 							
Te=find(errTn==max(errTn)); 				%The index of the triangle with the biggest MSE
inder=find(T==Te); 						%The index of the data where the error is big
newnode=[sum(data(inder,1).*err(inder))/errT(Te)  sum(data(inder,2).*err(inder))/errT(Te)];

if dnorm
   errdn=((data(:,3).*7.46+53.05)-((w*par).*7.46+53.05)).^2; %Denormalizalt error
  else
    errdn=sum(err);
end     
	nnode=size(node,1);
	MSE(nadd)=sum(errdn)/ndata;
	AIC(nadd)=log((1+2*nnode/ndata)*MSE(nadd));
%end %end of the model building 

close all

if dnorm
%Renormalization for the figures!
node(:,1)=node(:,1)*2.78+0.059;
node(:,2)=node(:,2)*7.46+53.05;

data(:,1)=data(:,1)*2.78+0.059;
data(:,2:3)=data(:,2:3)*7.46+53.05;

par=par*7.46+53.05;

end

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
plot(data(:,3),'r');


figure(4) %plot the MSE
plot(nnodei:nnode, MSE,'k');
xlabel('number of rules')
ylabel('MSE')


figure(5) %plot the MSE
plot(nnodei:nnode, AIC,'k');
xlabel('number of rules')
ylabel('AIC')



   

