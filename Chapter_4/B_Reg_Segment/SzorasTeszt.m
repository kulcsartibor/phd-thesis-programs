%% Frekvenciaanalízis Sûrû adatsorra
clear all; close all; clc;
load('GyakMinta.mat')

%%
N = 2;
R = GyakAlyz - GyakCalc;
Rst = std(R(end-N*228:end));
Rm = mean(R(end-N*228:end));


%%
Findex = union(find(R > (Rm + 10*Rst)), find(R < (Rm - 10*Rst)));
R(Findex) = [];
GyakT(Findex) = [];

%% Elõszûrés
fiw = window(@gausswin,20);
fiw = fiw/sum(fiw);
figure('Name','Szûrés','NumberTitle','off', 'Color',[1 1 1]);
ca = subplot(1,1,1)
hold on
plot(GyakT(end-N*228:end), R(end-N*228:end),'r.','MarkerSize', 12)
filt1 = filtfilt(fiw,1,R);
plot(GyakT(end-N*228:end),filt1(end-N*228:end),'k', 'LineWidth',2)

Fst = std(filt1(end-N*228:end));
An = 1-(Fst^2/Rst^2)

%%
T = GyakT(end-N*228:end);
xData = linspace(T(1),T(end),12);

set(gca,'XTick',xData);
datetick('x','HH:MM','keepticks');
rotateticklabel(ca,45);
% xlabel('Time')
axis([T(1) T(end) -60 20])
% set(gca,'FontSize',12)
% title('MAPD koncentráció')
% xlabel('Diszkrét idõ [n]')
% ylabel('MOL %')
