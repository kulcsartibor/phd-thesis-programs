%% Adat beolvasás
% Kulcsár Tibor
% 2014.02.14.

%%
clear('all'); close('all'); clc;

%%
[NUM, TXT] = xlsread('.\Data\PI_DataHunter_v3_AV2','DATA');

%%
Data = NUM; clear('NUM');
TimeText = TXT(5:end,2:4);
Time = zeros(size(TimeText,1), size(TimeText,2));

%%
for i = 1:size(TimeText,1)
	for j = 1:size(TimeText,2)
		try
			Time(i,j) = datenum(TimeText{i,j}, 'yyyy.mm.dd. HH:MM:SS');
		catch
			try
				Time(i,j) = datenum(TimeText{i,j}, 'yyyy.mm.dd.');
			catch
			end
		end
	end
end

%%
Variables = TXT([1 3 4], 5:999); clear('TXT');

save('.\Data\PI_DataHunter_v3_AV2.mat','Data','Time','Variables')
