%% Munkaterület elõkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\Breeding','.\Functions','.\ExprEval')
% popu = loadlastpopu('Popu');
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

%%
cv = cvpartition(Type,'k',10);

%% Lineáris discriminanacia
pred_lin = zeros(size(Type));
pred_qua = zeros(size(Type));
pred_c45 = zeros(size(Type));
for i = 1:cv.NumTestSets
	MdlLinear = fitcdiscr(X(cv.training(i),:),Type(cv.training(i)), 'DiscrimType','pseudoLinear');
	MdlQuadratic = fitcdiscr(X(cv.training(i),:),Type(cv.training(i)), 'DiscrimType','pseudoQuadratic');
	c45_Mod = C45(X(cv.training(i),:),Type(cv.training(i)));
		
	pred_lin(cv.test(i)) = predict(MdlLinear,X(cv.test(i),:));
	pred_qua(cv.test(i)) = predict(MdlQuadratic,X(cv.test(i),:));
	pred_c45(cv.test(i)) = c45test(X(cv.test(i),:),c45_Mod);
end

%%
disp('Linear discriminant')
M = confusionmat(Type,pred_lin);
disp(M)
disp('Fit')
[sum(sum(eye(size(M,1)).*M))/sum(M(:))]

disp('Quaratic discriminant')
M = confusionmat(Type,pred_qua);
disp(M)
disp('Fit');
[sum(sum(eye(size(M,1)).*M))/sum(M(:))]

disp('C4.5 decision tree')
M = confusionmat(Type,pred_c45);
disp(M)
disp('Fit')
[sum(sum(eye(size(M,1)).*M))/sum(M(:))]
%%














return

%%
figure(1);
k=1;
for i = 1:size(X,2)
	for j = 1:size(X,2)
		if(i == j)
			continue;
		end
		subplot(13,13,k);
		h1 = gscatter(X(:,i),X(:,j),Type,'krb','ov^',[],'off');
		h1(1).LineWidth = 2;
		h1(2).LineWidth = 2;
		h1(3).LineWidth = 2;
% 		legend('Setosa','Versicolor','Virginica','Location','best')
		hold on
		k = k+1 ;
	end
end

%%
% h1 = gscatter(X(:,13),X(:,12),Type,'krb','ov^',[],'off');
% h1(1).LineWidth = 2;
% h1(2).LineWidth = 2;
% h1(3).LineWidth = 2;
% hold on
% MdlLinear.ClassNames([2 3])
% K = MdlLinear.Coeffs(2,3).Const;
% L = MdlLinear.Coeffs(2,3).Linear;
% f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
% h2 = ezplot(f,[200 1800 0 5])
% h2.Color = 'r';
% h2.LineWidth = 2;

%% Stenderd c4.5
c45_Mod = C45(X,Type);
class = c45test(X,c45_Mod);
disp(confusionmat(Type,class));

%%	
