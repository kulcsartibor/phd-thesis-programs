%% PLS effect prot
%
%
clear all; close all; clc;
%% plot
load('eubpls');
load('avpls');
%%

h = figure('Name','Effects of latent field','NumberTitle','off','Color',[1 1 1]);
hold on
plot(avpls(:,1),avpls(:,2),'rx-','LineWidth',2)
plot(avpls(:,1),avpls(:,3),'gx-','LineWidth',2)
plot(eubpls(:,1),eubpls(:,2),'bx-','LineWidth',2)
plot(eubpls(:,1),eubpls(:,3),'kx-','LineWidth',2)
title('Correlation coefficient of PLS Regression', 'FontSize', 12,'FontWeight','bold')
xlabel('Number of dimensions in latent field')
ylabel('Correlation coefficient');
hleg1 = legend('AV (D5°C)','AV (Density)','EuB (CFPP0)','EuB (Density)');

title('')
set(hleg1,'Location','SouthEast')
return
%% EUBio plot
Wn = linspace(4800, 4000, 195);
h = figure('Name','Eubio Spectra','NumberTitle','off','Color',[1 1 1]);
cp = subplot(1,1,1);
plot(Wn,Xs)

axis([4000 4800 0 0.016])
set(gca,'xdir','rev')
xlabel('Wavenumber cm^{-1}')
ylabel('Absorbance')
% rotateticklabel(cp, 45)
