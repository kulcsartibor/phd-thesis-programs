close all
clf reset;
figure(gcf)
echo off


beta=1;

%    STEP 1: CONSTRUCT DATA
%    ======================
sDiris = som_read_data('pHdata.txt');
data1= sDiris.data;
mindat=min(data1);
mindat=mindat(1:end-1);
maxdat=max(data1);
maxdat=maxdat(1:end-1);
  
%    STEP 2: DATA NORMALIZATION
%    ==========================

data =sDiris.data; 
sDiris = som_normalize(sDiris,'var');
sDiris.data(:,end)=sDiris.data(:,end)/beta;


%    STEP 3: SOM Identification
%    ==========================

%sMap = som_make(sDiris,'msize',[5 5],'training','long');
sMap = som_lininit(sDiris,'msize',[4 4],'rec');
[sMap,sT] = som_batchtrain(sMap,sDiris,'radius_ini',3,'radius_fin',0.1,'trainlen',50);
[sMap,sT] = som_batchtrain(sMap,sDiris,'radius_ini',2,'radius_fin',0.1,'trainlen',150);
som_show(sMap,'norm','d')
h=zeros(sMap.topol.msize); h(1,2) = 1;
som_show_add('hit',h(:),'markercolor','r','markersize',0.5,'subplot','all')

sMap.codebook(:,end)=sMap.codebook(:,end)*beta;
codebook = som_denormalize(sMap.codebook,sMap.comp_norm);   %codebookot denormalizaljuk

node=codebook(:,1:end-1);
par=codebook(:,end);

nc=16; %
[center, U, obj_fcn] = fcv1(data(:,1:3), nc);
node=[center(:,1) center(:,2)];
par=center(:,3);



%nodenotnorm=[nodenotnorm; mindat; mindat(1) maxdat(2); maxdat(1) mindat(2); maxdat];

      nf1=2;
      nf2=2;
      a1=min(data(:,1)):(max(data(:,1))-min(data(:,1)))/(nf1-1):max(data(:,1));
      a2=min(data(:,2)):(max(data(:,2))-min(data(:,2)))/(nf2-1):max(data(:,2));

      for i=1:nf1
         for j=1:nf2
            node=[node; a1(i) a2(j)];
         end
      end
      


%delaunay partitioning the input space 
tri = DELAUNAY(node(:,1),node(:,2)); 
ntri=size(tri,1); %number of the triangules

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
ndata=length(data);
nnode=length(node);
w=zeros(ndata,nnode);

for i=1:ndata
   anode=tri(T(i),:); 					%vector of the actual nodes
   modindex=find(modelpar(:,1)==T(i));%the index of the active models
   w(i,anode)=(modelpar(modindex,3:end)*[data(i,1:2) 1]')';
end   

par1=w\data(:,3); 							%The parameters of the nodes
par1=par1';

par=[par;par1(end-3:end)'];
%par=par1';


figure(2) %plot the surface
TRISURF(tri,node(:,1),node(:,2),par,par);
hold on


plot3(data(:,1),data(:,2),data(:,3),'k.')   
colormap([1 1 1]);
xlabel('F(k-3)');
ylabel('CO(k)');
zlabel('CO(k+1)');
hold off

%temp=node(:,1);
%node(:,1)=node(:,2);
%node(:,2)=temp;

figure(3)
pargen

sim('freerun');
plotfree
%sim('imc');
%plotres


%figure(3) %plot the surface
%pargen

%sim('freerun');
%plotfree
err=mean((data(:,3)-w*par).^2)