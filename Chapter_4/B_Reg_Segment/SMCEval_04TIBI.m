%% Inic data proc
clear all; close all; clc;
load('Data.mat')
X(:,end)=[];
addpath('.\PLS') % ,'.\SOM')
Id = find(X(:,1) < 60);
Id=[Id ; [1:250]'];
X(Id,:) = [];
Y(Id) = [];
T(Id) = [];
xData = linspace(T(1),T(end),12);
Y = (Y-repmat(mean(Y),size(X,1),1))./repmat(std(Y),size(X,1),1);
X = (X-repmat(mean(X),size(X,1),1))./repmat(std(X),size(X,1),1);
color = [0 1 0; 0 1 1; 1 0 0];
%% Linear model 
figure(10)
beta = X\Y;
Ym = X*beta;
%figure('Name','Szûrés','NumberTitle','off', 'Color',[1 1 1]);
plot(Y,Ym,'+','MarkerSize',1)
hold on
axis([min(Y) max(Y) min(Y) max(Y)])
line([min(Y) max(Y)],[min(Y) max(Y)] ,'Color',[0 0 0],'LineWidth',2)
xlabel('$y$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',12)
Residual = Y-Ym;
sigmaR = std(Residual);
muR = mean(Residual);
h = [];
for i = 1:3
	h(i) = line([min(Y) max(Y)],[min(Y)+i*sigmaR max(Y)+i*sigmaR],'LineStyle','--','Color',color(i,:),'LineWidth',2);
 	line([min(Y) max(Y)],[min(Y)-i*sigmaR max(Y)-i*sigmaR],'LineStyle','--','Color',color(i,:),'LineWidth',2)
end
hl = legend(h,'\sigma','2\sigma','3\sigma');
set(hl,'Location','SouthEast')
sigmaR
%% PLS model
figure(20)
plsm = pls(X,Y,4);
Ym=plsm.Ypc;
plot(Y,plsm.Ypc,'+','MarkerSize',3)
axis([min(Y) max(Y) min(Y) max(Y)])
Residual = Y-Ym;
sigmaR = std(Residual)
muR = mean(Residual);
h = [];
for i = 1:3
	h(i) = line([min(Y) max(Y)],[min(Y)+i*sigmaR max(Y)+i*sigmaR],'LineStyle','--','Color',color(i,:),'LineWidth',3);
 	line([min(Y) max(Y)],[min(Y)-i*sigmaR max(Y)-i*sigmaR],'LineStyle','--','Color',color(i,:),'LineWidth',3)
end
hl = legend(h,'\sigma','2\sigma','3\sigma');
set(hl,'Location','SouthEast')
xlabel('$y$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',12)
print  -djpeg90 -f20
figure(30)
cmprsm = pls2DComp(plsm);
%cmprsm.tw1 =plsm.T(:,1);
%cmprsm.tw2 =plsm.T(:,2);
%figure('Name','PLS','NumberTitle','off', 'Color',[1 1 1]);
% indexU = find((Y-plsm.Ypc) < -0*sigmaR);
% indexD = find((Y-plsm.Ypc) > 0*sigmaR);

 indexU = find((Y) < mean(Y));
 indexD = find((Y) > mean(Y));

%plot(cmprsm.tw1,cmprsm.tw2,'+','MarkerSize',1)
hold on
plot(cmprsm.tw1(indexU),cmprsm.tw2(indexU),'r+','MarkerSize',5)
plot(cmprsm.tw1(indexD),cmprsm.tw2(indexD),'gO','MarkerSize',5)
xlabel('Latent variable 1.')
ylabel('Latent variable 2.')
print  -djpeg90 -f30
%%
figure(40)
%figure('Color',[1 1 1])
subplot(3,1,1)
plot(T,cmprsm.tw1)
set(gca,'XTick',xData);
datetick('x',25);
ylabel('Latent variable 1.')
% rotateticklabel(ca,45);
subplot(3,1,2)
plot(T,cmprsm.tw2)
set(gca,'XTick',xData);
datetick('x',25);
ylabel('Latent variable 2.')
subplot(3,1,3)
plot(T,Y-plsm.Ypc)
set(gca,'XTick',xData);
datetick('x',25);
ylabel('prediction error')
print  -djpeg90 -f40

%% SPC 
figure(50)
subplot(3,1,1)
plot(T,(Y), 'r' )
set(gca,'XTick',xData);
datetick('x',25);


subplot(3,1,2)
plot(T,(Y-plsm.Ypc))
set(gca,'XTick',xData);
datetick('x',25);
line([min(T) max(T)],[mean(((Y-plsm.Ypc))) mean(((Y-plsm.Ypc)))],'Color',[1 0 0])
line([min(T) max(T)],[-mean(((Y-plsm.Ypc))) -mean(((Y-plsm.Ypc)))],'Color',[1 0 0])

subplot(3,1,3)
plot(T,cumsum(Y-plsm.Ypc))
set(gca,'XTick',xData);
datetick('x',25);

print  -djpeg90 -f40
