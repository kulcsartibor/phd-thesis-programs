	%% Topnir reptroduki� tesztel�se
% 2012.08.29
% Kulcs�r Tibor
if 1
%% Munkater�let el�k�sz�t�se
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\TopNIR','.\Breeding','.\Functions','.\ExprEval')
load('EUBioDB.mat');
%%
global pics;
pics = 1;
diary('log01.txt')
diary on
%%
X = Xs;
Y = Ys(:,[1:6 18:21 30:32 40]);
% clear('Xs','Ys')

%% Param�terek bet�lt�se
DistM = L2_distance(X',X');					%  
param.Dmax = max(max(DistM));				% MAxim�lis t�vols�g a spektr�lis t�rben (Eukl�deszi)
param.RSphere = 25;							% A keres�si t�r m�rete - a Dmax valah�ny %-�ban megadva
param.Nnb = 5;								% A bevont szomsz�dok maxim�lis sz�ma

%% Topnir emul�tor megh�v�sa 
% result = topnir(Ys, param, DistM);
% 

% %%
% % [positions, error, ev] = mds(DistM, 2);
% % positions = mdscale(DistM,2);
% positions = MDS(DistM);
% % MDSPoints = positions(1:2,:)';
% % MDSPoints = positions.coords{2}';
% MDSPoints = positions.coords{10}(9:10,:)';
% MdsDist = L2_distance(MDSPoints',MDSPoints');
% %%
% P = sammon(X,2,[],[],[],DistM); % uses distance matrix Md
% 
% [Mt,Mc,V,U] = trustcont(5, X, P, DistM, L2_distance(P',P')); %#ok<*NASGU,*ASGLU>
% disp([Mt Mc])
% disp(['Sammon eredm�nye: ' num2str(Mt*Mc)])
% %%
% 
% [Mt,Mc,V,U] = trustcont(5, X, MDSPoints, DistM, L2_distance(MDSPoints',MDSPoints'));
% disp([Mt Mc])
% disp(['MDS eredm�nye: ' num2str(Mt*Mc)])
% 
% %%
% c = mean(X);
% Xp = X - repmat(c, size(X,1), 1);
% covar = cov(Xp);
% opt.disp = 0;
% [p, D] = eigs(covar, 2, 'LA', opt);
% PCAPoints = Xp*p;
% % NormPCA = [((PCAPoints(:,1) - min(PCAPoints(:,1)))./(max(PCAPoints(:,1)) - min(PCAPoints(:,1))))...
% % 	((PCAPoints(:,2) - min(PCAPoints(:,2)))./(max(PCAPoints(:,2)) - min(PCAPoints(:,2))))];
% 
% % PCADist = sqrt(Dist(PCAPoints(:,1)).^2 + Dist(PCAPoints(:,2)).^2);
% PCADist = L2_distance(PCAPoints',PCAPoints');
% % Err = sum(sum(abs(PCADist - NDistM)));
% 
% [Mt,Mc,V,U] = trustcont(5, X, PCAPoints, DistM, L2_distance(PCAPoints',PCAPoints'));
% disp([Mt Mc])
% disp(['PCA eredm�nye: ' num2str(Mt*Mc)])

%%
symbols{1} = {'+','-','*','/'};
% symbols{1} = {'+','-'};
%  symbols{1} = {'/','*'};
for i = 1:size(X,2)
  symbols{2}{i} = sprintf('X(:,%i)',i);
end
clear('i')

%%
popusize = 40;
maxtreedepth = 4;
popu = breeding_init(popusize,maxtreedepth,symbols);
%
%%
% for i = 1:40
% 	disp(tree_stringrc(popu1.chrom{i}.tree,1,popu1.symbols))
% end

%%
clc
[popu] = breeding_evaluate(popu,1:popusize,X,DistM,[]);

disp(breeding_result(popu,1));
disp('=====================================================================================')
end
%
%%
h = figure(1);	
opt = [0.8 0.3 0.7 2 2 0.1 0.1 0.01 1 0];
for c = 82:1000 %1:30 %c = 2:10,
  %iterate 
%   h = figure(1);
  [popu, evnum] = breeding_mainloop(popu,X,DistM,opt);
  %info  
% 	disp(['Gener�ci�: ' num2str(c)]);
% 	disp(['Mapping: ' num2str(popu.unit{1}.fitness)]);


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


figure(1);
	hold off
	fs = get_treeterm(popu);
	
	plot(eval(fs{1}),eval(fs{2}),'.')
	xlabel(fs{1})
	ylabel(fs{2})
	title(['Mapping quality: ' num2str(popu.unit{1}.fitness) , ' G: ', num2str(c)])
	drawnow
	figure(2);
	hold on
	plot(c,popu.unit{1}.fitness,'g*')
	axis([1 45 0 1])
	drawnow
diary off