

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

%delaunay partitioning the input space 
tri = DELAUNAY(node(:,1),node(:,2)); 
ntri=size(tri,1); %number of the triangules


% Kinti pontokhoz legkozelebbi haromszog keresese
T=tsearch(node(:,1),node(:,2),tri,data(:,1),data(:,2)); %these are the active traingulars
[kint]=find(isnan(T)==1); %ezek a kulso pontok indexeinek vektora
H=[]; 
for i=1:size(kint)           %kinti adatpontok futnak 
   mkint=kint(i);
    x=data(mkint,1:2);          %kinti adatpont szamerteke
    temp=node;
    dist=sum((abs(repmat(x,length(node),1)-node))')';           %tavolsagok
    ind1=find(dist==min(dist));          %legkozelebbi
    dist(ind1)=max(dist);
    ind2=find(dist==min(dist));          %masodik legkozelebbi
    [i1,i2]=find(tri==ind1);         %melyik haromszogben van a legkozelebbi     
    [in1,in2]=find(tri(i1,:)==ind2);     %melyik haromszogben van a legkozelebbi ES a masodik 
    dist(ind2)=max(dist);
        for j=1:size(in1)
            [ez az]=find(min(dist(in1(j),:)));
        end         
        H=[H; x, tri(ez,:)];    %kinti adatpont+haromszog csucsainak indexe
    end


%Masik modszerrel, haromszog kozepevel
%A=tri(:,1);
%B=tri(:,2);
%C=tri(:,3);
%nodek=(node(A,:)+node(B,:)+node(C,:))/3;        %kozpontok koordinatai
%K=[];

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
 
 
    
    %H=[];
%T=tsearch(node(:,1),node(:,2),tri,data(:,1),data(:,2)); %these are the active traingulars
%[kint]=find(isnan(T)==1); %ezek a kulso pontok indexeinek vektora
 %  for i=1:size(kint)           %kinti adatpontok futnak
  %      mkint=kint(i)       %eppen vizsgalt kinti adatpont indexe
   %        for j=1:size(node,1)             %halocsucsok futtatasa
    %           [k]=find(min((data(mkint,1)-node(j,1))^2+(data(mkint,2)-node(j,2))^2);  %legkozelebbi node indexe
     %          [m n]=find(tri==k)  %a legkozelebbi csucs indexei  a haromszogeleseknel  
      %              for f=1:size(m)
       %                 for g=1:max(n)
        %                    tav=((data(mkint,1)-node(tri(m(f),1:(n(g)-1)),1))^2+(data(mkint,2)-node(tri(m(f),1:(n(g)-1)),2))^2),((data(mkint,1)-node(tri(m(f),(n(g)+1):max(n)),1))^2+(data(mkint,2)-node(tri(m(f),(n(g)+1):max(n)),2))^2)
         %                   [gez]=find(min(tav))
          %                 G=[G;tav(gez)] 
          %             end 
          %                    %tri(m(fez),:) a legkozelebbik haromszog
           %                    H=[H;kint(i) tri(m(fez),:)               
           %       end      
           %        end        
           % end
                    
