close all
clear all

clf reset;
figure(gcf)
echo off
global sMap par node T tri modelpar

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

%sMap = som_make(sDiris);
sMap = som_lininit(sDiris,'msize',[6 6],'rec');
[sMap,sT] = som_batchtrain(sMap,sDiris,'radius_ini',5,'radius_fin',0.5,'trainlen',750);
%[sMap,sT] = som_batchtrain(sMap,sDiris,'radius_ini',2,'radius_fin',1,'trainlen',150);
%nc=36; %
%[center, U, obj_fcn] = fcv1(sDiris.data, nc);
%sMap.codebook=center;

som_show(sMap,'norm','d')
load vF 
load vpHs
dum1=som_normalize([vpHs' vF' vpHs'],sMap.comp_norm);   %
h1 = som_hits(sMap,dum1);
som_show_add('hit',[h1],'MarkerColor','k','markersize',0.5,'Subplot','all')

[V,I]=som_divide(sMap, sDiris.data);
par=[];
par1=[];
for i=1:size(V,1);
  par{i}=[V{i}(:,1:2) repmat(1,length(V{i}(:,1:2)),1)]\ V{i}(:,3);
  dummy=( V{i}(:,1:2)-repmat(sMap.codebook(i,1:end-1),length(V{i}(:,1:2)),1))\ (V{i}(:,3)-repmat(sMap.codebook(i,end),length(V{i}(:,1:2)),1));
  par1{i}=[dummy; sMap.codebook(i,end)-dummy'*sMap.codebook(i,1:end-1)']; 
end  
ym=[];
ym1=[];
for i=1:length(sDiris.data);
  ym(i)=par{som_bmus(sMap, [sDiris.data(i,1:end-1) NaN])}'*[sDiris.data(i,1:end-1) 1]';
  ym1(i)=par1{som_bmus(sMap, [sDiris.data(i,1:end-1) NaN])}'*[sDiris.data(i,1:end-1) 1]';
end  
ym=som_denormalize([ym' ym' ym'],sMap.comp_norm);   %
ym1=som_denormalize([ym1' ym1' ym1'],sMap.comp_norm);   %
ym=ym(:,end);
ym1=ym1(:,end);


disp('Performance of the SOM BMU')
mean((ym-data(:,3)).^2)
mean((ym1-data(:,3)).^2)
sim('freerunsom');
Err=mean((simout(:,1)-simout(:,3)).^2)
par=par1;
sim('freerunsom');
Err=mean((simout(:,1)-simout(:,3)).^2)

plotfree
pause % Strike any key to continue...


sMap.codebook(:,end)=sMap.codebook(:,end)*beta;
codebook = som_denormalize(sMap.codebook,sMap.comp_norm);   %codebookot denormalizaljuk
node=codebook(:,1:end-1);
par=codebook(:,end);




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
nodek=zeros(size(node(tri(:,1),:)));
for i=1:size(tri,2)
 nodek=nodek+node(tri(:,i),:);
end
nodek=nodek/size(tri,2);
T=tsearch(node(:,1),node(:,2),tri,data(:,1),data(:,2)); %these are the active traingulars
[kint]=find(isnan(T)==1); %ezek a kulso pontok indexeinek vektora
for i=1:size(kint)           %kinti adatpontok futnak 
    distan=sum((abs(repmat(data(kint(i),1:2),length(nodek),1)-nodek))')';    
    T(kint(i))=find(distan==min(distan));  
end
 
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
disp('Performance of the SOM Delaunay')
err=mean((data(:,3)-w*par).^2)
sim('freerun');
plotfree
Err=mean((simout(:,1)-simout(:,3)).^2)

pause % Strike any key to continue...


disp('Performance of the SOM Delaunay +LS')
par=par1';
err=mean((data(:,3)-w*par).^2)
sim('freerun');
Err=mean((simout(:,1)-simout(:,3)).^2)
plotfree
pause % Strike any key to continue...


figure(1) %plot the surface
subplot(2,2,1)
TRImesh(tri,node(:,1),node(:,2),par,par);
hold on


plot3(data(:,1),data(:,2),data(:,3),'k.')   
%colormap([1 1 1]);
xlabel('F_{NaOH}(k)');
ylabel('pH(k)');
zlabel('pH(k+1)');
hold off

%temp=node(:,1);
%node(:,1)=node(:,2);
%node(:,2)=temp;

figure(3)
pargen

%sim('freerun');
%plotfree
%sim('imc');
%plotres


%figure(3) %plot the surface
%pargen

%sim('freerun');
%plotfree
