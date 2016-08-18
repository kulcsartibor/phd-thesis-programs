%% VAriancia analízis, szar elemek kidobása

%%
addpath('./PCAsegbu');
%%
clear all; close all; clc;
% load('Ordered.mat');
load('ArrayDat.mat');

%%
X(:,3700:end) = [];
WaveN(3700:end) = [];
X = X-repmat(mean(X(:,1:1500),2),1,size(X,2));

%%
V = var(X,1,2);
Out = union(find(V < 0.11),  find(V > 0.13));

X(Out, :) = [];
% DTime(Out) = [];
V(Out) = [];

% Out = union(find(WaveN > 9000), find(WaveN < 5000));  %%find(std(X) < 1e-3)
% WaveN(Out) = [];
% X(:,Out) = [];

%%
X = X(:,1:5:end);
WaveN = WaveN(1:5:end);

%%
f = figure(1);
%%
jF = get(handle(gcf),'JavaFrame');
jF.setMaximized(true)

%%
h = waitbar(0,'kérlek várj...');
lep = 50;
FNum = (size(X,1)-size(X,2))/lep;
rcr = zeros(size(X,2));
Mn = [];
Vo = [];
for i = 0:FNum-1
	ncr = corrcoef(X(i*lep+1:i*lep+size(X,2),:));
	subplot(1,2,1)
	surf(1:size(X,2),1:size(X,2),ncr,'EdgeColor','none')
	view(2);
	axis([1 size(X,2) 1 size(X,2)]);
% 	F(i) = getframe(gcf);
	waitbar(i/FNum,h);
	
	Mn = [Mn sum(sum(abs(rcr - ncr)))];

	Vo = [Vo V(i*lep + floor(lep/2))];
% 	surf(1:size(X,2),1:size(X,2),rcr - ncr,'EdgeColor','none')
% 	view(2);
% 	axis([1 size(X,2) 1 size(X,2)]);
	rcr = ncr;

end
close(h)
subplot(1,2,2)
Mn = Mn - min(Mn);
Mn = Mn./max(max(Mn));
Vo = Vo - min(Vo);
Vo = Vo./max(Vo);
plot(Mn)
hold on
plot(Vo,'r')

%%



%%
movie(F,1)

% %%
% Z = peaks;
% figure('Renderer','zbuffer');
% 
% surf(Z);
% axis tight;
% set(gca,'NextPlot','replaceChildren');
% for j = 1:1
%     surf(sin(2*pi*j/20)*Z,Z)
% 	view(2)
%     F(j) = getframe;
% end
% movie(F,20) % Play the movie twenty times















