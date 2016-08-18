%% VAriancia analízis, szar elemek kidobása

%%
addpath('./PCAsegbu');
%%
clear all; close all; clc;
load('Ordered.mat');

%%
X(:,3700:end) = [];
WaveN(3700:end) = [];
X = X-repmat(mean(X(:,1:1500),2),1,size(X,2));

%%
V = var(X,1,2);
Out = union(find(V < 0.11),  find(V > 0.13));

X(Out, :) = [];
DTime(Out) = [];
V(Out) = [];

% Out = union(find(WaveN > 9000), find(WaveN < 5000));  %%find(std(X) < 1e-3)
% WaveN(Out) = [];
% X(:,Out) = [];

%%
X = X(:,1:5:end);
WaveN = WaveN(1:5:end);

%%
Sx = std(X);
Out = find(Sx < 45e-4);
WaveN(Out) = [];
X(:,Out) = [];

%%
X = (X(:,1:2:end-1) + X(:,2:2:end))./2;
WaveN = WaveN(1:2:end-1);

%%
Wn = 1:size(WaveN,2);
%%
surf(1:size(X,2),1:size(X,2),corrcoef(X),'EdgeColor','none')
% surf(1:size(X,2),1:size(X,2),cov(X),'EdgeColor','none')
view(2)
%%
j = figure('Name','Variancia szûrõ','NumberTitle','off');
subplot(3,1,1)
plot(Wn,X)
% plot(WaveN,X)
subplot(3,1,2)
plot(DTime,std(X,1,2))

subplot(3,1,3)
plot(Wn,std(X))

%%
num_segments = 30;
[segment,tc] = pcaseg(X,num_segments,50,1);

%%
figure(2)
Sx = std(X,1,2);
plot(DTime,Sx)

Ll = min(Sx);
Ul = max(Sx);
for i=1:length(segment)
	line([DTime(segment(i).lx) DTime(segment(i).lx)], [Ll Ul], 'Color', [1 0 0]);
end

for i=1:length(segment)
	line([DTime(segment(i).lx) DTime(segment(i).lx)], [Ll Ul], 'Color', [1 0 0]);
end
%%
figure(2)
for i=1:length(segment)
	surf(1:size(X,2),1:size(X,2),corrcoef(X(segment(i).lx:segment(i).rx,:)),'EdgeColor','none')
	view(2)
	pause
end

%%
index=[];

seg{1}=segment;
q=4;
for k=1:size(seg{1},2);
	for l=1:size(seg{1},2);
		L=seg{1}(k).pc(:,1:q);
		M=seg{1}(l).pc(:,1:q);
		Spca=trace(L'*M*M'*L)/q;
%                M'*M

		index=[index; [k l Spca]]; 
	end
end   

%%
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
% TVkdataplot
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





















