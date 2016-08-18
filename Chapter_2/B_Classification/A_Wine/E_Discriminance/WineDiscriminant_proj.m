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
X = (X - repmat(mean(X),size(X,1),1)) ./ (repmat(std(X),size(X,1),1));

Prop = {	'Alcohol','Malic acid','Ash','Alcalinity of ash','Magnesium',...
			'Total phenols','Flavanoids','Nonflavanoid phenols','Proanthocyanins',...
			'Color intensity','Hue','OD280/OD315 of diluted wines','Proline '};

%% Prepare cross validation
cv = cvpartition(Type,'k',10);

%%
Mu_t = cell(TypeN,1);
S_t = cell(TypeN,1);
Mu = zeros(1, size(X,2));
Sw = zeros(size(X,2));
N = zeros(TypeN,1);
for i = 1:TypeN
	N(i) = size(X(TypeI{i},:),1);
	Mu_t{i} = mean(X(TypeI{i},:));
	S_t{i} = cov(X(TypeI{i},:));
	
	Mu = Mu + Mu_t{i};
	Sw = Sw + S_t{i};
end
Mu = Mu ./ 3;

%%
SB_t = zeros(TypeN,1);
SB = 0;
for i = 1:TypeN
	SB_t(i) = N(i) .* (Mu_t{i}-Mu)*(Mu_t{i}-Mu)';
	SB = SB + SB_t(i);
end

%%
invSw = inv(Sw);
invSw_by_SB = invSw*SB;
[V,D] = eig(invSw_by_SB);
W1 = V(:,1);
W2 = V(:,2);

%%
hfig = figure;
axes1 = axes('Parent', hfig, 'FontWeight','bold','FontSize',12);
hold('all')
xlabel('X_1 - the first feature')
ylabel('X_2 - the second feature')
scatter(X(TypeI{1},1),X(TypeI{1},2),'r','LineWidth',1,'Parent',axes1)
hold on
scatter(Mu_t{1}(1),Mu_t{1}(2),'co','MarkerEdgeColor','c',...
	'MarkerFaceColor','c','Parent',axes1)

scatter(X(TypeI{2},1),X(TypeI{2},2),'g','LineWidth',1,'Parent',axes1)
hold on
scatter(Mu_t{2}(1),Mu_t{2}(2),'mo','MarkerEdgeColor','m',...
	'MarkerFaceColor','m','Parent',axes1)

scatter(X(TypeI{3},1),X(TypeI{3},2),'b','LineWidth',1,'Parent',axes1)
hold on
scatter(Mu_t{3}(1),Mu_t{3}(2),'yo','MarkerEdgeColor','y',...
	'MarkerFaceColor','y','Parent',axes1)

% xlimits = [floor(min(X(:,1))) ceil(max(X(:,1)))];
% ylimits = [floor(min(X(:,2))) ceil(max(X(:,2)))];
% 
% t = -80:80;
% line_x1 = t * W1(1);
% line_y1 = t * W1(1);
% 
% t = -10:10;
% line_x2 = t * W2(1);
% line_y2 = t * W2(2);
% 
% plot(line_x1,line_y1,'k-','LineWidth',2)
% hold on
% plot(line_x2,line_y2,'k-','LineWidth',2)
% grid on



%%
y1_w1 = W1'*X(TypeI{1},:)';
y2_w1 = W1'*X(TypeI{2},:)';
y3_w1 = W1'*X(TypeI{3},:)';

minY = min([y1_w1 y2_w1 y3_w1]);
maxY = max([y1_w1 y2_w1 y3_w1]);
y_w1 = minY:0.05:maxY;

y1_w1_Mu = mean(y1_w1);
y1_w1_sigma = std(y1_w1);
y1_w1_pdf = mvnpdf(y_w1',y1_w1_Mu,y1_w1_sigma);

y2_w1_Mu = mean(y2_w1);
y2_w1_sigma = std(y2_w1);
y2_w1_pdf = mvnpdf(y_w1',y2_w1_Mu,y2_w1_sigma);

y3_w1_Mu = mean(y3_w1);
y3_w1_sigma = std(y3_w1);
y3_w1_pdf = mvnpdf(y_w1',y3_w1_Mu,y3_w1_sigma);

y1_w2 = W2'*X(TypeI{1},:)';
y2_w2 = W2'*X(TypeI{2},:)';
y3_w2 = W2'*X(TypeI{3},:)';

minY = min([y1_w2 y2_w2 y3_w2]);
maxY = max([y1_w2 y2_w2 y3_w2]);
y_w2 = minY:0.05:maxY;

y1_w2_Mu = mean(y1_w2);
y1_w2_sigma = std(y1_w2);
y1_w2_pdf = mvnpdf(y_w2',y1_w2_Mu,y1_w2_sigma);

y2_w2_Mu = mean(y2_w2);
y2_w2_sigma = std(y2_w2);
y2_w2_pdf = mvnpdf(y_w2',y2_w2_Mu,y2_w2_sigma);

y3_w2_Mu = mean(y3_w2);
y3_w2_sigma = std(y3_w2);
y3_w2_pdf = mvnpdf(y_w2',y3_w2_Mu,y3_w2_sigma);

%%
figure;
scatter(y1_w1,y1_w2,'ro','MarkerEdgeColor','r')
hold on
scatter(y2_w1,y2_w2,'go','MarkerEdgeColor','g')
scatter(y3_w1,y3_w2,'bo','MarkerEdgeColor','b')

t = -80:80;
line_x1 = t * W1(1);
line_y1 = t * W1(1);

t = -10:10;
line_x2 = t * W2(1);
line_y2 = t * W2(2);
plot(line_x1,line_y1,'k-','LineWidth',2)
hold on
plot(line_x2,line_y2,'k-','LineWidth',2)
grid on

%%
figure;
subplot(2,1,1)
plot(y_w1,y1_w1_pdf,'r-')
hold on
plot(y_w1,y2_w1_pdf,'g-')
plot(y_w1,y3_w1_pdf,'b-')

subplot(2,1,2)
plot(y_w2,y1_w2_pdf,'r-')
hold on
plot(y_w2,y2_w2_pdf,'g-')
plot(y_w2,y3_w2_pdf,'b-')

%%
return
