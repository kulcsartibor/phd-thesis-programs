%% Elsevire Article Results
% dr. Janos Abonyi
% Tibor Kulcsar
% 2012.04.04

%% Workspace Initializatuion
clear all; close all; clc;
addpath('.\toolbox_trnmap');
addpath('.\PLS');
addpath('.\Functions');

%% Load datas from preused database
load('AV2DB.mat');
load('AV2TPRes.mat');

%% Helper Funtions
Dist= @(d)(repmat(d, 1, length(d)) - repmat(d', length(d'),1)); %oszlopvektorra

%% Filter of spectras
[Unq, UnqFirst, RowId] = unique(Xs, 'rows', 'first');
X = Xs(UnqFirst,:);	% Az egyforma spektrumokból csak azt hagyjuk meg, amelyik elõbb tûnik fel.
Y = Ys(UnqFirst,:);	% Az egyforma spektrumokból csak azt hagyjuk meg, amelyik elõbb tûnik fel.
X(27,:) = [];
Y(27,:) = [];
Xo = X;
Yo = Y;

%% Normalization of Spectras and properties
N = size(X,1);
X = (X-repmat(mean(X,1),N,1))./repmat(std(X,1),N,1);
Y = (Y-repmat(mean(Y,1),N,1))./repmat(std(Y,1),N,1);

%% Defining the propeties that should be estimated
Pindex = [4 12]; % {'D5 [°C]' 'Density [kg/dm3]'}
LPindex = length(Pindex);
clear dum;	clear Xs; clear Ys;		% Remoce the unsued variables

%% Distance in spectral field
DistM = zeros(N);
for i=1:N
	DistM(i,:)=sum(1/195*abs(X-repmat(X(i,:),N,1)),2);
end
NDistM = DistM./max(max(DistM));

%% Open the figura for visualization
vist = PrintTable;
vist.Format = 'tex';
vist.addRow('Method','$M_{t}$','$M_{c}$','Metric Error','Rate of false neighbors (D5°C)', 'Rate of false neighbors (Density)')
reft = PrintTable;
reft.Format = 'tex';
reft.addRow('Regression Method', 'Correlation Coefficent for D5°C', 'Correlation Coefficent for Density')
advt = PrintTable;
advt.Format = 'tex';
advt.addRow('Regression Method', 'Correlation Coefficent for D5°C', 'Correlation Coefficent for Density')
h = figure('Name','Versions for visualization','NumberTitle','off','Color',[1 1 1]);

%% Aggregates
Karo = ((Xo(:,180).*Xo(:,27)./Xo(:,112)./Xo(:,74))-0.103).*7.3+5.8;
Karo = (Karo - min(Karo))./(max(Karo) - min(Karo));
Kiso = ((Xo(:,119)-Xo(:,112)+0.7)./(3.*Xo(:,27)+Xo(:,112))-47.11).*3.43+39.08;
Kiso = (Kiso - min(Kiso))./(max(Kiso) - min(Kiso));

AgrPoint = [Karo Kiso];
clear Karo; clear Kiso;

AgrDist = sqrt(Dist(AgrPoint(:,1)).^2 + Dist(AgrPoint(:,2)).^2);
AgrDist = AgrDist./max(max(AgrDist));
Err = sum(sum(abs(AgrDist - NDistM)));

[Mt,Mc,V,U] = trustcont(5, X, AgrPoint, DistM, L2_distance(AgrPoint',AgrPoint'));
figure(10)
% plot(AgrPoint(:,1),AgrPoint(:,2),'r.');
plot(AgrPoint(:,1),AgrPoint(:,2),'r.','MarkerSize',15);
axis([-0.1 1.1 -0.1 1.1])
% title('Visualization by Aggregates', 'FontSize', 12,'FontWeight','bold')
xlabel('Karo')
ylabel('Kiso')
text(0,-0.2,{ ['Err: ' num2str(Err)]}, 'FontWeight','bold')
vist.addRow('Aggregats', num2str(Mt), num2str(Mc), num2str(Err),...
	num2str(fnn(AgrPoint,Y(:, Pindex(1)))), num2str(fnn(AgrPoint,Y(:, Pindex(2)))));

%% Multi Dimensional Scaling
[positions, error, ev] = mds(DistM, 2);
MDSPoints = positions(1:2,:)';
NormMDSP = [((MDSPoints(:,1) - min(MDSPoints(:,1)))./(max(MDSPoints(:,1)) - min(MDSPoints(:,1))))...
	((MDSPoints(:,2) - min(MDSPoints(:,2)))./(max(MDSPoints(:,2)) - min(MDSPoints(:,2))))];


