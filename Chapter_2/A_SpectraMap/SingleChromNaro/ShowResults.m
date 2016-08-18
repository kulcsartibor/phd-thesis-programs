%% Topnir reptrodukió tesztelése
% 2012.08.29
% Kulcsár Tibor

%% Munkaterület elõkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\Breeding','.\Functions','.\ExprEval')
load('EUBioDB.mat');
load('TpAgr');

%%
rng(1)
X = Xs;
Y = Ys(:,[1:6 18:21 30:32 40]);
clear('Xs','Ys')
%%
DistM = L2_distance(X',X');					%  
param.Dmax = max(max(DistM));				% MAximális távolság a spektrális térben (Euklédeszi)
param.RSphere = 25;							% A keresési tér mérete - a Dmax valahány %-ában megadva
param.Nnb = 5;								% A bevont szomszédok maximális száma

%%
popu = loadlastpopu('Popu');
%load('.\Popu\Popu_1000.mat');
[~,~,fs] = breeding_result(popu,1);
%fs = get_treeterm(popu);



disp(Agr.Naro);
disp(fs)

MultiChromMap = [eval(Agr.Naro) eval(fs)];


[Mt,Mc,~,~] = trustcont(10, X, MultiChromMap, DistM, squareform(pdist(MultiChromMap)))
Mt*Mc

figure('Color',[1 1 1])
plot(MultiChromMap(:,1), MultiChromMap(:,2), '.')

xlabel('Naro [-]')
ylabel('Genetic aggregate [-]')
axis('square')


return

%% Paraméterek betöltése
if 0


%%
D = squareform(pdist(X));
% MdsMap = cmdscale(D);
MdsMap = mdscale(D,2,'Criterion','strain','Start','cmdscale');
plot(MdsMap(:,1),MdsMap(:,2),'.')
[Mt,Mc,V,U] = trustcont(10, X, MdsMap, DistM, squareform(pdist(MdsMap))); %#ok<*NASGU,*ASGLU>
title([num2str(Mt), ' ', num2str(Mc), ' ', num2str(Mt*Mc)])

%%

SmMap = sammon(X,2,1000,'steps',[],DistM); %#ok<UNRCH>

c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
PCAPoints = Xp*p;

% [Mt,Mc,V,U] = trustcont(10, X, PCAPoints, DistM, squareform(pdist(PCAPoints))); %#ok<*NASGU,*ASGLU>
[Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, squareform(pdist(SmMap))); %#ok<*NASGU,*ASGLU>

plot(SmMap(:,1),SmMap(:,2),'.')
title([num2str(Mt), ' ', num2str(Mc), ' ', num2str(Mt*Mc)])

else
	load('Refmaps.mat')
end
%%
figure('Color',[1 1 1])
[Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, squareform(pdist(SmMap))); %#ok<*NASGU,*ASGLU>

plot(SmMap(:,1),SmMap(:,2),'k.')
title('Sammon Mapping Referece', 'FontSize',16)
xlabel('Dim 1')
ylabel('Dim 2')

%%
hist3(SmMap,[30 30])
set(gcf,'renderer','opengl');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');

%%
clc
diary('log02.txt')
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

