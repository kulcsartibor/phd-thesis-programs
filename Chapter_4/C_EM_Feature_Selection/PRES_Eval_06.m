%% Adatok elõzetes kiértékelése
% Kulcsár Tibor
% 2014.02.14.

%%
clear('all'); close('all'); clc;
addpath('.\somtoolbox', '.\kmedoids','.\OLS')
load('.\Data\EMS_Filtered_Data.mat')

%%
EMVars = 38;
XVars = Raw.ProcTags(1,:);
YVars = Raw.EMSTags(1,:);

%%
i = EMVars;
NNIndex = find(sum(~isfinite([Raw.EMSData(:,i) Raw.ProcData]), 2) == 0);

X = Raw.ProcData(NNIndex,:);
Y = Raw.EMSData(NNIndex,i);

YVar = YVars(i);
Time = Raw.Time(NNIndex,3);


NNIndex = find(max(X) == min(X));

X(:,NNIndex) = [];
XVars(NNIndex) = [];

X = (X-repmat(min(X),size(X,1),1))./repmat((max(X) - min(X)),size(X,1),1);

Y = (Y - min(Y)) ./ (max(Y) - min(Y));
%%
St = std(X);

DelI = find(St < 0.05);

X(:,DelI) = [];
XVars(DelI) = [];

X = [ones(size(X,1),1) X];

%%
combos = combntns(1:size(X,2),5);







return