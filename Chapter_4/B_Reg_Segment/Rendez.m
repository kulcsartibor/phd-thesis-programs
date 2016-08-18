%% Online analizátor adat spektrális analízis
clear all; close all; clc;
[numeric, text]=xlsread('AROMAS_MINOSEG_SZAMITAS_v2_kisebb_mintavetel.xlsx');

%% Idõ kiolvasása
for i = 1:size(numeric,1)
	if size(text{i+2,1},2) > 15
		GyakT(i) = datenum(text{i+2,1}, 'yyyy.mm.dd. HH:MM:SS');
	else
		GyakT(i) = datenum(text{i+2,1}, 'yyyy.mm.dd.');
	end
end

%% Adatsorok kiolvasása
GyakCalc = numeric(:,1);
GyakAlyz = numeric(:,2);

%%
save('GyakMinta.mat', 'GyakT', 'GyakCalc', 'GyakAlyz');

%%
clear all; close all; clc;
[numeric, text]=xlsread('AROMAS_MINOSEG_SZAMITAS.xlsx');

%%
for i = 1:size(numeric,1)
	if size(text{i+2,1},2) > 15
		RitkaT(i) = datenum(text{i+2,1}, 'yyyy.mm.dd. HH:MM:SS');
	else
		RitkaT(i) = datenum(text{i+2,1}, 'yyyy.mm.dd.');
	end
end

%% Adatsorok kiolvasása

RitkaLab = numeric(:,1);
RitkaCalc = numeric(:,2);
RitkaAlyz = numeric(:,3);

%%
save('RitkaMinta.mat', 'RitkaT', 'RitkaLab', 'RitkaCalc', 'RitkaAlyz');

%%
clear all; close all; clc;
[numeric, text]=xlsread('3_102_opdata_szurt.xlsx');

%%
for i = 1:size(numeric,1)
	if size(text{i+3,1},2) > 15
		OptT(i) = datenum(text{i+3,1}, 'yyyy.mm.dd. HH:MM:SS');
	else
		OptT(i) = datenum(text{i+3,1}, 'yyyy.mm.dd.');
	end
end

IPbenzol = numeric(:,1);
FejTartalom = numeric(:,2);
FejNyomas = numeric(:,3);

save('OptMinta.mat', 'OptT', 'IPbenzol', 'FejTartalom', 'FejNyomas');
clear all;