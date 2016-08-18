%% Frekvenciaanalízis Sûrû adatsorra
clear all; close all; clc;
[numeric, text]=xlsread('BEK4_model.xlsx','Model2');

%% Idõ kiolvasása
% for i = 1:size(numeric,1)
% 	if size(text{i+1,1},2) > 15
% 		T(i) = datenum(text{i+1,1}, 'yyyy.mm.dd. HH:MM');
% 	else
% 		T(i) = datenum(text{i+1,1}, 'yyyy.mm.dd.');
% 	end
% end

%%
Y = numeric(:,1);
X = numeric(:,2:end);
X = [X ones(size(X,1),1)];
max(isnan(X))

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
figure(2)

Ym2 = X*[6.67 -15 -307 -0.682 4036.38]';		%Model2 hez tartozó teta
% Ym2 = X*[-0.00776 0.0365  0.00738  0.672 2.]';  %Model1 hez tartozó teta
plot(Y,Ym2,'.')
set(gca,'FontSize',20)


% corrcoef(Y,Ym)
% figure(3)