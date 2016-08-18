%% Topnir reptrodukió tesztelése
% 2012.08.29
% Kulcsár Tibor

%% Munkaterület elõkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\TopNIR','.\Breeding','.\Functions','.\ExprEval')
load('EUBioDB.mat');
load('TpAgr');

%%
X = Xs;
Y = Ys(:,[1:6 18:21 30:32 40]);
Prop = variables([1:6 18:21 30:32 40]);
clear('Xs','Ys','variables')

%%

GParox = '7.1328*((((X(:,177))+(X(:,57)))./(X(:,75))).*((X(:,158))./((X(:,87))+(X(:,107)))))';
GNaro = '0.57813*((((X(:,70)).*(X(:,145)))./((X(:,19))+(X(:,177))))./(((X(:,59)).*(X(:,107))).*((X(:,111))./(X(:,159)))))';


figure('Color',[1 1 1])
plot(eval(Agr.Naro),eval(GNaro),'k.')
xlabel('Naro')
ylabel('Genetic Naro')

figure('Color',[1 1 1])
plot(eval(Agr.Parox),eval(GParox),'k.')
xlabel('Parox')
ylabel('Genetic Parox')