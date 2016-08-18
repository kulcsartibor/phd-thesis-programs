%% PCA szegmentálás
% Kulcsár Tibor
% 2012.06.28

%%
clear('all'); close('all'); clc;
load('OnlList.mat');
load('keveres');
addpath('./PCAsegbu');

%%
KevIndex = intersect(find(keveres <= max(OnlList.Time)),find(keveres >= min(OnlList.Time)));
SpcIndex = intersect(find(OnlList.Time <= max(keveres)),find(OnlList.Time >= min(keveres)));
keveres = keveres(KevIndex);

%%
Xx = OnlList.NormSpectra(SpcIndex,:);
DTime = OnlList.Time(SpcIndex;
V = var(Xx,1,2);
Out = union(find(V < 2e-5),  find(V > 2.3e-5));
Xx(Out,:) = [];
DTime(Out) = [];


rXx = Xx(1:50:end,:);
xData = linspace(min(DTime),max(DTime), 12);

WaveN = OnlList.WaveN;

%%
figure('Name','Spec Series','NumberTitle','off', 'Color',[1 1 1]);
surf(DTime(1:50:end),WaveN,rXx','EdgeColor','none')
set(gca,'XTick',xData);
datetick('x','yy/mm/dd HH:MM','keepticks');
xlabel('Time')
ylabel('WaveNumber')
zlabel('Absorbance')
title('Spectra Series','FontSize',12)

%%
rXxd = rXx - repmat(mean(rXx),size(rXx,1),1);
figure('Name','Spec Series','NumberTitle','off', 'Color',[1 1 1]);
surf(1:size(rXxd,1),1:size(rXxd,2),rXxd','EdgeColor','none')
xlabel('Time')
ylabel('WaveNumber')
zlabel('Absorbance')
title('Spectra Series','FontSize',12)

%% 
[segment,tc] = pcaseg(Xx,10,5,1);

%%
Xd = Xx - repmat(mean(Xx),size(Xx,1),1);
Xsigma = std(Xd,[],2);
Xmu = mean(Xd,2);

%%
figure('Name','Derivative','NumberTitle','off', 'Color',[1 1 1]);
plot(Xd')
xlabel('WaveNumber')
zlabel('Absorbance')
title('Derivative Series','FontSize',12)
axis on

%%
dX = (Xx(2:end,:) - Xx(1:end-1,:));
sdX = sum(abs(dX),2);
figure('Name','QQ plot','NumberTitle','off', 'Color',[1 1 1]);
plot(sdX, 'r.')
hold on
midX = min(sdX);
madX = max(sdX);
for i=1:length(segment)-1
	line([segment(i).rx segment(i).rx], [midX madX]);
end
xlabel('Time');
ylabel('Time based derivative')
title('Derivative vs. time')

%%
c = mean(Xx);
Xp = Xx - repmat(c, size(Xx,1), 1);
covar = cov(Xp);
opt.disp = 0;
[p, D] = eigs(covar, 2, 'LA', opt);
PCAPoints = Xp*p;


NormPCA = [((PCAPoints(:,1) - min(PCAPoints(:,1)))./(max(PCAPoints(:,1)) - min(PCAPoints(:,1))))...
	((PCAPoints(:,2) - min(PCAPoints(:,2)))./(max(PCAPoints(:,2)) - min(PCAPoints(:,2))))];
%%

% cc=hsv(length(segment));
cc = repmat([1 0 0; 0 0 1], ceil(length(segment)/2),1);
jel = repmat('.+',1,ceil(length(segment)/2));
figure('Color',[1 1 1]); 
hold on;
% grid on;
for i=1:length(segment)
%	plot(Xsigma(segment(i).lx:segment(i).rx),Xmu(segment(i).lx:segment(i).rx),'.','color',cc(i,:))
%	plot(DTime(segment(i).lx:segment(i).rx),Xsigma(segment(i).lx:segment(i).rx),'.','color',cc(i,:))
% 	plot3(DTime(segment(i).lx:segment(i).rx),Xsigma(segment(i).lx:segment(i).rx),Xmu(segment(i).lx:segment(i).rx),'.','color',cc(i,:))
% 	plot3(DTime(segment(i).lx:segment(i).rx),NormPCA(segment(i).lx:segment(i).rx,1),NormPCA(segment(i).lx:segment(i).rx,2),'.','color',cc(i,:))
% 	plot3(DTime(segment(i).lx:segment(i).rx),NormPCA(segment(i).lx:segment(i).rx,1),NormPCA(segment(i).lx:segment(i).rx,2),'.','color',cc(i,:))
	plot3(DTime(segment(i).lx:segment(i).rx),NormPCA(segment(i).lx:segment(i).rx,1),NormPCA(segment(i).lx:segment(i).rx,2),jel(i),'color',cc(i,:))
end



for j = 1:numel(keveres)
% 	s = surf(repmat(keveres(j),1,2),[0 1],repmat([0 1],2,1));
% 	set(s, 'facecolor', 'none') ;
% 	alpha(s, 1);
	line([keveres(j) keveres(j)],[0 0],[0 1],'Color','k','LineWidth',1)
	line([keveres(j) keveres(j)],[0 1],[0 0],'Color','k','LineWidth',1)
	line([keveres(j) keveres(j)],[0 1],[1 1],'Color','k','LineWidth',1)
	line([keveres(j) keveres(j)],[1 1],[0 1],'Color','k','LineWidth',1)
end
% 
% 
xlabel('Time')
ylabel('1. Principal Component')
zlabel('2. Principal Component')
set(gca,'XTick',xData);
datetick('x','yy/mm/dd HH:MM','keepticks');

axis([min(DTime) datenum('2012-09-17 00:00') 0 1 0 1])

% set(gca,'XTick',[])
% set(gca,'XTickLabel',[])
% set(gca,'YTick',[])
% set(gca,'YTickLabel',[])
% set(gca,'ZTick',[])
% set(gca,'ZTickLabel',[])

%%
figure('Name','QQ plot','NumberTitle','off', 'Color',[1 1 1]);
ca = subplot(2,3,1);
hold on
for i=1:length(segment)
	plot(DTime(segment(i).lx:segment(i).rx),NormPCA(segment(i).lx:segment(i).rx,1),'.','color',cc(i,:));
end
title('1. PC vs. time','FontSize',12);
xlabel('Time')
ylabel('1. PC')

ca = subplot(2,3,2);
hold on
for i=1:length(segment)
	plot(DTime(segment(i).lx:segment(i).rx),NormPCA(segment(i).lx:segment(i).rx,2),'.','color',cc(i,:));
end
title('2. PC vs. time','FontSize',12);
xlabel('Time')
ylabel('2. PC')

ca = subplot(2,3,3);
hold on
for i=1:length(segment)
	plot(NormPCA(segment(i).lx:segment(i).rx,1),NormPCA(segment(i).lx:segment(i).rx,2),'.','color',cc(i,:));
end
title('2. PC vs. time','FontSize',12);
xlabel('1. PC')
ylabel('2. PC')

ca = subplot(2,3,4);
hold on
for i=1:length(segment)
	plot(Xsigma(segment(i).lx:segment(i).rx),Xmu(segment(i).lx:segment(i).rx),'.','color',cc(i,:))
end
title('Mean absorbance','FontSize',12);
xlabel('Time')
ylabel('\mu')

ca = subplot(2,3,5);
hold on
for i=1:length(segment)
	plot(DTime(segment(i).lx:segment(i).rx),Xsigma(segment(i).lx:segment(i).rx),'.','color',cc(i,:))
end
title('Absorbance Deviation','FontSize',12);
xlabel('Time')
ylabel('\sigma')

ca = subplot(2,3,6);
hold on
for i=1:length(segment)
	plot(Xmu(segment(i).lx:segment(i).rx),Xsigma(segment(i).lx:segment(i).rx),'.','color',cc(i,:))
end
title('Mean absorbance vs. Deviation','FontSize',12);
xlabel('mu')
ylabel('\sigma')



%%
figure('Name','QQ plot','NumberTitle','off', 'Color',[1 1 1]);
for i=1:length(segment)
	subplot(3,4,i);
	ncr = corrcoef(Xx(segment(i).lx:segment(i).rx,:));
% 	subplot(1,2,1)
	surf(WaveN,WaveN,ncr,'EdgeColor','none')
	view(2);
	axis([min(WaveN) max(WaveN) min(WaveN) max(WaveN)]);
	axis off

end

%%
% clear F
% figure('Name','QQ plot','NumberTitle','off', 'Color',[1 1 1]);
% writerObj = VideoWriter('newfile.avi','Uncompressed AVI');
% writerObj.FrameRate = 20;
% open(writerObj);
% 
% surf(WaveN,WaveN,corrcoef(Xx,:),'EdgeColor','none');
% set(gca,'nextplot','replacechildren');
% set(gcf,'Renderer','zbuffer');
% 
% for j = (size(Xx,2)+1):20:size(Xx,1)
% 	ncr = corrcoef(Xx(j-size(X,2):j,:));
% 	surf(WaveN,WaveN,ncr,'EdgeColor','none');
% 	view(2);
% 	axis([min(WaveN) max(WaveN) min(WaveN) max(WaveN)]);
% 	title([num2str(size(X,1)) ' / ' num2str(j)])	
% 
%     writeVideo(writerObj,getframe(gcf));
% % 	pause
% end
% close(writerObj);
% close(gcf)




