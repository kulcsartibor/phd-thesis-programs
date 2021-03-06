%% Frekvenciaanal�zis S�r� adatsorra
clear all; close all; clc;
load('Data.mat')

% X(:,5) = [];

% X = (X -  repmat(mean(X),size(X,1),1))./repmat(std(X),size(X,1),1); 


Id = find(X(:,1) < 60);
X(Id,:) = [];
Y(Id) = [];
T(Id) = [];
%%
% figure('Name','Sz�r�s','NumberTitle','off', 'Color',[1 1 1]);
% teta = X\Y;
% Ym = X*teta;
% 
% plot(Y,Ym,'.')
% Li = find(Ym < Y);
% Lo = find(Ym > Y);
% plot(Y(Li),Ym(Li),'r.')
% hold on
% plot(Y(Lo),Ym(Lo),'b.')
% % axis([2 6 2 6])
% axis([200 700 200 700])
% set(gca,'FontSize',20)

%%
X(:,5) = 0;
Y = (Y-min(Y))./(max(Y)-min(Y));
X = (X - repmat(min(X),size(X,1),1))./(repmat(max(X),size(X,1),1)- repmat(min(X),size(X,1),1));
X(:,5) = 1;

Yu = Y; Xu = X; Tu = T;

[Y, I] = sort(Y);
X = X(I,:);
T = T(I);

beta = X\Y;
Ym = X*beta;


%%
figure('Name','Sz�r�s','NumberTitle','off', 'Color',[1 1 1]);
plot(Y,Ym,'+','MarkerSize',1)
axis([0 1 0 1])
line([0 1],[0 1],'Color',[0 0 0],'LineWidth',2)
xlabel('$y$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',12)
axis square

%% Regression plot
Residual = Y-Ym;
sigmaR = std(Residual);
muR = mean(Residual);

color = [0 1 0; 1 1 0; 1 0 0];
% color = [0 0 0; 0 0 0; 0 0 0];
h = [];
for i = 1:3
	h(i) = line([0 1],[i*sigmaR 1+i*sigmaR],'LineStyle','--','Color',color(i,:),'LineWidth',2);
	line([0 1],[-i*sigmaR 1-i*sigmaR],'LineStyle','--','Color',color(i,:),'LineWidth',2)
end
hl = legend(h,'\sigma','2\sigma','3\sigma');
set(hl,'Location','SouthEast')

%% Confidence calculation
figure('Name','Sz�r�s','NumberTitle','off', 'Color',[1 1 1]);
hold on
plot(Y,Ym,'+','MarkerSize',1)
axis([0 1 0 1])
line([0 1],[0 1],'Color',[0 0 0],'LineWidth',2)
xlabel('$y$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',12)

alpha = 1e-7;
se = sqrt(sum((Y-Ym).^2)/(size(Y,1)-2));
Gap = zeros(size(Y,1),1);

for i = 1:size(Y,1)
	xm = X(i,:)';
	ster = se*sqrt(xm'*inv(X'*X)*xm);
	Gap(i) = ster*tinv(1-alpha/2 ,size(Y,1)-2);
% 	line([Y(i) Y(i)], [Ym(i)-gap Ym(i)+gap],'Color',[0 1 0])
end


fitfun = createFit(Y,Gap);
GapF = feval(fitfun,Y);
plot(Y,Y+GapF,'r--','LineWidth',1)
plot(Y,Y-GapF,'r--','LineWidth',1)
box on

%%

Inkonf = find((GapF-abs(Y-Ym)) > 0);

% plot(Y(Inkonf),Ym(Inkonf),'.')
plot(Tu,Yu);
hold on
plot(T(Inkonf),Ym(Inkonf),'r*')




%%
% hist3([Y-Ym Gapf],[50 50])
% set(gcf,'renderer','opengl');
% set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');


