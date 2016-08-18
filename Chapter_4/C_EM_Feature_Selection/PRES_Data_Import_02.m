%% Adat beolvasás
% Kulcsár Tibor
% 2014.02.14.

%%
clear('all'); close('all'); clc;

%%
[NUM, TXT] = xlsread('.\Data\AV2_Data_PR_EMPV.xlsx','PROCES');

%%
ProcData = NUM;
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
ProcVars = TXT(1:4, 5:1003);

%%
[NUM, TXT] = xlsread('.\Data\AV2_Data_PR_EMPV.xlsx','EMS');

EMSData = NUM;
EMSVars = TXT(1:4, 5:137);

%%
[NUM, TXT] = xlsread('.\Data\AV2_Data_PR_EMPV.xlsx','STAT');

StateVals = NUM; clear('NUM');
StateVars = TXT(1:4, 5:6); clear('TXT');

%%
save('.\Data\PI_AV2_Data.mat', 'Time', 'ProcData', 'EMSData', 'ProcVars', 'EMSVars','StateVals','StateVars')
