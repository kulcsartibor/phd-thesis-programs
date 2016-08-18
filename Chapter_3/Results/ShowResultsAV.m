%% Elsevire Article Results
% dr. Janos Abonyi
% Tibor Kulcsar
% 2012.04.04

%% Workspace Initializatuion
clear all; close all; clc;
addpath('.\toolbox_trnmap');
addpath('.\PLS');
addpath('.\Functions');

%% Load datas from preused database
load('AV2DB.mat');
load('AV2TPRes.mat');

%% Helper Funtions
Dist= @(d)(repmat(d, 1, length(d)) - repmat(d', length(d'),1)); %oszlopvektorra

%% Filter of spectras
[Unq, UnqFirst, RowId] = unique(Xs, 'rows', 'first');
X = Xs(UnqFirst,:);	% Az egyforma spektrumokból csak azt hagyjuk meg, amelyik elõbb tûnik fel.
Y = Ys(UnqFirst,:);	% Az egyforma spektrumokból csak azt hagyjuk meg, amelyik elõbb tûnik fel.
X(27,:) = [];
Y(27,:) = [];
Xo = X;
Yo = Y;

%% Normalization of Spectras and properties
N = size(X,1);
X = (X-repmat(mean(X,1),N,1))./repmat(std(X,1),N,1);
Y = (Y-repmat(mean(Y,1),N,1))./repmat(std(Y,1),N,1);

%% Defining the propeties that should be estimated
Pindex = [4 12]; % {'D5 [°C]' 'Density [kg/dm3]'}
LPindex = length(Pindex);
clear dum;	clear Xs; clear Ys;		% Remoce the unsued variables

%% Distance in spectral field
DistM = zeros(N);
for i=1:N
	DistM(i,:)=sum(1/195*abs(X-repmat(X(i,:),N,1)),2);
end
NDistM = DistM./max(max(DistM));

%% PLS 2D (Density)
pmod =  pls2DComp(pls(X,Y(:,Pindex(2)),10));
PLSPoints1 = [pmod.tw1 pmod.tw2];
NormPLS1 = [((PLSPoints1(:,1) - min(PLSPoints1(:,1)))./(max(PLSPoints1(:,1)) - min(PLSPoints1(:,1))))...
	((PLSPoints1(:,2) - min(PLSPoints1(:,2)))./(max(PLSPoints1(:,2)) - min(PLSPoints1(:,2))))];

[Mt,Mc,V,U] = trustcont(5, X, PLSPoints1, DistM, L2_distance(PLSPoints1',PLSPoints1'));
Mt+Mc
figure('Color',[1 1 1])
subplot(1,2,1)
plot(NormPLS1(:,1), NormPLS1(:,2), '.');
axis square
title('A (D5 °C)')
xlabel('Dim 1')
ylabel('Dim 2')

%% PLS 2D (Density)
pmod =  pls2DComp(pls(X,Y(:,Pindex(1)),10));
PLSPoints2 = [pmod.tw1 pmod.tw2];
NormPLS2 = [((PLSPoints2(:,1) - min(PLSPoints2(:,1)))./(max(PLSPoints2(:,1)) - min(PLSPoints2(:,1))))...
	((PLSPoints2(:,2) - min(PLSPoints2(:,2)))./(max(PLSPoints2(:,2)) - min(PLSPoints2(:,2))))];

[Mt,Mc,V,U] = trustcont(5, X, PLSPoints2, DistM, L2_distance(PLSPoints2',PLSPoints2'));
Mt*Mc
subplot(1,2,2)
plot(NormPLS2(:,1), NormPLS2(:,2), '.');
axis square
title('B (Density)')
xlabel('Dim 1')
ylabel('Dim 2')

%% PCA Visualization
c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
PCAPoints = Xp*p;
NormPCA = [((PCAPoints(:,1) - min(PCAPoints(:,1)))./(max(PCAPoints(:,1)) - min(PCAPoints(:,1))))...
	((PCAPoints(:,2) - min(PCAPoints(:,2)))./(max(PCAPoints(:,2)) - min(PCAPoints(:,2))))];

[Mt,Mc,V,U] = trustcont(5, X, PCAPoints, DistM, L2_distance(PCAPoints',PCAPoints'));
Mt*Mc
figure('Color',[1 1 1])
plot(NormPCA(:, 1), NormPCA(:, 2), '.');
axis square


xlabel('Dim 1')
ylabel('Dim 2')




