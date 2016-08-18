%% Frekvenciaanalízis Sûrû adatsorra
clear all; close all; clc;
load('RitkaMinta')

%%
kezd = length(RitkaLab)-100;
veg = length(RitkaLab);

%I = RitkaLab-RitkaAlyz;
I = RitkaLab-RitkaCalc;
I = I(kezd:veg);
T = RitkaT(kezd:veg);
xData = linspace(RitkaT(kezd),RitkaT(veg),12);
%%
Im = mean(I);
MRm = mean(abs(diff(I)));

UCL = Im+2.66*MRm;
LCL = Im-2.66*MRm;

figure('Name','FFT','NumberTitle','off', 'Color',[1 1 1]);
ca = subplot (2,1,1);

plot(T, I,'b*');
line([T(1) T(end)], [UCL UCL],'Color',[1 0 0])
line([T(1) T(end)], [LCL LCL],'Color',[1 0 0])
line([T(1) T(end)], [Im Im],'Color',[0 1 0],'LineStyle', '--')

axis([T(1) T(end) -40 40])


set(gca,'XTick',xData);
datetick('x','yy/mm/dd','keepticks');
rotateticklabel(ca,45);
title('I Chart','FontSize',12);
xlabel('Time')
ylabel('\Delta')



%%
MR = [abs(diff(I)); 0] ;

ca = subplot (2,1,2);
plot(T, MR,'b*');
set(gca,'XTick',xData);
datetick('x','yy/mm/dd','keepticks');
rotateticklabel(ca,45);
title('MR Chart','FontSize',12);

xlabel('Time')
ylabel('\Delta')

line([T(1) T(end)], [3.27*MRm 3.27*MRm],'Color',[1 0 0])
%%
figure('Name','QQ plot','NumberTitle','off', 'Color',[1 1 1]);
qqplot(I)

%%

Qk = [	0.941	0.970	0.994;
		0.765	0.829	0.926;
		0.642	0.710	0.821;
		0.560	0.625	0.740;
		0.507	0.568	0.680;
		0.468	0.526	0.634;
		0.437	0.493	0.598;
		0.412	0.466	0.568];

f(3) = figure('Name','Különbség F és Dixon','NumberTitle','off','Color', [1 1 1]);
V1 = 5;
V2 = 10;

% ca = subplot(2,1,1);
% plot(T,I)
% hold on
% ot = Fprobecon(I, std(I)/3, V1, V2);
% plot(T(ot),I(ot),'r.')
% title('F-probe on difference', 'FontSize', 14)
% set(gca,'XTick',xData);
% datetick('x','yy.mm.dd HH:MM','keepticks');
% axis([T(1) T(end) -30 30])
% xlabel('Time')
% ylabel('Property value')


Dix = 1;
Sam = 10;
ca = subplot(1,1,1);
plot(T,I)
hold on
ot = Dixon(I,Sam,Dix);
plot(T(ot),I(ot),'rd');
title('Dixon`s test on difference', 'FontSize', 14)
set(gca,'XTick',xData);
datetick('x','yy/mm/dd','keepticks');
axis([T(1) T(end) -30 30])
xlabel('Time')
ylabel('\Delta')
rotateticklabel(ca ,45);


%%

% sI = std(I);
% n = length(I);
% 
% t = sqrt(n)*Im/sI;

[H,P,CI,STATS] = ttest(I,0)

%[H,P,CI,STATS] = ttest(randn(100,1),5)

%%
figure(45)
plot(T,RitkaLab(kezd:veg))
hold on 
plot(T,RitkaAlyz(kezd:veg),'k')
plot(T,RitkaCalc(kezd:veg),'r')

set(gca,'XTick',xData);
datetick('x','yy/mm/dd','keepticks');
rotateticklabel(ca,45);
xlabel('Time')
ylabel('Property value')












