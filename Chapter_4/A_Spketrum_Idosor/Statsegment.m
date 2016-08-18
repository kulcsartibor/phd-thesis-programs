%% Variancia alpú szegmentáció
% 2012.08.22
% kulcsár tibor
%%
clear all; close all; clc;
load('ArrayDat.mat');

%%
X(:,3700:end) = [];
WaveN(3700:end) = [];
X = X-repmat(mean(X(:,1:1500),2),1,size(X,2));

%%
V = var(X,1,2);
Out = union(find(V < 0.11),  find(V > 0.13));

X(Out, :) = [];
DTime(Out) = [];
V(Out) = [];

%%
stnum = 10;
Sigma = std(X(1:stnum, :),[],1);
Mu = mean(X(1:stnum,:),1);
Prob = 1 - 0.8;


Det = zeros(1,size(X,2));
for i=stnum+1:stnum+1 %size(X,1)
	for j=1:size(X,2)
		lim = norminv([(0.5-Prob/2) (0.5+Prob/2)],Mu(j),Sigma(j));
		if((lim(1) < X(i,j)) && (X(i,j) < lim(2)))
			Det(j) = 1;
		else
			Det(j) = 0;
		end
% 		[lim(1) X(i,j) lim(2) Det(j)]
% 		pause
	end
	disp(sum(Det))
% 	pause
end