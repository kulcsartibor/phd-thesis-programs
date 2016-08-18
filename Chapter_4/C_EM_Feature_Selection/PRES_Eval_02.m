%% Adatok elõzetes kiértékelése
% Kulcsár Tibor
% 2014.02.14.

%%
clear('all'); close('all'); clc;
addpath('.\somtoolbox', '.\kmedoids')
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

X = (X-repmat(max(X),size(X,1),1))./repmat((max(X) - min(X)),size(X,1),1);

Y = (Y - min(Y)) ./ (max(Y) - min(Y));


comps = [YVar XVars];
sD = som_data_struct([Y X],'comp_names', comps);

sM=som_make(sD,'msize',[8 8],'algorithm', 'seq','tracking',0);

% [P, A] = som_order_cplanes(sM, 'simil', 'abs(corr)', 'proj','pca',...
% 						'comp',(2:size(X,2)),...
% 						'show', 'none');

%%
StepGap = 0.1;
Step = 50;
A = som_calc_similarity(sM, 'simil', 'abs(corr)');%,...
% 		'comp',(2:size(X,2)));

N = size(X,2);
[XL,YL,XS,YS,beta] = plsregress([X],Y,N-1);
Yhat = [ones(size(X,1),1) X]*beta;

R = rsquare(Y,Yhat);
disp(['Step: ' num2str(0) '  Vars: ' num2str(size(X,2)) '  R: ' num2str(R(end))])


i = 1;
while(N > 15)
% for i = 1:Step
	
	[~, IDX] = sort(A(1,2:end));
	
	DelI = 1:floor(StepGap*N);
	
	X(:,IDX(DelI)) = [];
	comps(DelI+1) = [];
	N = size(X,2);
	sD = som_data_struct([Y X],'comp_names', comps);

	sM=som_make(sD,'msize',[8 8],'algorithm', 'seq','tracking',0);
	A = som_calc_similarity(sM, 'simil', 'abs(corr)');
	
	
	[XL,YL,XS,YS,beta] = plsregress([X],Y,N-1);
	
	Yhat = [ones(size(X,1),1) X]*beta;

	R = [R rsquare(Y,Yhat)];
	
	disp(['Step: ' num2str(i) '  Vars: ' num2str(N) '  R: ' num2str(R(end))])
		
	
	
	i = i+1;
end

return

%%
	tree = linkage(A,'average');
	figure(3)
	[H,T,outperm] = dendrogram(tree);
	
%%
	NInputs = 500;
	[IDX, energy, c] = kmedoids(P',NInputs);
	
	[XL,YL,XS,YS,beta] = plsregress(X(:,c),Y,NInputs-1);

	Yhat = [ones(size(X,1),1) X(:,c)]*beta;

	disp(rsquare(Y,Yhat))
	
	
	
	
	
	
	
	
	
	
	
	
	


%%


for i=1:size(X,2)
	
	plot(Time,X(:,i),'+','MarkerSize',4)
	title(XVars{i})
	pause
	
	
	
end
