%% Matlab szript a TOPNIR adatok elemz�s�hez
% v2.0 2012.11.23
% Abonyi J�nos, Kulcs�r Tibor

%% Inicializ�ci�
% Workspace t�rl�se
clear('all'); close('all'); clc
addpath('.\toolbox_trnmap', 'pls')

%% Adatok bet�lt�se
% Xs : Spektrum elnyel�si adatsor
% Ys : Anyagjellemz� adatsor
load('EU2005Bio.mat');

%% Egyforma spektrumok kikeres�se

[Unq, UnqFirst, RowId] = unique(Xs, 'rows', 'first');
% Az egyforma spektrumokb�l csak azt hagyjuk meg, amelyik el�bb t�nik fel.
X = Xs(UnqFirst,:);
Y = Ys(UnqFirst,:);
X(102,:) = [];
Y(102,:) = [];
Samples(102) = [];

%% 
% Pindex = [1 3:4 11 15 17 20];
Pindex = [17 16 1 2 3 4 5 7 9 11 12 13 18 15 20];
LPindex = length(Pindex);
Result = cell(numel(Pindex)+1, 2);
Result(1,:) = {'Property' 'PLS'};
Fakt = 10;
i = 2;
for Index = Pindex
	Result(i,1) = Property(Index);
	nnindex = find(~isnan(Y(:,Index)));
	Yi = Y(nnindex,Index);
	Xi = X(nnindex,:);
	
	Pm = NcrossPLS(Xi,Yi,20,Fakt);
% 	Result{i,2} = rsquare(Yi, Pm.EstY);
	c = corrcoef(Yi, Pm.EstY);
	Result{i,2} = c(1,2);
	
	i = i+1;
end
%%
% Result
table = PrintTable;
table.Format = 'tex';
table.addRow(Result{1,1},Result{1,2})	
for i=2:size(Result,1)
	table.addRow(sprintf('%s',Result{i,1}),sprintf('%1.3f',Result{i,2}))	
end
table.print
table.saveToFile('.\Table.tex');









