%% CUSUM Chart
% 2012.06.14
% Kulcsár Tibor

%%
clear all; close all; clc;
[numeric, text]=xlsread('BEK4_model.xlsx','Model2');

%% Idõ kiolvasása
for i = 1:size(numeric,1)
	if size(text{i+1,1},2) > 15
		T(i) = datenum(text{i+1,1}, 'yyyy.mm.dd. HH:MM');
	else
		T(i) = datenum(text{i+1,1}, 'yyyy.mm.dd.');
	end
end

%%
Y = numeric(:,1);
X = numeric(:,2:end);
%%
X = [X ones(size(X,1),1)];

%%
figure('Name','Szûrés','NumberTitle','off', 'Color',[1 1 1]);
teta = X\Y;
Ym = X*teta;
plot(Y,Ym,'.')
Li = find(Ym < Y);
Lo = find(Ym > Y);
plot(Y(Li),Ym(Li),'r.')
hold on
plot(Y(Lo),Ym(Lo),'b.')
% axis([2 6 2 6])
axis([200 700 200 700])
set(gca,'FontSize',20)

%%
figure('Name','I Chart','NumberTitle','off', 'Color',[1 1 1]);
xData = linspace(T(1),T(end),12);

Ic = cumsum(I);

I = Y - Ym;
Ist = std(Ic);
Im = mean(I);

MRm = mean(abs(diff(I)));
UCL = Im+2.66*MRm;
LCL = Im-2.66*MRm;

ca = subplot(2,1,1);
plot(T,I,'b.', 'MarkerSize', 4);
axis([T(1) T(end) -200 200])
set(gca,'XTick',xData);
datetick('x','mm.dd. HH:MM','keepticks');
rotateticklabel(ca,45);
line([T(1) T(end)], [UCL UCL],'Color',[1 0 0])
line([T(1) T(end)], [LCL LCL],'Color',[1 0 0])
line([T(1) T(end)], [Im Im],'Color',[0 0 0], 'LineStyle', '--', 'LineWidth', 2)

% set(gca,'FontSize',12)
title('Energy usage prediction error');

ca = subplot(2,1,2);

plot(T,Ic,'LineWidth', 2);
axis([T(1) T(end) -1e5 1e5])
set(gca,'XTick',xData);
datetick('x','mm.dd. HH:MM','keepticks');
rotateticklabel(ca,45);
% xlabel('Time');
line([T(1) T(end)], [0 0],'Color',[0 0 0],'LineStyle', '--', 'LineWidth', 2)
title('Cumlative sum of prediction error');
line([T(1) T(end)], [1*Ist 1*Ist],'Color',[1 0 0])
line([T(1) T(end)], [-1*Ist -1*Ist],'Color',[1 0 0])


% line([T(1) T(end)], [LCL LCL],'Color',[1 0 0])
%%
X = numeric(:,1:end);
N = size(X,2);
%%
for i = 1:N
	for j = i:N
		subplot(N, N, (i-1)*N + j);
		qqplot(X(:,i),X(:,j));
		xlabel(text{1,i+1})
		ylabel(text{1,j+1})
	end
end
%%
figure(10)
for i =1:N
	subplot(1,N,i)
	boxplot(X(:,i))
	title(text{1,i+1})
end

%%
s = floor(size(X,1)/5);
for i =0:4
	subplot(1,5,i+1)
% 	i*s+1:(i+1)*s
	boxplot(X(i*s+1:(i+1)*s,1))
	xlabel([datestr(T(i*s+1), 'yyyy.mm.dd') ' - ' datestr(T((i+1)*s), 'yyyy.mm.dd')])
	set(gca,'XTick',[])
% 	title(text{1,i+1})
end

%%
%
N = 168;
for i = 1:1:5
	subplot(1,5,6-i)
% 	i*s+1:(i+1)*s
	boxplot(X(end-i*N:end-(i-1)*N,1))
	xlabel([datestr(T(end-i*N), 'yyyy.mm.dd HH:MM') ' - ' datestr(T(end-(i-1)*N), 'yyyy.mm.dd HH:MM')])
	set(gca,'XTick',[])
	c = axis
	axis([c(1:2) 300 580])
	
% 	title(text{1,i+1})
end

%% PLS
pl = pls(X,Y,2);

figure(11)
pm = pls2DComp(pl);
plot(pm.tw1,pm.tw2,'.')
xlabel('Latent Variable 1')
ylabel('Latent Variable 2')

figure(12)
plot(Y,pl.Ypc,'.')
xlabel('Y')
ylabel('Ypc')

