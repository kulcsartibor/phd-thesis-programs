clear all

load('ESCAPE.mat')
load('komponensek.mat')

addpath .\somtoolbox

M=4;

Y=Red.y(:,M);
X=Red.x;
data=[Y X];
comps=[komponensek(M) komponensek(5:end)]

%%
sD=som_data_struct(data,'comp_names', comps)
sM=som_make(sD,'msize',[4 4]) % 'lattice','rect',
figure(1)
som_show(sM)
%%
Index=cell(36,1);
for i=1:size(data,1)
    s=data(i,:);
    BMU = som_bmus(sM, s);
	Index{BMU} = [Index{BMU} i]; 	
end

theta=cell(36,1);
for i=1:numel(Index)
	if numel(Index{i})>=15
		theta{i}=data(Index{i},2:end)\data(Index{i},1);
	elseif numel(Index{i})==0
		theta{i}=NaN;
	elseif numel(Index{i})<15
		theta{i}=0;
	end		
end
%%
y_val_mert=Val.y(:,M);
data_val=[y_val_mert Val.x];
for i=1:size(data_val,1)
    s=data_val(i,:);
    BMU_val = som_bmus(sM, s);
    if isnan(theta{BMU_val})==0
		if theta{BMU_val}~=0
			y_val_becs(i,1)=theta{BMU_val}'*Val.x(i,:)';
		else
			yyy=data([Index{BMU_val}]);
			y_val_becs(i,1)=mean(yyy(:,1));
			mean(Index{BMU_val})
		end
    else
        y_val_becs(i,1)=NaN;
    end
end
%%
KM=corrcoef(y_val_becs(isnan(y_val_becs)==0),y_val_mert(isnan(y_val_becs)==0));
KORR.SOM=KM(1,2)













