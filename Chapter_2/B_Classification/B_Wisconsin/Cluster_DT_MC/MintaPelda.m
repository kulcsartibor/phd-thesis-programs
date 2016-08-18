%% Munkaterület elõkészítése
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\Breeding','.\Functions','.\ExprEval')
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

%%
% A1 = 0.5*((5*(X(:,11)))+(7*(((X(:,9))+(X(:,5))).*((X(:,9))-(X(:,1))))));
% A2 = 0.5*((1*(X(:,13)))-(((6*(X(:,7)))+(1*(X(:,2))))+(9.5*((X(:,13)).*(X(:,13))))));

A1 = 0.5*(((1*(X(:,13)))-(1*(X(:,7))))-(((1*(X(:,11)))-(2*(X(:,10))))-((1*(X(:,13)))+(1*(X(:,1))))));
A2 = 0.5*((1*(((X(:,6))+(X(:,12))).*((X(:,5))+(X(:,9)))))+(3*(X(:,7))));


% mi1 = min(A1);
% ma1 = max(A1);
% mi2 = min(A2);
% ma2 = max(A2);
area = [min(A1) min(A2); max(A1) max(A2)];

%%
tree=C45([A1 A2],Type);

%%
correct=sum((c45test([A1 A2],tree)-Type==0))/size([A1 A2],1)*100

%%
h = figure(1);
hold on
for i = 1:numel(TypeI)
	plot(A1(TypeI{i}),A2(TypeI{i}),'.','Color',color(i,:))
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



















