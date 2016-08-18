%% Munkaterület elõkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\Breeding','.\Functions','.\ExprEval')
popu = loadlastpopu('Popu');
% load('EUBioDB.mat');
%%
global TypeI TypeN Type
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
color = hsv(TypeN);
marker = '+*d';

% %%
% if 0
% 
% 
% %%
% D = squareform(pdist(X));
% % MdsMap = cmdscale(D);
% MdsMap = mdscale(D,2,'Criterion','strain','Start','cmdscale');
% figure('Color',[1 1 1])
% hold on
% for i = 1:TypeN
% 	plot(MdsMap(TypeI{i},1),MdsMap(TypeI{i},2),'.','Color',color(i,:))
% end
% [Mt,Mc,V,U] = trustcont(10, X, MdsMap, DistM, squareform(pdist(MdsMap))); %#ok<*NASGU,*ASGLU>
% title([num2str(Mt), ' ', num2str(Mc), ' ', num2str(Mt*Mc)])
% 
% %%
% c = mean(X);
% Xp = X - repmat(c, size(X,1), 1);
% covar = cov(Xp);
% opt.disp = 0;
% [p, D] = eigs(covar, 2, 'LA', opt);
% PCAPoints = Xp*p;
% 
% [Mt,Mc,V,U] = trustcont(10, X, PCAPoints, DistM, squareform(pdist(PCAPoints))); %#ok<*NASGU,*ASGLU>
% % [Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, squareform(pdist(SmMap))); %#ok<*NASGU,*ASGLU>
% figure('Color',[1 1 1])
% hold on
% for i = 1:TypeN
% 	plot(PCAPoints(TypeI{i},1),PCAPoints(TypeI{i},2),'.','Color',color(i,:))
% end
% 
% title([num2str(Mt), ' ', num2str(Mc), ' ', num2str(Mt*Mc)])
% 
% %%
% figure('Color',[1 1 1])
% hold on
% SmMap = sammon(X,2,1000,'steps',[],DistM);
% [Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, squareform(pdist(SmMap))); %#ok<*NASGU,*ASGLU>
% 
% for i = 1:TypeN
% 	plot(SmMap(TypeI{i},1),SmMap(TypeI{i},2),'.','Color',color(i,:))
% end
% title('Sammon Mapping Referece', 'FontSize',16)
% xlabel('Dim 1')
% ylabel('Dim 2')
% 
% %%
% % hist3(SmMap,[10 10])
% % set(gcf,'renderer','opengl');
% % set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');4
% 
% %%
% close all
% clc
% diary('log02.txt')
% diary on
% 
% [Mt,Mc,V,U] = trustcont(10, X, SmMap, DistM, L2_distance(SmMap',SmMap')); %#ok<*NASGU,*ASGLU>
% disp(['Sammon eredménye: M1 = ' num2str(Mt) '    M2 = ' num2str(Mc) '    F = ' num2str(Mt*Mc)])
% 
% [Mt,Mc,V,U] = trustcont(10, X, PCAPoints, DistM, L2_distance(PCAPoints',PCAPoints'));
% disp(['PCA eredménye:    M1 = ' num2str(Mt) '    M2 = ' num2str(Mc) '    F = ' num2str(Mt*Mc)])
% 
% end
%%
% A1 = 0.5*((5*(X(:,11)))+(7*(((X(:,9))+(X(:,5))).*((X(:,9))-(X(:,1))))));
% A2 = 0.5*((1*(X(:,13)))-(((6*(X(:,7)))+(1*(X(:,2))))+(9.5*((X(:,13)).*(X(:,13))))));

%A1 = 0.5*(((1*(X(:,13)))-(1*(X(:,7))))-(((1*(X(:,11)))-(2*(X(:,10))))-((1*(X(:,13)))+(1*(X(:,1))))));
%A2 = 0.5*((1*(((X(:,6))+(X(:,12))).*((X(:,5))+(X(:,9)))))+(3*(X(:,7))));


[resstr, resAgr1, resAgr2] = breeding_result(popu,1);
disp(resstr);
A1 = eval(resAgr1);
A2 = eval(resAgr2);

area = [min(A1) min(A2); max(A1) max(A2)];

%%
tree=C45([A1 A2],Type);

%%
correct = sum((c45test([A1 A2],tree)-Type==0))/size([A1 A2],1)*100

%%
disp('Agr + C4.5 decision tree')
M = confusionmat(Type,c45test([A1 A2],tree));
disp(M)
disp('Fit')
[sum(sum(eye(size(M,1)).*M))/sum(M(:))]

%%
disp('Agr + 10k C4.5 decision tree')
cv = cvpartition(Type,'k',10);
pred_c45 = zeros(size(Type));
Y_c = [A1 A2];

for i = 1:cv.NumTestSets
	c45_Mod = C45(Y_c(cv.training(i),:),Type(cv.training(i)));
	pred_c45(cv.test(i)) = c45test(Y_c(cv.test(i),:),c45_Mod);
end

M = confusionmat(Type,pred_c45);
disp(M)
disp('Fit')
[sum(sum(eye(size(M,1)).*M))/sum(M(:))]

%%
h = figure('Color',[1 1 1]);
hold on
for i = 1:numel(TypeI)
	plot(A1(TypeI{i}),A2(TypeI{i}),marker(i),'Color',color(i,:))
end

i = find(tree.depth == 0);
tree.area = cell(1,numel(tree.depth));
tree.area{i(1)} = area;
tree.area{i(2)} = area;

vgplot(area,tree,1)

line([area(1, 1) area(1, 1)],[area(1, 2) area(2, 2)])
line([area(1, 1) area(2, 1)],[area(2,2) area(2, 2)])
line([area(2, 1) area(2, 1)],[area(2, 2) area(1, 2)])
line([area(2, 1) area(1, 1)],[area(1, 2) area(1, 2)])
axis([area(1, 1) area(2, 1) area(1, 2) area(2, 2)])

axis square

xlabel('Aggregate 1 [-]')
ylabel('Aggregate 2 [-]')

return

%%
f1i = find(tree.feature == 1);
f2i = find(tree.feature == 2);

mi1 = min(A1);
ma1 = max(A1);
mi2 = min(A2);
ma2 = max(A2);

for i = 2:numel(f1i)
	line(repmat(tree.cut(f1i(i)),1,2), [mi2 ma2])
end

for i = 2:numel(f2i)
	line([mi1 ma1], repmat(tree.cut(f2i(i)),1,2))
end

%%

for i = 1:numel(tree.depth)
	
	
	
	
end



















