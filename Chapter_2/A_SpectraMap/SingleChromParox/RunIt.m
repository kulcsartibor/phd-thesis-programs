%%
% Többszörös futtatás

%%
global pics;
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\TopNIR','.\Breeding')
load('EUBioDB.mat');


for i = 1:1
	disp(['Futtatás: ' num2str(i)]);
	
	pics = i;
	Breeding
end
