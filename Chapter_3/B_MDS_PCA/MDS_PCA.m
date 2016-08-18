
%% Aggregátok kiértékelése
% Kulcsár Tibor
% 2012.11.25.

%%
clear('all'); close('all'); clc;
load('EU2005Bio.mat');
load('Meodat.mat');
load('OnLine.mat');
addpath('toolbox_trnmap')
% Agr.Name = {'Rsat' 'Karo' 'Kiso' 'Kene' 'Nola' 'Nolef' 'Naro' 'Kox' 'Parox' 'Karo3' 'Kcy' 'Ksatu' 'KeroH' 'AKaro'};

%% Egyforma spektrumok kikeresése
[Unq, UnqFirst, RowId] = unique(Xs, 'rows', 'first'); % Az egyforma spektrumokból csak azt hagyjuk meg, amelyik elõbb tûnik fel.
Xe = Xs(UnqFirst,:);
Ye = Ys(UnqFirst,:);
Xe(102,:) = [];
Ye(102,:) = [];
Samples(102) = [];

%%
MeoCTi = intersect(find(Meo.Time>=min(OnL.Time)), find(Meo.Time<=max(OnL.Time)));
MeoCTi = intersect(Meo.Pr.Prod(5).Idx, MeoCTi); %CSAK 56 db termekminta van$ ami osszerendelhetõ!!!!

ComT = [];
for i= MeoCTi 
        dTime = OnL.Time - Meo.Time(i);
        [sdTime I] = sort(abs(dTime));
        ComT =[ComT ;[ i  I(1)]];
end
Xo = fliplr(OnL.NSpec(ComT(:,2),:));
Xm = fliplr(Meo.NSpec(ComT(:,1),:));

DistE = L2_distance(Xe',Xe');
DistO = L2_distance([Xe; Xo]',[Xe; Xo]');
DistM = L2_distance([Xe; Xo; Xm]',[Xe; Xo; Xm]');



%%
figure('Color',[1 1 1])
[EUmds] = mdscale(DistE,2,'start','random','criterion','sammon');
plot(EUmds(:,1),EUmds(:,2),'b.');

%%
figure('Color',[1 1 1])
hold on;
[OLmds] = mdscale(DistO,2,'start','random','criterion','strain');
plot(OLmds(1:size(Xe,1),1),OLmds(1:size(Xe,1),2),'b.')
plot(OLmds(size(Xe,1)+1:end,1),OLmds(size(Xe,1)+1:end,2),'r.')

%%
figure('Color',[1 1 1])
hold on;
[MEmds] = mdscale(DistM,2,'start','random','criterion','strain');
% [MEmds] = mdscale(DistM,2,'start','random','criterion','metricstress');
plot(MEmds(1:size(Xe,1),1),MEmds(1:size(Xe,1),2),'g.')
plot(MEmds(size(Xe,1)+1:size(Xe,1)+size(Xo,1),1),MEmds(size(Xe,1)+1:size(Xe,1)+size(Xo,1),2),'bd')
plot(MEmds(size(Xe,1)+size(Xo,1)+1:end,1),MEmds(size(Xe,1)+size(Xo,1)+1:end,2),'rv')

%%
figure('Color',[1 1 1])
hold on;
Psm = sammon(MEmds,2,[],[],[],DistM);
plot(Psm(1:size(Xe,1),1),Psm(1:size(Xe,1),2),'g.')
plot(Psm(size(Xe,1)+1:size(Xe,1)+size(Xo,1),1),Psm(size(Xe,1)+1:size(Xe,1)+size(Xo,1),2),'bd')
plot(Psm(size(Xe,1)+size(Xo,1)+1:end,1),Psm(size(Xe,1)+size(Xo,1)+1:end,2),'rv')

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

%%
figure('Color',[1 1 1])
hold on
X = [Xe; Xo];
c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
OLpca = Xp*p;

plot(OLpca(1:size(Xe,1),1),OLpca(1:size(Xe,1),2),'b.')
plot(OLpca(size(Xe,1)+1:end,1),OLpca(size(Xe,1)+1:end,2),'r.')

%%
figure('Color',[1 1 1])
hold on
X = [Xe; Xo; Xm];
c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
MEpca = Xp*p;

plot(MEpca(1:size(Xe,1),1),MEpca(1:size(Xe,1),2),'g.')
plot(MEpca(size(Xe,1)+1:size(Xe,1)+size(Xo,1),1),MEpca(size(Xe,1)+1:size(Xe,1)+size(Xo,1),2),'bd')
plot(MEpca(size(Xe,1)+size(Xo,1)+1:end,1),MEpca(size(Xe,1)+size(Xo,1)+1:end,2),'rv')

























