%% Munkaterület elõkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\Breeding','.\Functions','.\ExprEval')
load('EUBioDB.mat');
load('TpAgr');

%%
rng(1)
X = Xs;
Y = Ys(:,[1:6 18:21 30:32 40]);
varnames = variables([1:6 18:21 30:32 40]);
clear('Xs','Ys')

%% Paraméterek betöltése
WaveN = 4000:4:4776;
DistM = L2_distance(X',X');					%  
param.Dmax = max(max(DistM));				% MAximális távolság a spektrális térben (Euklédeszi)
param.RSphere = 25;							% A keresési tér mérete - a Dmax valahány %-ában megadva
param.Nnb = 5;								% A bevont szomszédok maximális száma

%%
D = squareform(pdist(X));

%%
AgrPoints = [eval(Agr.('Naro')), eval(Agr.('Parox'))];
Varpoints = Y(:, [find(ismember(varnames,'CFPP')) find(ismember(varnames,'Density'))]);
Varpoints(union(find(Varpoints(:,1) == -9999), find(Varpoints(:,2) == -9999)),:) = [];
figure('Color',[1 1 1])
subplot(1,2,1)
plot(AgrPoints(:,1),AgrPoints(:,2),'b.')
xlabel('Naro')
ylabel('Parox')
title('Visualization by Aggregates','FontWeight','bold')
axis('square')


subplot(1,2,2)
plot(Varpoints(:,1),Varpoints(:,2),'b.')
xlabel('CFPP')
ylabel('Density')
title('Density vs. CFPP','FontWeight','bold')
axis('square')

%%
% MdsMap = cmdscale(D);
MdsMap = mdscale(D,2,'Criterion','strain','Start','cmdscale');

%%
figure(1)
subplot(1,2,1)
plot(WaveN,X)
set(gca,'XDir','reverse')
axis('square');
axis([min(WaveN) 4800 min(X(:)) max(X(:))]);
xlabel('Wave Number [cm$^{-1}$]','Interpreter','latex')
ylabel('Absorbance (normalized) [-]')
title('A','FontSize', 14)

subplot(1,2,2)
plot(MdsMap(:,1),MdsMap(:,2),'.')

xlabel('Dimension 1 (MDS) [-]')
ylabel('Dimension 2 (MDS) [-]')
axis('square')
title('B','FontSize', 14)
