%% Frekvenciaanalízis Sûrû adatsorra
clear all; close all; clc;
load('Gyakminta');

%%
X = [GyakAlyz GyakCalc];
Fs = 1/300;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = size(X,1);                     % Length of signal
t = (0:L-1)*T;                % Time vector

figure('Name','FFT','NumberTitle','off', 'Color',[1 1 1]);
NFFT = 2^nextpow2(L);
Sp = fft(X(:,1),NFFT)/L;
f = Fs*linspace(0,1,NFFT/4+1);
pt = (f.^-1)./60;
subplot(2,1,1)
semilogx(pt,2*abs(Sp(1:NFFT/4+1)))
title('Pozitive side Amplitude Spectrum (APC)','FontSize',12)
xlabel('Time Period (min)')
ylabel('|Y(f)|')
axis([11 7e4 0 20])
set(gca,'xdir','rev')

Sp = fft(X(:,2),NFFT)/L;
subplot(2,1,2);
semilogx(pt,2*abs(Sp(1:NFFT/4+1)))
title('Pozitive side Amplitude Spectrum (Analyzer)','FontSize',12)
xlabel('Time Period (min)')
ylabel('|Y(f)|')
axis([11 7e4 0 20])
set(gca,'xdir','rev')

%%

%% Frekvenciaanalízis Sûrû adatsorra
clear all; clc;
load('OptMinta');

X = [IPbenzol FejTartalom FejNyomas];
Fs = 1/900;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = size(X,1);                     % Length of signal
t = (0:L-1)*T;                % Time vector

figure('Name','FFT','NumberTitle','off', 'Color',[1 1 1]);
NFFT = 2^nextpow2(L);
Sp = fft(X(:,1),NFFT)/L;
f = Fs*linspace(0,1,NFFT/2+1);
pt = (f.^-1)./60;
subplot(3,1,1)
semilogx(pt,2*abs(Sp(1:NFFT/2+1)))
title('Pozitive side Amplitude Spectrum (IP benzol)','FontSize',12)
xlabel('Time Period (min)')
ylabel('|Y(f)|')
axis([0 7e4 0 0.04])
set(gca,'xdir','rev')

Sp = fft(X(:,2),NFFT)/L;
subplot(3,1,2);
semilogx(pt,2*abs(Sp(1:NFFT/2+1)))
title('Pozitive side Amplitude Spectrum (Head Temperature)','FontSize',12)
xlabel('Time Period (min)')
ylabel('|Y(f)|')
axis([0 7e4 0 1])
set(gca,'xdir','rev')

Sp = fft(X(:,3),NFFT)/L;
subplot(3,1,3);
semilogx(pt,2*abs(Sp(1:NFFT/2+1)))
title('Pozitive side Amplitude Spectrum (Head Pressure)','FontSize',12)
xlabel('Time Period (min)')
ylabel('|Y(f)|')
axis([0 7e4 0 0.0015])
set(gca,'xdir','rev')






