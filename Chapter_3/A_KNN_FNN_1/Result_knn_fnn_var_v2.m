%% Matlab szript a TOPNIR adatok elemzéséhez
% v2.0 2012.11.23
% Abonyi János, Kulcsár Tibor

%% Inicializáció
% Workspace törlése
clear('all'); close('all'); clc
addpath('.\toolbox_trnmap')

%% Adatok betöltése
% Xs : Spektrum elnyelési adatsor
% Ys : Anyagjellemzõ adatsor
load('EU2005Bio.mat');

%% Egyforma spektrumok kikeresése

% [Unq, UnqFirst, RowId] = unique(Xs, 'rows', 'first');
X=Xs;
Y=Ys;

% Az egyforma spektrumokból csak azt hagyjuk meg, amelyik elõbb tûnik fel.
% X = Xs(UnqFirst,:);
% Y = Ys(UnqFirst,:);
% X(102,:) = [];
% Y(102,:) = [];
% Samples(102) = [];

%% Elõzetes elemzés
% Nyers adatok ábrázolása
figure(1)
WaveNum = linspace(4776, 4000, 195);
plot(WaveNum,X');
axis([4000 4800 0 max(max(X))]);
set(gca,'XDir','reverse')
xlabel('cm^{-1}');
hold on

%% Analysis of properties
disp('Correllation of properties')
%CN0, CFPP0, CloutdPt, FlashPt, E250, E350, Polyaro, TotAro, Density, PolyCycl 
% Pindex = [1 3:4 11 15 17 20];
Pindex = [17 16 1 2 3 4 5 7 9 11 12 13 18 15 20];
LPindex = length(Pindex);
PropCorr=zeros(LPindex,LPindex);
for i = 1:LPindex-1
    for j = i+1:LPindex
        index= intersect(find(~isnan(Y(:,Pindex(i)))),find(~isnan(Y(:,Pindex(j)))));
        dum=corrcoef(Y(index,Pindex(i)),Y(index,Pindex(j)));
        PropCorr(i,j)=dum(1,2);
    end
end
clear dum; clear index;

%% Tavolsagmatrix
DistM=L2_distance(X',X');

% %% MDS tavolsagmatrix
% disp('MDS distance preserving mapping')
% % [positions, error, ev] = mds(DistM, 2);
% [mdspoint, error, ev] = mdscale(DistM,2,'start','random','criterion','strain');
% 
% % plot(positions(1,:),positions(2,:),'.')
% 
% mds_metr_err = stress_metr_mds(DistM,mdspoint);
% 
% % stress_mds(DD,positions(1:2,:)','y')
% % compute the trustworthiness of the mapping
% Distmds=L2_distance(mdspoint',mdspoint');
% [Mt,Mc,V,U] = trustcont(5, X, mdspoint, DistM, Distmds);
% [Mt Mc]
% 
% %% Finetuning by Sammon mapping
% disp('Sammon mapping')
% [shammonpoint]=sammon(X,[mdspoint(:,1) mdspoint(:,2)]);
% figure(3); 
% plot(shammonpoint(:,1),shammonpoint(:,2),'.')
% Distshammon=L2_distance(shammonpoint(:,1:2)',shammonpoint(:,1:2)');
% [Mt,Mc,V,U] = trustcont(5, X, shammonpoint(:,1:2), DistM, Distshammon);
% [Mt Mc]

%%
Result = cell(numel(Pindex)+1, 5);
Result(1,:) = {'Property' 'Spectra' 'MDS' 'Sammon' 'FNN%'};
i = 2;
for Index = Pindex
	Result(i,1) = Property(Index);
	nnindex = find(~isnan(Y(:,Index)));
	Yi = Y(nnindex,Index);
	Xi = X(nnindex,:);
	
	Yo = knn(DistM(nnindex,nnindex), Yi, 5);
% 	Result{i,2} = rsquare(Yi,Yo);
	c = corrcoef(Yi,Yo);
	Result{i,2} = c(1,2);
% 	
% 	Yo = knn(Distmds(nnindex,nnindex), Yi, 5);
% % 	Result{i,3} = rsquare(Yi,Yo);
% 	c = corrcoef(Yi,Yo);
% 	Result{i,3} = c(1,2);
% 	
% 	Yo = knn(Distshammon(nnindex,nnindex), Yi, 5);
% % 	Result{i,4} = rsquare(Yi,Yo);
% 	c = corrcoef(Yi,Yo);
% 	Result{i,4} = c(1,2);
	
	Result{i,5} = fnn(X(nnindex,:),Yi);
	
	i = i+1;
end
%%
table = PrintTable;
table.Format = 'tex';
table.addRow(Result{1,1},Result{1,2},Result{1,3},Result{1,4},Result{1,5})	
for i=2:size(Result,1)
	table.addRow(sprintf('%s',Result{i,1}),sprintf('%1.3f',Result{i,2}),...
		sprintf('%1.3f',Result{i,3}),sprintf('%1.3f',Result{i,4}),...
		sprintf('%1.3f',Result{i,5}))	
end
table.print
table.saveToFile('.\Table.tex');

% ....\Dropbox\Mol-NIR\Beszamolo
% Topnir1 alap









