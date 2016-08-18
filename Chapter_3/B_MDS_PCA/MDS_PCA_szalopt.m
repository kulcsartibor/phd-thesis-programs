
%% Aggregátok kiértékelése
% Kulcsár Tibor
% 2012.11.25.

%%
clear('all'); close('all'); clc;
addpath('toolbox_trnmap')
load('Fiber.mat');

% Agr.Name = {'Rsat' 'Karo' 'Kiso' 'Kene' 'Nola' 'Nolef' 'Naro' 'Kox' 'Parox' 'Karo3' 'Kcy' 'Ksatu' 'KeroH' 'AKaro'};

%%
Xe = Fiber.NormSp;
DistE = L2_distance(Xe',Xe');

%%
figure('Color',[1 1 1])
[EUmds] = mdscale(DistE,2,'start','random','criterion','strain');
plot(EUmds(:,1),EUmds(:,2),'b.');


%%
figure('Color',[1 1 1])
X = Xe;
c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
EUpca = Xp*p;

plot(EUpca(:,1),EUpca(:,2),'b.');

[Mt,Mc,V,U] = trustcont(5, Xe, EUpca, DistE, L2_distance(EUpca',EUpca'));

[Mt,Mc]