MdsDist = sqrt(Dist(MDSPoints(:,1)).^2 + Dist(MDSPoints(:,2)).^2);
MdsDist = MdsDist./max(max(MdsDist));
Err = sum(sum(abs(MdsDist - NDistM)));

[Mt,Mc,V,U] = trustcont(5, X, MDSPoints, DistM, L2_distance(MDSPoints',MDSPoints'));
plot(NormMDSP(:,1), NormMDSP(:,2), 'r.','MarkerSize',15);
% plot(MDSPoints(:,1), MDSPoints(:,2), 'r.');
axis([-0.1 1.1 -0.1 1.1])
% title('MDS Compression into 2D', 'FontSize', 12, 'FontWeight','bold')
xlabel('Dim 1')
ylabel('Dim 2')
text(0,-0.2,{['Err: ' num2str(Err)]}, 'FontWeight','bold')
vist.addRow('Multi Dim. Sclaling', num2str(Mt), num2str(Mc), num2str(Err),...
	num2str(fnn(NormMDSP,Y(:, Pindex(1)))), num2str(fnn(NormMDSP,Y(:, Pindex(2)))));

%% PLS 2D (Density)
pmod =  pls2DComp(pls(X,Y(:,Pindex(2)),10));
PLSPoints1 = [pmod.tw1 pmod.tw2];
NormPLS1 = [((PLSPoints1(:,1) - min(PLSPoints1(:,1)))./(max(PLSPoints1(:,1)) - min(PLSPoints1(:,1))))...
	((PLSPoints1(:,2) - min(PLSPoints1(:,2)))./(max(PLSPoints1(:,2)) - min(PLSPoints1(:,2))))];

PLSDist1 = sqrt(Dist(PLSPoints1(:,1)).^2 + Dist(PLSPoints1(:,2)).^2);
PLSDist1 = PLSDist1./max(max(PLSDist1));
Err = sum(sum(abs(PLSDist1 - NDistM)));

[Mt,Mc,V,U] = trustcont(5, X, PLSPoints1, DistM, L2_distance(PLSPoints1',PLSPoints1'));
% figure(12)
plot(NormPLS1(:,1), NormPLS1(:,2), 'r.','MarkerSize',15);
axis([-0.1 1.1 -0.1 1.1])
% title('PLS 2D Visualization (Density)', 'FontSize', 12, 'FontWeight','bold')
xlabel('Dim 1')
ylabel('Dim 2')
text(0,-0.2,{['Err: ' num2str(Err)]}, 'FontWeight','bold')
vist.addRow('2D PLS (Density)', num2str(Mt), num2str(Mc), num2str(Err),...
	num2str(fnn(NormPLS1,Y(:, Pindex(1)))), num2str(fnn(NormPLS1,Y(:, Pindex(2)))));

%% PLS 2D (Density)
pmod =  pls2DComp(pls(X,Y(:,Pindex(1)),10));
PLSPoints2 = [pmod.tw1 pmod.tw2];
NormPLS2 = [((PLSPoints2(:,1) - min(PLSPoints2(:,1)))./(max(PLSPoints2(:,1)) - min(PLSPoints2(:,1))))...
	((PLSPoints2(:,2) - min(PLSPoints2(:,2)))./(max(PLSPoints2(:,2)) - min(PLSPoints2(:,2))))];

PLSDist2 = sqrt(Dist(PLSPoints2(:,1)).^2 + Dist(PLSPoints2(:,2)).^2);
PLSDist2 = PLSDist2./max(max(PLSDist2));
Err = sum(sum(abs(PLSDist2 - NDistM)));

[Mt,Mc,V,U] = trustcont(5, X, PLSPoints2, DistM, L2_distance(PLSPoints2',PLSPoints2'));
% figure(13)
plot(NormPLS2(:,1), NormPLS2(:,2), 'r.','MarkerSize',15);
axis([-0.1 1.1 -0.1 1.1])
% title('PLS 2D Visualization (D5°C)', 'FontSize', 12, 'FontWeight','bold')
xlabel('Dim 1')
ylabel('Dim 2')
text(0,-0.2,{['Err: ' num2str(Err)]}, 'FontWeight','bold')
vist.addRow('2D PLS (D5°C)', num2str(Mt), num2str(Mc), num2str(Err),...
	num2str(fnn(NormPLS2,Y(:, Pindex(1)))),num2str(fnn(NormPLS2,Y(:, Pindex(2)))));

