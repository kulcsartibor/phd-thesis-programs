%% Load the data 
clear('all'); close('all'); clc;
addpath('.\somtoolbox', '.\kmedoids','.\OLS')
load('.\Data\EMS_Filtered_Data.mat')


%% Analysis of the EM variables
YVars = Raw.EMSTags(4,:);
Y = Raw.EMSData;
Time = Raw.Time(:,3);

XVars = Raw.ProcTags(4,:);
X = Raw.ProcData;
Time = Raw.Time(:,3);

NNIndex = find(Raw.StateVal(:,1)~=8); %normal operating mode
X(NNIndex,:)=[];
Y(NNIndex,:)=[];
Time(NNIndex,:)=[];


%% Cleaning

%for iter=1:2


NNIndex = find(sum(~isfinite(X), 2) == 0);
X = X(NNIndex,:);
Y = Y(NNIndex,:);
Time=Time(NNIndex,:);

NNIndex = find(sum(~isfinite(Y), 2) == 0);
Y = Y(NNIndex,:);
X = X(NNIndex,:);
Time=Time(NNIndex,:);


% NNIndex = [  find(max(X) == min(X))];
% X(:,NNIndex) = []; %not informative features 
% XVars(1,NNIndex)= [];
% NNIndex = [  find(max(Y) == min(Y))];
% Y(:,NNIndex) = []; %not informative features 
% YVars(1,NNIndex)= [];

NNIndex = find(std(X) == 0);
X(:,NNIndex) = []; %not informative features 
XVars(NNIndex)= [];
NNIndex = find(std(Y) == 0);
Y(:,NNIndex) = []; %not informative features 
YVars(NNIndex)= [];



N=length(Time);

%% Normalization
xs=std(X);
xm=mean(X);
Xn=(X-repmat(xm,N,1))./repmat(xs,N,1);

ys=std(Y);
ym=mean(Y);
Yn=(Y-repmat(ym,N,1))./repmat(ys,N,1);

%% SVD 
for i=1:5

[N n]=size(Xn);
F=cov( Xn );
[U, Sigma, V] = svd(F); %there are almost the same!!!
figure(1)
%s=cumsum(diag(Sigma)/sum(sum(Sigma)));
s=diag(Sigma);
figure(1)
plot(s)


%% Viz - PCA
% PCA komponens tér (pontszámok) generálása
PC = Xn * U;
figure(2)
plot(PC(:,1),PC(:,2),'.')
T2=(PC(:,1).^2+PC(:,2).^2)
figure(21)
plot(T2)
NNIndex=find(T2>500); 
Y(NNIndex,:)=[];
X(NNIndex,:)=[];
Time(NNIndex)=[];
%% Normalization of the final data 
N=length(Time);
xs=std(X);
xm=mean(X);
Xn=(X-repmat(xm,N,1))./repmat(xs,N,1);
ys=std(Y);
ym=mean(Y);
Yn=(Y-repmat(ym,N,1))./repmat(ys,N,1);
end

%end



%% Rotate 
nc=4
[PC1,T] = rotatefactors(PC(:,1:nc), 'Method','orthomax');
figure(3)
plot(PC1(:,1),PC1(:,2),'.')

PC=PC1;



%% OLS of the PCA 

I=[];
for i=1:nc
    I = [I, olsort(Xn,PC(:,i),10)];
end
[SUCCESS,MESSAGE]=xlswrite('lista.xlsx',XVars(I))



%% OLS of the electrical power consupltion 
i=36;
n=14;
YVar=YVars(i);
y=Yn(:,i);
Iy=olsort(Xn,y,n);
[SUCCESS,MESSAGE]=xlswrite('listay.xlsx',XVars(Iy)')
theta = [Xn(:,Iy) ones(N,1) ]\y;	
Yhat = [Xn(:,Iy) ones(N,1) ]*theta;
rsquare(y,Yhat)
plot(y,Yhat,'.')


%% SOM
comps = [YVar XVars(Iy)];
sD = som_data_struct([y Xn(:,Iy)],'comp_names', comps);
sM=som_make(sD,'msize',[30 30],'algorithm', 'seq','tracking',0);
A = som_calc_similarity(sM, 'simil', 'abs(corr)');
som_show(sM)

h = som_bmus(sM,[nan*y Xn(:,Iy)]);
ysom=sM.codebook(h,1);
figure(50)
figure('Color',[1 1 1])
plot(y,ysom,'.')
rsquare(y,ysom)

%%
figure(70)
subplot(4,1,1)
plot(Time,y','.')
for i=2:4
   subplot(4,1,i)
   plot(Time,Xn(:,Iy(i)),'.')
   ylabel(XVars(Iy(i)))
end   
    
