	%% Topnir reptroduki� tesztel�se
% 2012.08.29
% Kulcs�r Tibor

%% Munkater�let el�k�sz�t�se
clear('all'); close('all'); clc;
addpath('.\DataSet','.\GPOLS','.\toolbox_trnmap','.\TopNIR')
load('EUBioDB.mat');

%% Param�terek bet�lt�se
DistM = L2_distance(Xs',Xs'); %  
param.Dmax = max(max(DistM));			% MAxim�lis t�vols�g a spektr�lis t�rben (Eukl�deszi)
param.RSphere = 25;							% A keres�si t�r m�rete - a Dmax valah�ny %-�ban megadva
param.Nnb = 5;								% A bevont szomsz�dok maxim�lis sz�ma

%%
Ys = Ys(:,[1:6 18:21 30:32 40]);

%% Topnir emul�tor megh�v�sa 
result = topnir(Ys, param, DistM);


%%
clc
str = ['((X(:,79))-(((X(:,161))*(X(:,161)))/((X(:,172))+(X(:,146)))))'...
	'+(((X(:,172))+(X(:,171)))-((X(:,136))/((X(:,79))+(X(:,171)))))'];
disp(str)
[matchstart,matchend,tokenindices,matchstring,tokenstring,tokenname,splitstring] = regexp(str,'X\(:,\d+\)', 'match')

%%
clc
str = ['((X(:,79))-(((X(:,161))*(X(:,161)))/((X(:,172))+(X(:,146)))))'...
	'+(((X(:,172))+(X(:,171)))-((X(:,136))/((X(:,79))+(X(:,171)))))'];
disp(str)
[repstr,matchstart,matchend] = regexp(str,'\)[\+\-]\(', 'match');
i = -1;
while(~isempty(repstr))
	i = i+2;
	str = strcat(str(1:matchstart(1)),'*C(', num2str(i),')',str(matchstart(1)+1),...
		'C(', num2str(i+1), ')*', str(matchend(1):end));
	[repstr,matchstart,matchend] = regexp(str,'\)[\+\-]\(', 'match');
end
disp(str)

%%















