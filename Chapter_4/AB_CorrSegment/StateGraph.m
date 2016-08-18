%%

%%
clear all; close all; clc;
load('Ordered.mat')
% load('Baseline.mat')

%% Hullámszámoknál vett abszorpciós változékonyság
% 30 hullámszámnál egyenlõen aéólosztva

N = size(X,1);
h = figure('Name','Hullámszámok abszorpciós értékei','NumberTitle','off');
for i = 1:30
	subplot(5,6,i)
	plot(1:N , X(:, (200 + i*100)))
	title(['H.Szám: ' num2str(WaveN(200 + i*100))])
end

%%
g = figure('Name','Jellemzõ spektrumok ','NumberTitle','off');

for i = 1:30
	subplot(5,6,i)
	plot(WaveN, X(i*545,:))
	title([Name{i*545}])
	axis([min(WaveN) max(WaveN) -0.75 2.5])
end

%%
j = figure('Name','Átlag Absorpciós érték ','NumberTitle','off');

subplot(2,2,1)
plot(DTime, mean(X,2))
title('Átlag Abszorpció Idõfüggvény')
xlabel('Idõ [*2s]')
ylabel('Abszorpció')

subplot(2,2,3)
plot(DTime, std(X,0,2))
title('Abszorpció szórás')
xlabel('Idõ [*2s]')
ylabel('Abszorpció')

subplot(2,2,2)
plot(WaveN, mean(X,1))
title('Hullámszámnál vett átlagos abszorpció')
xlabel('Hullámszám 1/{cm}')
ylabel('Abszorpció')

subplot(2,2,4)
plot(WaveN, std(X,0,1))
title('Hullámszámnál vett abszorpció szórás')
xlabel('Hullámszám 1/{cm}')
ylabel('Abszorpció')


%%
Xx = zeros(size(X,1),size(X,2));
for i = 1:size(X,1)
	Xx(i,:) = (X(i,:) - min(X(i,:)))./(max(X(i,:))-min(X(i,:)));	
end


