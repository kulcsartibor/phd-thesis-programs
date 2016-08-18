minT = min(Time);
maxT = max(Time);
xData = linspace(minT,maxT,12);

set(gca,'XTick',xData);
datetick('x','mm.dd. HH:MM','keepticks');