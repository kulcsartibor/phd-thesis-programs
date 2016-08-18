%%

%%
Kene = Aggregats(Xs,'Kene');
Kox = Aggregats(Xs,'Kox');
%% 
h = figure('Name','Aggregate Plot','NumberTitle','off','Color',[1 1 1]);
plot(Kene,Kox,'.')
axis([-0.1 1.1 -0.1 1.1])
xlabel('Kene');
ylabel('Kox');
title('Visualization by Kene vs. Kox', 'FontSize', 12,'FontWeight','bold')
%%


%%

h = figure('Name','Aggregate Plot','NumberTitle','off','Color',[1 1 1]);
subplot(1,2,1)

%%
subplot(1,2,2)
Y(:,1) = (Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));
Y(:,2) = (Y(:,2)-min(Y(:,2)))/(max(Y(:,2))-min(Y(:,2)));
plot(Y(:,1),Y(:,2), 'r.')
title('CFPP vs. Densyty', 'FontSize', 12,'FontWeight','bold')
xlabel('CFPP')
ylabel('Density')
%%