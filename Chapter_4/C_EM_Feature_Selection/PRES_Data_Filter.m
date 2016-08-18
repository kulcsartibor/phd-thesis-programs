%% Adat beolvasás
% Kulcsár Tibor
% 2014.02.14.

%%
clear('all'); close('all'); clc;
load('.\Data\PI_AV2_Data.mat')

%%
Raw.EMSTags = cell(4,size(EMSVars,2));
for i = 1:size(EMSVars,2)
	tokens = regexp(EMSVars{1,i},'(\w*)','tokens');
	Raw.EMSTags{1,i} = tokens{1}{1};
	Raw.EMSTags{2,i} = tokens{2}{1};
	Raw.EMSTags(3:4,i) = EMSVars(3:4,i);
end

%%
Raw.ProcTags = cell(4, size(ProcVars,2));
for i = 1:size(ProcVars,2)
	tokens = regexp(ProcVars{1,i},'(\w*)','tokens');
	Raw.ProcTags{1,i} = tokens{1}{1};
	if(numel(tokens) == 2)
		Raw.ProcTags{2,i} = tokens{2}{1}(1:2);
	else
		Raw.ProcTags{2,i} = 'PV';
	end

	Raw.ProcTags(3:4,i) = ProcVars(3:4,i);
end

%%
Index    = find(ismember(Raw.ProcTags(2,:), 'PV'));
Raw.ProcTags = Raw.ProcTags(:,Index);
Raw.ProcData = ProcData(:,Index);

Index = find(sum(isnan(Raw.ProcData)) > 1000);
Raw.ProcTags(:,Index) = [];
Raw.ProcData(:,Index) = [];

%%
Index   = find(ismember(Raw.EMSTags(2,:), 'PV'));
Raw.EMSTags  = Raw.EMSTags(:,Index);
Raw.EMSData = EMSData(:,Index);

Index = find(sum(isnan(Raw.EMSData)) > 1000);
Raw.EMSTags(:,Index) = [];
Raw.EMSData(:,Index) = [];

%%
Raw.StateVal = StateVals;

%%
Raw.Time = Time;
%%
save('.\Data\EMS_Filtered_Data.mat','Raw')