%%

%%
clear all; close all; clc;
load('Ordered.mat')
% load('Baseline.mat')

%% Hull�msz�mokn�l vett abszorpci�s v�ltoz�konys�g
% 30 hull�msz�mn�l egyenl�en a��losztva

N = size(X,1);
h = figure('Name','Hull�msz�mok abszorpci�s �rt�kei','NumberTitle','off');
for i = 1:30
	subplot(5,6,i)
	plot(1:N , X(:, (200 + i*100)))
	title(['H.Sz�m: ' num2str(WaveN(200 + i*100))])
end

%%
g = figure('Name','Jellemz� spektrumok ','NumberTitle','off');

for i = 1:30
	subplot(5,6,i)
	plot(WaveN, X(i*545,:))
	title([Name{i*545}])
	axis([min(WaveN) max(WaveN) -0.75 2.5])
end

%%
j = figure('Name','�tlag Absorpci�s �rt�k ','NumberTitle','off');

subplot(2,2,1)
plot(DTime, mean(X,2))
title('�tlag Abszorpci� Id�f�ggv�ny')
xlabel('Id� [*2s]')
ylabel('Abszorpci�')

subplot(2,2,3)
plot(DTime, std(X,0,2))
title('Abszorpci� sz�r�s')
xlabel('Id� [*2s]')
ylabel('Abszorpci�')

subplot(2,2,2)
plot(WaveN, mean(X,1))
title('Hull�msz�mn�l vett �tlagos abszorpci�')
xlabel('Hull�msz�m 1/{cm}')
ylabel('Abszorpci�')

subplot(2,2,4)
plot(WaveN, std(X,0,1))
title('Hull�msz�mn�l vett abszorpci� sz�r�s')
xlabel('Hull�msz�m 1/{cm}')
ylabel('Abszorpci�')


%%
Xx = zeros(size(X,1),size(X,2));
for i = 1:size(X,1)
	Xx(i,:) = (X(i,:) - min(X(i,:)))./(max(X(i,:))-min(X(i,:)));	
end


