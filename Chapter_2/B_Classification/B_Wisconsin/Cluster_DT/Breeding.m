%% Topnir reptrodukió tesztelése
% 2012.08.29
% Kulcsár Tibor

%% Munkaterület elõkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\Breeding','.\Functions','.\ExprEval')
% load('EUBioDB.mat');
%%
global TypeI TypeN Type
Xs = csvread('wdbc.csv');
Type = Xs(:,2);
Types = unique(Type);
TypeN = numel(Types);

for i = 1:TypeN
	TypeI{i} = find(Type == Types(i));
end
X = Xs(:,3:end);
Prop = {	'Alcohol','Malic acid','Ash','Alcalinity of ash','Magnesium',...
			'Total phenols','Flavanoids','Nonflavanoid phenols','Proanthocyanins',...
			'Color intensity','Hue','OD280/OD315 of diluted wines','Proline '};

%% Paraméterek betöltése
X = (X-repmat(min(X),size(X,1),1))./repmat(max(X)-min(X),size(X,1),1);
DistM = L2_distance(X',X');					%  

%%
color = hsv(TypeN);
if 0


%%
D = squareform(pdist(X));
% MdsMap = cmdscale(D);
MdsMap = mdscale(D,2,'Criterion','strain','Start','cmdscale');
figure('Color',[1 1 1])
hold on
for i = 1:TypeN
	plot(MdsMap(TypeI{i},1),MdsMap(TypeI{i},2),'.','Color',color(i,:))
end
[Mt,Mc,V,U] = trustcont(10, X, MdsMap, DistM, squareform(pdist(MdsMap))); %#ok<*NASGU,*ASGLU>
title([num2str(Mt), ' ', num2str(Mc), ' ', num2str(Mt*Mc)])

%%
c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
PCAPoints = Xp*p;

[Mt,Mc,V,U] = trustcont(10, X, PCAPoints, DistM, squareform(pdist(PCAPoints))); %#ok<*NASGU,*ASGLU>
% [Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, squareform(pdist(SmMap))); %#ok<*NASGU,*ASGLU>
figure('Color',[1 1 1])
hold on
for i = 1:TypeN
	plot(PCAPoints(TypeI{i},1),PCAPoints(TypeI{i},2),'.','Color',color(i,:))
end

title([num2str(Mt), ' ', num2str(Mc), ' ', num2str(Mt*Mc)])

%%
figure('Color',[1 1 1])
hold on
SmMap = sammon(X,2,1000,'steps',[],DistM);
[Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, squareform(pdist(SmMap))); %#ok<*NASGU,*ASGLU>

for i = 1:TypeN
	plot(SmMap(TypeI{i},1),SmMap(TypeI{i},2),'.','Color',color(i,:))
end
title('Sammon Mapping Referece', 'FontSize',16)
xlabel('Dim 1')
ylabel('Dim 2')

%%
% hist3(SmMap,[10 10])
% set(gcf,'renderer','opengl');
% set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');4

%%
close all
clc
diary('log02.txt')
diary on

[Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, L2_distance(SmMap',SmMap')); %#ok<*NASGU,*ASGLU>
disp(['Sammon eredménye: M1 = ' num2str(Mt) '    M2 = ' num2str(Mc) '    F = ' num2str(Mt*Mc)])

[Mt,Mc,V,U] = trustcont(10, X, PCAPoints, DistM, L2_distance(PCAPoints',PCAPoints'));
disp(['PCA eredménye:    M1 = ' num2str(Mt) '    M2 = ' num2str(Mc) '    F = ' num2str(Mt*Mc)])

end
% %
% symbols{1} = {'+','-','*','/'};
symbols{1} = {'+','-','*'};
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
	[resstr, resAgr1, resAgr2] = breeding_result(popu,1);
	disp(resstr);
	a1 = eval(resAgr1);
	a2 = eval(resAgr2);
	hold on
	for i = 1:numel(TypeI)
		plot(a1(TypeI{i}),a2(TypeI{i}),'.','Color',color(i,:))
	end
	drawnow
	hold off
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

