%% Adat beolvasás
% Kulcsár Tibor
% 2014.02.14.

%%
clear('all'); close('all'); clc;
load('DataTags.mat')
%%
[NUM, TXT] = xlsread('.\Data\ModelEq.xlsx');

%%
Tags = [];
for i = 1:size(TXT,1)
	t = regexp(TXT{i},'[\w\.]{6,}','match');
	Tags = [Tags; t'];
end

Tags = unique(Tags);

%%
Index = [];
for i = 1:numel(Tags)
	str = Tags{i};
	if(~isnan(str2double(str(1))))
		Index = [Index i];
	end
end
Tags(Index) = [];

%%
for i = 1:numel(Tags)
	ModelTags{i} = regexprep(Tags{i},'\.\w*','');
	ModelTags{i} = strrep(ModelTags{i},'_','');
end

%%
for i = 1:numel(DataTags)
	DataTags{i} = regexprep(DataTags{i},'\.\w*','');
	DataTags{i} = strrep(DataTags{i},'_','');
end
DataTags = unique(DataTags);
%%
MtIndex = zeros(1,numel(ModelTags));
for i = 1:size(ModelTags,2)
	for j = 1:numel(DataTags)
		STag = ModelTags{i};
		if(isnan(str2double(STag(end))))
			mt = regexp(DataTags{j},STag(1:end-1),'match');
		else
			mt = regexp(DataTags{j},STag,'match');
		end
		
		if(numel(mt) > 0)
			MtIndex(i) = 1;
		end
	end
end
