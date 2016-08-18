clear all
close all
segm=[];
nts=3;

num_segments=3;
q=4;
flag=1;
for i=1:nts;
    nev=['data' num2str(i)];
    eval(['load ' nev])
    x=data(:,2:end);
    [segment,tc] = pcaseg(x,num_segments,q,flag);
    seg{i}=segment;
end


index=[];
for i=1:nts; %nts: number of multivariate time series 
   for k=1:size(seg{i},2);
      for j=1:nts; %we compare also with itself
            for l=1:size(seg{j},2);
                L=seg{i}(k).pc(:,1:q);
                M=seg{j}(l).pc(:,1:q);
                Spca=trace(L'*M*M'*L)/q;
%                M'*M
                
                index=[index; [i k j l Spca]]; 
            end
        end
    end
end   

hold 
D=(1-reshape(index(:,end),sqrt(length(index)),sqrt(length(index))));
slink
set(0,'DefaultAxesFontName','times');
set(0,'DefaultTextFontName','times');
set(0,'DefaultAxesFontSize',4);
set(0,'DefaultTextFontSize',4);
%set(0,'DefaultMarkerSize',4);

dendogram(res)
%Z = linkage(D);
%[H, T] = dendrogram(Z)



i=1;
nev=['data' num2str(i)];
eval(['load ' nev])
TVkdataplot
hold on
b=axis;
b=b(3:4);
for j=1:size(seg{i},2)
   line([seg{i}(j).lx/240  seg{i}(j).lx/240], b);
end

lx=[seg{i}.lx];
rx=[seg{i}.rx];
c=zeros(length(data),num_segments);
for j=1:num_segments;
    c(lx(j):rx(j),j)=1;
end    



%[f,v,tm,ts,Pi,ft,np,dt,dr] = PCAClustmodc(data,c,ones(num_segments,1)*q,0);

if 1 
x=data(:,1)/max(data(:,1));
%Regressors
%reg=data(:,1:end-no); %ez lesz az x
fi=data(:,2:end); %ez lesz az x
nclusters=num_segments;
input_type=0;
q=11;

[mu,mufi,varx,covarx,covarfi,pp,pc]=cwmpca(x,fi,nclusters,input_type,q);

end


hold on
b=axis;
b=b(3:4);
for j=1:size(seg{i},2)
   line([seg{i}(j).lx/240  seg{i}(j).lx/240], b);
end   

