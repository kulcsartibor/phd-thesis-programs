%% Spektrumok beolvasása
% MOL spektrum adatok beolvasása matlabba
% Kulcsár Tibor
% 2012.01.12

%% Példa
clear all;close all; clc;
addpath('.\GSTools','.\GSTools\Additional');

%%
path = 'F:\MOL_Raktar\DSFejlesztes\';
filelist = dir([path '*.spc']);
WaveN = 5995:-5:5000;

%%
N = numel(filelist);
Time = zeros(N,1);
Spectra = zeros(N,numel(WaveN));
BLine = zeros(N,1);
h_importspec = waitbar(0,'Importing spectra ...');
for i = 1:N
	Time(i) = datenum(regexp(filelist(i).name,'\d+_\d+','match'),'mmdd_HHMM');
	specdum = GSSpcRead ([path filelist(i).name], -1, 0);
	Spectra(i,:) = interp1(specdum.xaxis,specdum.data,WaveN);
	BLine(i) = interp1(specdum.xaxis,specdum.data,6000);
	waitbar(i/N, h_importspec);
end
close(h_importspec)

%%
V = var(Spectra,1,2);
Out = union(find(V < 0.22),  find(V > 0.31));
VarSpectra = Spectra;
VarSpectra(Out,:) = [];
Time(Out) = [];
BLine(Out) = [];
BLineSpectra = VarSpectra-repmat(BLine,1,numel(WaveN));
NormSpectra = BLineSpectra./repmat(sum(BLineSpectra,2),1,numel(WaveN));
%%

save('ArrayDat.mat','Time','BLine','NormSpectra','Spectra','WaveN')