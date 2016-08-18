
%% Matlab szript a TOPNIR adatok elemzéséhez
% v2.0 2012.11.23
% Abonyi János, Kulcsár Tibor

%% Inicializáció
% Workspace törlése
clear('all'); close('all'); clc
addpath('.\toolbox_trnmap', 'pls')

%% Adatok betöltése
% Xs : Spektrum elnyelési adatsor
% Ys : Anyagjellemzõ adatsor
load('Fiber.mat');

%% Egyforma spektrumok kikeresése
X = Fiber.NormSp;
Y = Fiber.Y;
Yg = Fiber.Yg;

Pindex = 1:size(Fiber.Property,2);

%% 
Result = cell(2, 2);
Result(1,:) = {'Property' 'PLS'};
Fakt = 10;
i = 2;
for Index = Pindex	
	Result(i,1) = Fiber.Property(1,Index);
	if numel(Result{i,1}) == 0
		Result(i,1) = Fiber.Property(2,Index);
	end
	
	nnindex = find(~isnan(Y(:,Index)));
	if numel(nnindex) < 10
		continue
	end
	Yi = Y(nnindex,Index);
	Xi = X(nnindex,:);

	Pm = NcrossPLS(Xi,Yi,10,Fakt);
	c = corrcoef(Yi, Pm.EstY);
	Result{i,2} = c(1,2);
	i= i+1;
end

%%
table = PrintTable;
table.Format = 'tex';
table.addRow(Result{1,1},Result{1,2})	
for i=2:size(Result,1)
	table.addRow(sprintf('%s',Result{i,1}),sprintf('%1.3f',Result{i,2}))	
end
table.print
table.saveToFile('.\Table.tex');