%% PCA Visualization
c = mean(X);
Xp = X - repmat(c, size(X,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
PCAPoints = Xp*p;
NormPCA = [((PCAPoints(:,1) - min(PCAPoints(:,1)))./(max(PCAPoints(:,1)) - min(PCAPoints(:,1))))...
	((PCAPoints(:,2) - min(PCAPoints(:,2)))./(max(PCAPoints(:,2)) - min(PCAPoints(:,2))))];

PCADist = sqrt(Dist(PCAPoints(:,1)).^2 + Dist(PCAPoints(:,2)).^2);
PCADist = PCADist./max(max(PCADist));
Err = sum(sum(abs(PCADist - NDistM)));

[Mt,Mc,V,U] = trustcont(5, X, PCAPoints, DistM, L2_distance(PCAPoints',PCAPoints'));

plot(NormPCA(:, 1), NormPCA(:, 2), 'r.','MarkerSize',15);
axis([-0.1 1.1 -0.1 1.1])
% title('2D PCA compr.', 'FontSize', 12, 'FontWeight','bold')
xlabel('Dim 1')
ylabel('Dim 2')
text(0,-0.2,{['Err: ' num2str(Err)]}, 'FontWeight','bold')
vist.addRow('PCA 2D Reduction', num2str(Mt), num2str(Mc), num2str(Err),...
	num2str(fnn(NormPCA,Y(:, Pindex(1)))), num2str(fnn(NormPCA,Y(:, Pindex(2)))));

%% Regression section
% =============================================================================================
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =============================================================================================

%% KNN Method in Spectral field (original TopNIR methodology)
cr1 = corrcoef(Y(:, Pindex(1)),knn(DistM,Y(:, Pindex(1)),7));
% disp(['k-NN in Spectral for FBP: ' num2str(cr1(2))]);
cr2 = corrcoef(Y(:, Pindex(2)),knn(DistM,Y(:, Pindex(2)),7));
% disp(['k-NN in Spectral for Density: ' num2str(cr2(2))]);
reft.addRow('k-NN (TopNIR)', num2str(cr1(2)), num2str(cr2(2)));

subplot(2,3,6)
% disp(['FNN in Spectral for FBP: ' num2str(1 - fnn(X,Y(:, Pindex(1))))])
hold on
% disp(['FNN in Spectral for Density: ' num2str(1 - fnn(X,Y(:, Pindex(2))))])
title('FNN Relative distance', 'FontSize', 12, 'FontWeight','bold')
xlabel('Sample')
ylabel('Angle [rad]')

%% KNN and FNN in the mapped fields
cr1 = corrcoef(Y(:, Pindex(1)),knn(AgrDist,Y(:, Pindex(1)),7));
% disp(['k-NN in Aggregate field for FBP: ' num2str(cr1(2))])
cr2 = corrcoef(Y(:, Pindex(2)),knn(AgrDist,Y(:, Pindex(2)),7));
% disp(['k-NN in Aggregate field for Density: ' num2str(cr2(2))])
% disp(['FNN in Aggregate field for FBP: ' num2str(1 - fnn(AgrPoint,Y(:, Pindex(1))))])
% disp(['FNN in Aggregate field for Density: ' num2str(1 - fnn(AgrPoint,Y(:, Pindex(2))))])
reft.addRow('k-NN in Aggregate field', num2str(cr1(2)), num2str(cr2(2)));

cr1 = corrcoef(Y(:, Pindex(1)),knn(MdsDist,Y(:, Pindex(1)),7));
% disp(['k-NN in MDS field for FBP: ' num2str(cr1(2))])
cr2 = corrcoef(Y(:, Pindex(2)),knn(MdsDist,Y(:, Pindex(2)),7));
% disp(['k-NN in MDS field for Density: ' num2str(cr2(2))])
% disp(['FNN in MDS field for FBP: ' num2str(1 - fnn(MDSPoints,Y(:, Pindex(1))))])
% disp(['FNN in MDS field for Density: ' num2str(1 - fnn(MDSPoints,Y(:, Pindex(2))))])
reft.addRow('k-NN in MDS field', num2str(cr1(2)), num2str(cr2(2)));

cr1 = corrcoef(Y(:, Pindex(1)),knn(PLSDist1,Y(:, Pindex(1)),7));
% disp(['k-NN in PLS field for FBP: ' num2str(cr1(2))])
cr2 = corrcoef(Y(:, Pindex(2)),knn(PLSDist2,Y(:, Pindex(2)),7));
% disp(['k-NN in PLS field for Density: ' num2str(cr2(2))])
% disp(['FNN in PLS field for FBP: ' num2str(1 - fnn(PLSPoints1,Y(:, Pindex(1))))])
% disp(['FNN in PLS field for Density: ' num2str(1 - fnn(PLSPoints2,Y(:, Pindex(2))))])
reft.addRow('k-NN in PLS field', num2str(cr1(2)), num2str(cr2(2)));

cr1 = corrcoef(Y(:, Pindex(1)),knn(PCADist,Y(:, Pindex(1)),7));
% disp(['k-NN in MDS field for FBP: ' num2str(cr1(2))])
cr2 = corrcoef(Y(:, Pindex(2)),knn(PCADist,Y(:, Pindex(2)),7));
% disp(['k-NN in MDS field for Density: ' num2str(cr2(2))])
% disp(['FNN in MDS field for FBP: ' num2str(1 - fnn(PCAPoints,Y(:, Pindex(1))))])
% disp(['FNN in MDS field for Density: ' num2str(1 - fnn(PCAPoints,Y(:, Pindex(2))))])
reft.addRow('k-NN in PCA field', num2str(cr1(2)), num2str(cr2(2)));

%% Delaunay from all mapped field
DelPoints = [AgrPoint MDSPoints PLSPoints1 PLSPoints2 PCAPoints];
DelDist = zeros([size(DistM),5]);
DelDist(:,:,1) = AgrDist;
DelDist(:,:,2) = MdsDist;
DelDist(:,:,3) = PLSDist1;
DelDist(:,:,4) = PLSDist2;
DelDist(:,:,5) = PCADist;
Methods = {'Agregates'; 'MDS mapping'; 'PLS FBP'; 'PLS Dens'; 'PCA Mapping'};

for j = 1:5
	points = DelPoints(:,(2*j-1:2*j));
	cr(j,1) = delpred(points, Y(:, Pindex(1)), DelDist(:,:,j));	
	cr(j,2) = delpred(points, Y(:, Pindex(1)), DistM);	
	cr(j,3) = delpred(points, Y(:, Pindex(2)), DelDist(:,:,j));	
	cr(j,4) = delpred(points, Y(:, Pindex(2)), DistM);
	
% 	disp([Methods{j} ' BCentric FBP: ' num2str(cr(j,1))]);
% 	disp([Methods{j} ' SpecDist FBP: ' num2str(cr(j,2))]);
% 	disp([Methods{j} ' BCentric Dens: ' num2str(cr(j,3))]);
% 	disp([Methods{j} ' SpecDist Dens: ' num2str(cr(j,4))]);
end

reft.addRow('Aggr. + Delaunay Tri. (Mapped dist.)', num2str(cr(1,1)), num2str(cr(1,3)));
reft.addRow('Aggr. + Delaunay Tri. (Spectral dist.)', num2str(cr(1,2)), num2str(cr(1,4)));
reft.addRow('MDS + Delaunay Tri. (Mapped dist.)', num2str(cr(2,1)), num2str(cr(2,3)));
reft.addRow('MDS + Delaunay Tri. (Spectral dist.)', num2str(cr(2,2)), num2str(cr(2,4)));
reft.addRow('2D PLS + Delaunay Tri. (Mapped dist.)', num2str(cr(3,1)), num2str(cr(4,3)));
reft.addRow('2D PLS + Delaunay Tri. (Spectral dist.)', num2str(cr(3,2)), num2str(cr(4,4)));
reft.addRow('2D PCA + Delaunay Tri. (Mapped dist.)', num2str(cr(5,1)), num2str(cr(5,3)));
reft.addRow('2D PCA + Delaunay Tri. (Spectral dist.)', num2str(cr(5,2)), num2str(cr(5,4)));

%% PLS Prediction from Spectras
Fakt = 10;
avpls = [];
for k = 2:15
	Pm= NcrossPLS(X,Y(:,Pindex(1)),k,Fakt);
	cr1 = corrcoef(Pm.EstY, Y(:,Pindex(1)));
% 	disp(['PLS ' num2str(k) ' variables, spectral field FBP: ' num2str(cr1(2))]);
	Pm= NcrossPLS(X,Y(:,Pindex(2)),k,Fakt);
	cr2 = corrcoef(Pm.EstY, Y(:,Pindex(2)));
% 	disp(['PLS ' num2str(k) ' variables, spectral field Density: ' num2str(cr2(2))]);
	avpls = [avpls; k cr1(2) cr2(2)];
	advt.addRow(['PLS from Spectras (' num2str(k) ' latent var.)'], num2str(cr1(2)), num2str(cr2(2)))
end

save('avpls.mat','avpls');


vist.saveToFile('.\TexTables\visresult.tex');
reft.saveToFile('.\TexTables\regr2D.tex');
advt.saveToFile('.\TexTables\advregr.tex');



vist.display;
reft.display;
advt.display;









