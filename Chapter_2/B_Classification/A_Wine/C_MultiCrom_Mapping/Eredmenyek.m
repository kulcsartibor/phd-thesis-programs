%% Topnir reptrodukió tesztelése
% 2012.08.29
% Kulcsár Tibor

%% Munkaterület előkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\Breeding','.\Functions','.\ExprEval')
% load('EUBioDB.mat');
%%
Xs = csvread('wine.csv');
Type = Xs(:,1);
Types = unique(Type);
TypeN = numel(Types);

for i = 1:TypeN
	TypeI{i} = find(Type == Types(i));
end
X = Xs(:,2:end);
Prop = {	'Alcohol','Malic acid','Ash','Alcalinity of ash','Magnesium',...
			'Total phenols','Flavanoids','Nonflavanoid phenols','Proanthocyanins',...
			'Color intensity','Hue','OD280/OD315 of diluted wines','Proline '};

%% Paraméterek betöltése
X = (X-repmat(min(X),size(X,1),1))./repmat(max(X)-min(X),size(X,1),1);
DistM = L2_distance(X',X');					%  

%%
% color = hsv(TypeN);
marker = '+*d';
color = hsv(3);



%%
D = squareform(pdist(X));
% MdsMap = cmdscale(D);
MdsMap = mdscale(D,2,'Criterion','stress','Start','cmdscale');

%%
c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
PCAPoints = Xp*p;

SmMap = sammon(X,2,1000,'steps',[],DistM);
%%
[Mt,Mc,V,U] = trustcont(10, X, MdsMap, DistM, squareform(pdist(MdsMap)));
Mt*Mc

[Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, squareform(pdist(SmMap))); %#ok<*NASGU,*ASGLU>
Mt*Mc

[Mt,Mc,V,U] = trustcont(10, X, PCAPoints, DistM, squareform(pdist(PCAPoints))); %#ok<*NASGU,*ASGLU>
Mt*Mc

%%

figure('Color',[1 1 1])
subplot(2,2,1)
hold on
box on
for i = 1:TypeN
	plot(MdsMap(TypeI{i},1),MdsMap(TypeI{i},2),marker(i),'Color',color(i,:))
end
xlabel('Dim 1 [-]')
ylabel('Dim 2 [-]')
title('A (MDS)')
axis square

subplot(2,2,2)
hold on
box on
for i = 1:TypeN
	plot(SmMap(TypeI{i},1),SmMap(TypeI{i},2),marker(i),'Color',color(i,:))
end
xlabel('Dim 1 [-]')
ylabel('Dim 2 [-]')
title('B (Sammon)')
axis square

subplot(2,2,[3 4])
hold on
box on
for i = 1:TypeN
	plot(PCAPoints(TypeI{i},1),PCAPoints(TypeI{i},2),marker(i),'Color',color(i,:))
end
xlabel('PC 1 [-]')
ylabel('PC 2 [-]')
title('C (PCA)')
axis square


%%

Ags1 = '0.5*(((1.5*((X(:,10)).*(X(:,12))))+((1*(X(:,7)))-(1.5*(X(:,10)))))+(2.5*(((X(:,13)).*(X(:,7))).*((X(:,3))+(X(:,1))))))';
Ags2 = '0.5*(((1*(X(:,8)))-(1*((X(:,9)).*(X(:,9)))))-(1.5*(((X(:,1))-(X(:,4))).*(X(:,9)))))';

figure('Color',[1 1 1])
hold on
box on
AgrMap = [eval(Ags1) eval(Ags2)];
[Mt,Mc,V,U] = trustcont(10, X, AgrMap, DistM, squareform(pdist(AgrMap))); %#ok<*NASGU,*ASGLU>
Mt*Mc
for i = 1:TypeN
	plot(AgrMap(TypeI{i},1),AgrMap(TypeI{i},2),marker(i),'Color',color(i,:))
end
% title('Genetic Algorithm Result', 'FontSize',16)
xlabel('Aggregate 1 [-]')
ylabel('Aggregate 2 [-]')
axis square


return
%%
% hist3(SmMap,[10 10])
% set(gcf,'renderer','opengl');
% set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');

%%
close all
clc
diary('log01.txt')
diary on

[Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, L2_distance(SmMap',SmMap')); %#ok<*NASGU,*ASGLU>
disp(['Sammon eredménye: M1 = ' num2str(Mt) '    M2 = ' num2str(Mc) '    F = ' num2str(Mt*Mc)])

[Mt,Mc,V,U] = trustcont(10, X, PCAPoints, DistM, L2_distance(PCAPoints',PCAPoints'));
disp(['PCA eredménye:    M1 = ' num2str(Mt) '    M2 = ' num2str(Mc) '    F = ' num2str(Mt*Mc)])

%%
symbols{1} = {'+','-','*','/'};
for i = 1:size(X,2)
  symbols{2}{i} = sprintf('X(:,%i)',i);
end
clear('i')

%%
popusize = 40;
maxtreedepth = 4;
popu = breeding_init(popusize,maxtreedepth,symbols);

%%

[popu] = breeding_evaluate(popu,1:popusize,X,DistM,[]);
disp(breeding_result(popu,1));
disp('=====================================================================================')

%%
h = figure(1);	
opt = [0.8 0.3 0.7 2 2 0.1 0.1 0.01 1 0];
for c = 1:1000
	
	[popu, evnum] = breeding_mainloop(popu,X,DistM,opt);	
	disp(breeding_result(popu,1));	
	
	save(['.\Popu\popu_' num2str(c) '.mat'], 'popu')
% 	disp(['Mapping: ' num2str(popu1.chrom{1}.fitness)]);
% 	figure(1);
% 	hold off
% 	fs = get_treeterm(popu);
% 	
% 	plot(eval(fs{1}),eval(fs{2}),'.')
% 	xlabel(fs{1})
% 	ylabel(fs{2})
% 	title(['Mapping quality: ' num2str(popu.unit{1}.fitness) , ' G: ', num2str(c)])
% 	drawnow
% 	figure(2);
% 	hold on
% 	plot(c,popu.unit{1}.fitness,'g*')
% 	axis([1 45 0 1])
% 	drawnow
% 	saveas(h,['.\images\gen_' num2str(pics) '_' num2str(c) '.png'])
% 	close(h)
end

diary off

