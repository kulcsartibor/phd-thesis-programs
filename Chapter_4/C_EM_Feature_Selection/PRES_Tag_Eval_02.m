%% Adat beolvasás
% Kulcsár Tibor
% 2014.02.14.

%%
clear('all'); close('all'); clc;
load('ModelTags.mat')

%%
for i = 1:size(ModelTags,2)
	ModelTags{1,i} = strrep(ModelTags{1,i},'_','');
end
for i = 1:size(DataTags,2)
	DataTags{1,i} = strrep(DataTags{i},'_','');
end
%%
for i = 1:size(ModelTags,2)
	for j = 1:numel(DataTags)
		mt = regexp(DataTags{j},ModelTags{1,i},'match');
		if(numel(mt) > 0)
			ModelTags{2,i} = 1;
		else
			ModelTags{2,i} = 0;
		end
	end
end

%%
% for j = 1:numel(DataTags)
% 	mt = regexp(DataTags{j},'FN1308','match');
% 	if(numel(mt) > 0)
% 		
% 		{mt{1} DataTags{j}}
% % 		ModelTags{2,i} = 1;
% 	else
% % 		ModelTags{2,i} = 0;
% 	end
% end