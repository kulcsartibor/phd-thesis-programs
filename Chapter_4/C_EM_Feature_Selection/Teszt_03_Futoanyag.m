%% Adatok elõzetes kiértékelése
% Kulcsár Tibor
% 2014.02.14.

%%
clear('all'); close('all'); clc;
addpath('.\somtoolbox', '.\kmedoids','.\OLS','.\RF_Reg_C')
load('.\Data\EMS_Filtered_Data.mat')

%%
EMVars = 39; % 41
XVars = Raw.ProcTags([1 3 4],:);
YVars = Raw.EMSTags([1 3 4],:);

%%
i = EMVars;
NNIndex = find(sum(~isfinite([Raw.EMSData(:,i) Raw.ProcData]), 2) == 0);

NNIndex = intersect(NNIndex,find(Raw.StateVal(:,1)==8));

X = Raw.ProcData(NNIndex,:);
Y = Raw.EMSData(NNIndex,i);
State = Raw.StateVal(NNIndex,:);

YVar = YVars(:,i);
Time = Raw.Time(NNIndex,3);


NNIndex = find(max(X) == min(X));

X(:,NNIndex) = [];
XVars(:,NNIndex) = [];

X = (X-repmat(min(X),size(X,1),1))./repmat((max(X) - min(X)),size(X,1),1);

Y = (Y - min(Y)) ./ (max(Y) - min(Y));

%%
St = std(X);

DelI = find(St < 0.05);

X(:,DelI) = [];
XVars(:,DelI) = [];

%%
DelI = [];
DelI = union(DelI,find(ismember(XVars(3,:),'KOZP-KIT.')));
DelI = union(DelI,find(ismember(XVars(3,:),'CO magas hatarertek')));
DelI = union(DelI,find(ismember(XVars(3,:),'SO2 magas hatarertek')));
DelI = union(DelI,find(ismember(XVars(3,:),'fûtõgáz felhasználás')));
DelI = union(DelI,find(ismember(XVars(3,:),'Fûtõolaj felhasználás')));
DelI = union(DelI,find(ismember(XVars(3,:),'124 BE FUTOGAZ')));
DelI = union(DelI,find(ismember(XVars(3,:),'124 GAZ BE FUTGAZ')));
DelI = union(DelI,find(ismember(XVars(3,:),'Por magas hatarertek')));
DelI = union(DelI,find(ismember(XVars(3,:),'124 FG-GER BELEPO FUTOGA')));
DelI = union(DelI,find(ismember(XVars(3,:),'Nox magas hatarertek')));
X(:,DelI) = []; 
XVars(:,DelI) = [];

%%
%%
X1 = X(1:2:end-2,:);
X2 = X(2:2:end-1,:);
Y1 = Y(1:2:end-2);
Y2 = Y(2:2:end-1);

% extra_options.proximity  = 1;
extra_options.do_trace   = 1;
extra_options.importance = 1;

model = regRF_train(X1,Y1,500,5,extra_options);
Y_hat = regRF_predict(X2,model);

%%
disp(rsquare(Y2,Y_hat))

[~, I] = sort(model.importance(:,1),'descend');
XVars(3,I(1:15))'

[~, I] = sort(model.importance(:,2),'descend');
XVars(3,I(1:15))'

%%
figure
subplot(2,1,1)
plot(model.importance(:,1)/max(model.importance(:,1)),'b.')
hold on
plot(model.importance(:,2)/max(model.importance(:,2)),'r.')
set(gca,'YLim',[0 1])

subplot(2,1,2)
plot(sort(model.importance(:,1)/max(model.importance(:,1)),'descend'),'b-')
hold on
plot(sort(model.importance(:,2)/max(model.importance(:,2)),'descend'),'r-')
set(gca,'YLim',[0 1])


return








%%
X1 = X(1:2:end-2,:);
X2 = X(2:2:end-1,:);
Y1 = Y(1:2:end-2);
Y2 = Y(2:2:end-1);

[th,I] = ols(X1,Y1);

%%
figure('Color',[1 1 1])
plot(X(:,I(1:10)));

