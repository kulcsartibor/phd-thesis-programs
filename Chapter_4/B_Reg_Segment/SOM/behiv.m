

clear all 

%load elso;         %3*3
%load masodik       %4*4
%load harmadik;     %5*5
%load negyedik;      %10*10
%load otodik;       %15*15

sMap=som_read_cod('negyedik.cod')

pHdata = som_read_data('pHdata1.txt');
 
pHdata = som_normalize(pHdata,'var');
pHdata1= pHdata.data;
mindat=min(pHdata1);
mindat=mindat(1:end-1);
maxdat=max(pHdata1);
maxdat=maxdat(1:end-1);

nodenotnorm=sMap.codebook(:,1:end);

%nodenotnorm=[nodenotnorm; mindat; mindat(1) maxdat(2); maxdat(1) mindat(2); maxdat];



%delaunay partitioning the input space 
tri = DELAUNAY(nodenotnorm(:,1),nodenotnorm(:,2)); 
ntri=size(tri,1); %number of the triangules

codekell = som_denormalize(nodenotnorm,sMap.comp_norm);   %codebookot denormalizaljuk

%denormalizalt adatokat atrendezzuk
node=codekell(:,1:end-1);
par=codekell(:,end);


figure(1) %plot the surface
TRISURF(tri,node(:,1),node(:,2),par,par);
hold on
data = pHdata.data;
data = som_denormalize(data,pHdata)

plot3(data(:,1),data(:,2),data(:,3),'k.')   
colormap([1 1 1]);
xlabel('F_{NaOH}(k)');
ylabel('pH(k)');
zlabel('pH(k+1)');
hold off

%temp=node(:,1);
%node(:,1)=node(:,2);
%node(:,2)=temp;

%Local weight of the models
modelpar=[];
for i=1:ntri;
   P=node(tri(i,:),:);  				%nodes of the triagule
   P=[P ones(3,1)];
   modelpar=[modelpar; [[i i i]' [1 2 3]' (inv(P)*eye(3))']];
end


pargen

sim('freerun');
plotfree