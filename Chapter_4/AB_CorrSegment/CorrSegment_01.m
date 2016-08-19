%% PCA szegmentálás
% Kulcsár Tibor
% 2015.07.15

%%
clear('all'); close('all'); clc;
load('OnlList.mat');
load('keveres');
% addpath('./PCAsegbu');

%%
KevIndex = intersect(find(keveres <= max(OnlList.Time)),find(keveres >= min(OnlList.Time)));
SpcIndex = intersect(find(OnlList.Time <= max(keveres)),find(OnlList.Time >= min(keveres)));
keveres = keveres(KevIndex);

%%
Xx = OnlList.NormSpectra(SpcIndex,:);
DTime = OnlList.Time(SpcIndex);
V = var(Xx,1,2);
Out = union(find(V < 2e-5),  find(V > 2.3e-5));
Xx(Out,:) = [];
DTime(Out) = [];

rXx = Xx(1:50:end,:);
xData = linspace(min(DTime),max(DTime), 12);

WaveN = OnlList.WaveN;


%%
fcorr = abs(corrcoef(Xx));
figure('Name','Full correlation map','NumberTitle','off', 'Color',[1 1 1]);
surf(fcorr,'EdgeColor','None');
set(gca,'XLim',[0 195])
set(gca,'YLim',[0 195])
box('off')
view(2)
axis('square')
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'ztick',[])
colorbar

%%
[segment, frob] = corrseg(Xx,30);
% [segment, frob] = corrseg2(Xx,50);

%%
if 0
figure('Name','Segment Boarders','NumberTitle','off', 'Color',[1 1 1]);
% surf(DTime(1:50:end),WaveN,rXx','EdgeColor','none')
set(gca,'XTick',xData);
datetick('x','yy/mm/dd HH:MM','keepticks');
xlabel('Time')
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
% ylabel('WaveNumber')
zlabel('Absorbance')
% title('Spectra Series','FontSize',12)
set(gca,'XLim',[min(DTime) max(DTime)])
set(gca,'YLim',[min(WaveN) max(WaveN)])
view(2)
box on


wl = [min(WaveN) max(WaveN)];
xl = [min(rXx(:)) max(rXx(:))];
%
for j = 1:numel(keveres)
	s = surf(repmat(keveres(j),1,2),[0 1],repmat([0 1],2,1));
	set(s, 'facecolor', 'none') ;
	alpha(s, 1);
	line([keveres(j) keveres(j)],[wl(1) wl(1)],[xl(1) xl(2)],'Color','k','LineWidth',1)
	line([keveres(j) keveres(j)],[wl(1) wl(2)],[xl(1) xl(1)],'Color','k','LineWidth',1)
	line([keveres(j) keveres(j)],[wl(1) wl(2)],[xl(2) xl(2)],'Color','k','LineWidth',1)
	line([keveres(j) keveres(j)],[wl(2) wl(2)],[xl(1) xl(2)],'Color','k','LineWidth',1)
end
for j = 1:numel(segment)-1
	line([DTime(segment(j).rx) DTime(segment(j).rx)],[wl(1) wl(1)],[xl(1) xl(2)],'Color','r','LineWidth',1)
	line([DTime(segment(j).rx) DTime(segment(j).rx)],[wl(1) wl(2)],[xl(1) xl(1)],'Color','r','LineWidth',1)
	line([DTime(segment(j).rx) DTime(segment(j).rx)],[wl(1) wl(2)],[xl(2) xl(2)],'Color','r','LineWidth',1)
	line([DTime(segment(j).rx) DTime(segment(j).rx)],[wl(2) wl(2)],[xl(1) xl(2)],'Color','r','LineWidth',1)
	h_t = text(mean([DTime(segment(j).lx) DTime(segment(j).rx)]), wl(1), num2str(j));
	
end

end
%%

figure('Name','Segment Boarders','NumberTitle','off', 'Color',[1 1 1]);
% surf(DTime(1:50:end),WaveN,rXx','EdgeColor','none')
set(gca,'XTick',xData);
datetick('x','yy/mm/dd HH:MM','keepticks');
xlabel('Time')
time_axis = gca;
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
set(gca,'XLim',[min(DTime) max(DTime)])
set(gca,'YLim',[0 1])
box on
for j = 1:numel(keveres)
	line([keveres(j) keveres(j)],[0 1],'Color','k','LineWidth',1)
end
for j = 1:25
	line([DTime(segment(j).rx) DTime(segment(j).rx)],[0 1],'Color','r','LineWidth',1)
	h_t = text(mean([DTime(segment(j).lx) DTime(segment(j).rx)]), 0.5, num2str(j));
	set(h_t, 'HorizontalAlignment','center')
	set(h_t, 'rotation', 90)
end

%%
figure('Name','Spectra Maps','NumberTitle','off', 'Color',[1 1 1]);
l = 0;
for i = 1:20%umel(segment)
	subplot(5,4,i)
	surf(abs(segment(i).corr),'EdgeColor','None');
	cc = colorbar('Ticks',[0 0.5 1],'XLim',[0 1]);
	title(['Segment ' num2str(i)])
	set(gca,'XLim',[0 195])
	set(gca,'YLim',[0 195])
	box('off')
	view(2)
	axis('square')
	set(gca,'xtick',[])
	set(gca,'ytick',[])
	set(gca,'ztick',[])
	ylabel(mean(std(Xx(segment(i).lx:segment(i).rx,:))))
 	xlabel(['Length: '  num2str(segment(i).rx- segment(i).lx)])
end
set(time_axis,'XLim',[min(DTime) DTime(segment(26).lx)])

%%
figure('Name','Spectra Maps','NumberTitle','off', 'Color',[1 1 1]);
for i = 21:numel(segment)
	subplot(5,4,i-20)
	surf(abs(segment(i).corr),'EdgeColor','None');
	cc = colorbar('Ticks',[0 0.5 1],'XLim',[0 1]);
	title(['Segment ' num2str(i)])
	set(gca,'XLim',[0 195])
	set(gca,'YLim',[0 195])
	box('off')
	view(2)
	axis('square')
	set(gca,'xtick',[])
	set(gca,'ytick',[])
	set(gca,'ztick',[])
 	ylabel(mean(std(Xx(segment(i).lx:segment(i).rx,:))))
	xlabel(['Length: '  num2str(segment(i).rx- segment(i).lx)])
end

return
%%
for i = 2:numel(segment)
	subplot(1,2,1)
	surf(segment(i-1).corr,'EdgeColor','None')
	view(2)
	axis('square')
	set(gca,'xtick',[])
	set(gca,'ytick',[])
	set(gca,'ztick',[])
	subplot(1,2,2)
	surf(segment(i).corr,'EdgeColor','None')
	view(2)
	axis('square')
	set(gca,'xtick',[])
	set(gca,'ytick',[])
	set(gca,'ztick',[])
% 	pause
end



%%








return

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