%%
R1 = [];
R2 = [];
N = [size(X,2) size(X1,1) size(X2,1)];
h = waitbar(0,'Please wait...');
for i = 2:N(1)
	theta = [ones(N(2),1) X1(:,I(1:i))]\Y1;	
	
	Yhat1 = [ones(N(2),1) X1(:,I(1:i))]*theta;
	rr1 = rsquare(Y1,Yhat1);
	R1 = [R1 rr1];
	
	Yhat2 = [ones(N(3),1) X2(:,I(1:i))]*theta;
	rr2 = rsquare(Y2,Yhat2);
	R2 = [R2 rr2];
	if ((rr1 == 0) || (rr2 == 0))
		disp(I(i))
		disp(XVars(3,I(i)))
		return
	end
	waitbar(i/N(1),h)
end
close(h)

%%
figure('Color',[1 1 1])
subplot(2,1,1)
plot(R1)

subplot(2,1,2)
plot(R2)


%%
NVar = 30;
Varlables = cell(1,NVar+1);
Varlables{1} = 'KEI';
for i = 1:NVar
	Varlables{i+1} = ['Comp ' num2str(i)];
end
comps = [YVar(1,1) XVars(1,I(1:NVar))];
% sD = som_data_struct([Y1 X1(:,I(1:35))],'comp_names', comps);
sD = som_data_struct([Y1 X1(:,I(1:NVar))],'comp_names', Varlables);
sM=som_make(sD,'msize',[20 20],'algorithm', 'seq');


%%
h = som_bmus(sM,[nan*Y1 X1(:,I(1:NVar))]);
Ybecs=sM.codebook(h,1);

figure('Color',[1 1 1])
plot(Y1,Ybecs,'.')
rsquare(Y1,Ybecs)

%%
% figure
A = som_calc_similarity(sM, 'simil', 'abs(corr)');
VAT_v2(1-A)
tree = linkage(1-A,'single');
figure('Color',[1 1 1])
[H,T,outperm] = dendrogram(tree);


%%
% som_order_cplanes(sM)
% figure
% % II = I(1:35);
% % II = II(outperm);
% outperm(outperm == 1) = [];
% 
% Xx = [Y1 X1(:,I(1:NVar))];
% sD2 = som_data_struct(Xx(:,outperm))%, 'comp_names',Varlables);
% sM2=som_make(sD2,'msize',[20 20],'algorithm', 'seq');
% som_show(sM2)
% 
% XVars(3,I(1:NVar))'
% disp(['R2: ' num2str(max(R2))])
% disp(['R1: ' num2str(max(R1))])

%%
som_order_cplanes(sM)
figure
% II = I(1:35);
% II = II(outperm);
outperm(outperm == 1) = [];
Ordlables = ['KEI' Varlables(outperm)];
outperm = outperm - 1;

% Xx = [Y1 X1(:,I(1:outperm))];
sD2 = som_data_struct([Y1 X1(:,I(outperm))], 'comp_names',Ordlables);
sM2=som_make(sD2,'msize',[20 20],'algorithm', 'seq');
som_show(sM2)

XVars(3,I(1:NVar))'
disp(['R2: ' num2str(max(R2))])
disp(['R1: ' num2str(max(R1))])


%%
[~,I] = ols(X,Y);
NVar = 10;
Xn = (X(:,I(1:NVar))-repmat(mean(X(:,I(1:NVar))),size(X,1),1))./repmat(std(X(:,I(1:NVar))),size(X,1),1);
Yn = (Y-repmat(mean(Y),size(Y,1),1))./repmat(std(Y),size(Y,1),1);

% F = cov(Xn);
% [U, Sigma, V] = svd(F);
% s=diag(Sigma);
% PC = Xn * U;
PC = pca(Xn','NumComponents',2);
figure
plot(PC(:,1),PC(:,2),'.')


[PC1,T] = rotatefactors(PC, 'Method','orthomax');
figure
plot(PC1(:,1),PC1(:,2),'.')

%%
% [ox, Iy, r_act, A_o, x_o] = olsfun(Xn,Yn,5);

%%
I2=[];
R=[];
Corresp = zeros(NVar,2);
for i=1:2
    [I,E] = olsort(Xn,PC1(:,i),NVar);

	[I, index] = sort(I);
	Corresp(:,i) = E(index);		
end

plot(Corresp(:,1),Corresp(:,2),'.')























