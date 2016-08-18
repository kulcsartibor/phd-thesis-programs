
h = figure('Name','Delaunay Triangulation','NumberTitle','off','Color',[1 1 1]);
dt = DelaunayTri(PCAPoints);
triplot(dt);
title('Delaunay Triangulation of PCA', 'FontSize', 12,'FontWeight','bold')
xlabel('1st Principal Component')
ylabel('2nd Principal Component')


%%
for i=1:length(dt.Triangulation)
	ar(i) = polyarea(dt.X(dt.Triangulation(i,:),1),dt.X(dt.Triangulation(i,:),2));
end

%%
h = figure('Name','Distribution of trinagles area','NumberTitle','off','Color',[1 1 1]);
plot(1:length(ar),sort(ar), 'LineWidth',2);
title('Distribution of trinagle area', 'FontSize', 12,'FontWeight','bold')
xlabel('Triangle')
ylabel('Area')
text(30,75,{['Expected value: ' num2str(mean(ar))]; ['Deviance:           ' num2str(std(ar))]}, 'FontWeight','bold')
line([0 800], [mean(ar) mean(ar)], 'Color', [1 0 0])