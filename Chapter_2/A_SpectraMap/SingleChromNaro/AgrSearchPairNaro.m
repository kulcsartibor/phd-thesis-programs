%% Topnir reptrodukió tesztelése
% 2012.08.29
% Kulcsár Tibor

%% Munkaterület elõkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\Breeding','.\Functions','.\ExprEval')
load('EUBioDB.mat');
load('TpAgr');

%%
X = Xs;
Y = Ys(:,[1:6 18:21 30:32 40]);
Prop = variables([1:6 18:21 30:32 40]);
clear('Xs','Ys','variables')

%%
DistM = L2_distance(X',X');	

%%
if 0
SmMap = sammon(X,2,1000,'steps',[],DistM); %#ok<UNRCH>

c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
PCAPoints = Xp*p;

else
	load('Refmaps.mat')
end

%%
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
[popu] = breeding_evaluate(popu,Agr.Naro,1:popusize,X,DistM,[]);
disp(Agr.Karo)
disp(breeding_result(popu,1));

%%	
opt = [0.8 0.3 0.7 2 2 0.1 0.1 0.01 1 0];

for c = 1:1000
	[popu, evnum] = breeding_mainloop(popu,Agr.Naro,X,DistM,opt);

% 	disp(['Generáció: ' num2str(c)]);
% 	disp(['Mapping: ' num2str(popu.chrom{1}.fitness)]);
	disp(breeding_result(popu,1));
	
	save(['.\Popu\popu_' num2str(c) '.mat'], 'popu')

end

diary off
