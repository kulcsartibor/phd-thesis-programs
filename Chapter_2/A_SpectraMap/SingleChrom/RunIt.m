%%
% T�bbsz�r�s futtat�s

%%
global pics;
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\TopNIR','.\Breeding')
load('EUBioDB.mat');


for i = 1:1
	disp(['Futtat�s: ' num2str(i)]);
	
	pics = i;
	Breeding
end
