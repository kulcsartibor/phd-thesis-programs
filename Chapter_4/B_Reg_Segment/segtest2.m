clear all; close all; clc;
load('Data.mat')

DeI = find(X(:,1) < 60);
X(DeI,:) = [];
Y(DeI) = [];
T(DeI) = [];
X(1:8,:) = [];
Y(end-7:end) = [];

X(:,5) = 0;
Y = (Y-min(Y))./(max(Y)-min(Y));
X = (X - repmat(min(X),size(X,1),1))./(repmat(max(X),size(X,1),1)- repmat(min(X),size(X,1),1));
X(:,5) = 1;
%%
figure('Name','Szegmentálás','NumberTitle','off','Color',[1 1 1])
subplot(5,1,1:3)

forceplot=1;
[segment, Ym] = regseg(Y,X,20,forceplot);
axis([0 numel(Ym) 0 1])
box on


ylabel('$y, \hat{y}$','Interpreter','latex','FontSize',12)
set(gca,'XTickLabel',[]) 

for i = 1:numel(segment)
	line([segment(i).lx segment(i).lx],[0 1],'Color',[0 0 0])
	line([segment(i).rx segment(i).rx],[0 1],'Color',[0 0 0])
end

%%
subplot(5,1,4)
mmc = max([segment(1:end-1).mc]);
plot(round(([segment(:).lx] + [segment(:).rx])/2), [segment(:).mc]/mmc/10,'k*')

for i = 1:numel(segment)-1
	rectangle('Position',[segment(i).lx+20, 0, segment(i).rx-segment(i).lx-40, segment(i).mc/mmc],'FaceColor',[0.75 0.75 0.75]);
end
ylabel('$\hat{y}_{e,r}$','Interpreter','latex','FontSize',12)
axis([0 numel(Ym) 0 1])

%%
subplot(5,1,5)
plot(cumsum(Y-Ym(10:end)),'k')
xlabel('$Time$','Interpreter','latex','FontSize',12)
ylabel('$\sum{\left(y - \hat{y}\right)}$','Interpreter','latex','FontSize',12)

%%
figure('Name','Szegmentálás eredmény','NumberTitle','off','Color',[1 1 1])
subplot(2,2,1)
Yml = X(segment(4).lx+1:segment(4).rx,:)*segment(4).M;
plot(Y(segment(4).lx+1:segment(4).rx),Yml,'+','MarkerSize',1)
line([0 1],[0 1],'LineStyle','--','LineWidth',2,'Color',[0 0 0])
sgm = std(Y(segment(4).lx+1:segment(4).rx)-Yml);
axis([0 1 0 1])
color = [0 1 0; 1 1 0; 1 0 0]
for i = 1:3
	line([0 1],[i*sgm 1+i*sgm],'LineStyle','--','LineWidth',2,'Color',color(i,:))
	line([0 1],[-i*sgm 1-i*sgm],'LineStyle','--','LineWidth',2,'Color',color(i,:))
end
xlabel('$y_{4}$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}_{4}$','Interpreter','latex','FontSize',12)
title('$Segment~4~local~model$','Interpreter','latex','FontSize',12)
axis square


subplot(2,2,2)
Yml = X(segment(17).lx+1:segment(17).rx,:)*segment(17).M;
plot(Y(segment(17).lx+1:segment(17).rx),Yml,'+','MarkerSize',1)
line([0 1],[0 1],'LineStyle','--','LineWidth',2,'Color',[0 0 0])
axis([0 1 0 1])
sgm = std(Y(segment(17).lx+1:segment(17).rx)-Yml);
for i = 1:3
	line([0 1],[i*sgm 1+i*sgm],'LineStyle','--','LineWidth',2,'Color',color(i,:))
	line([0 1],[-i*sgm 1-i*sgm],'LineStyle','--','LineWidth',2,'Color',color(i,:))
end
xlabel('$y_{17}$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}_{17}$','Interpreter','latex','FontSize',12)
title('$Segment~17~local~model$','Interpreter','latex','FontSize',12)
axis square
%
subplot(2,2,3)
Yml = X*segment(4).M;
plot(Y,Yml,'+','MarkerSize',1)
line([0 1],[0 1],'LineStyle','--','LineWidth',2,'Color',[0 0 0])
sgm = std(Y-Yml);
axis([0 1 0 1])
for i = 1:3
	line([0 1],[i*sgm 1+i*sgm],'LineStyle','--','LineWidth',2,'Color',color(i,:))
	line([0 1],[-i*sgm 1-i*sgm],'LineStyle','--','LineWidth',2,'Color',color(i,:))
end
xlabel('$y$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',12)
title('$\hat{y}~=~X\cdot\beta_{4}$','Interpreter','latex','FontSize',12)
axis square

subplot(2,2,4)
Yml = X*segment(17).M;
plot(Y,Yml,'+','MarkerSize',1)
line([0 1],[0 1],'LineStyle','--','LineWidth',2,'Color',[0 0 0])
axis([0 1 0 1])
sgm = std(Y-Yml);
for i = 1:3
	line([0 1],[i*sgm 1+i*sgm],'LineStyle','--','LineWidth',2,'Color',color(i,:))
	line([0 1],[-i*sgm 1-i*sgm],'LineStyle','--','LineWidth',2,'Color',color(i,:))
end
xlabel('$y$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',12)
title('$\hat{y}~=~X\cdot\beta_{17}$','Interpreter','latex','FontSize',12)
axis square








