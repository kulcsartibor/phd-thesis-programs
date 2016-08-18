function VAT(data, PairDist, sc)

%% Prim's minimal spanning tree algorithm with special initialization
% initialization
[maxr maxc] = find(PairDist == max(max(PairDist)));
inic = maxr(1);
inic2 = maxr(2);
% iteration
order = [inic];
dum = [];
for i = 2 : size(PairDist,1)
    % + new sample 
    dum = [dum; PairDist(order(end), :)];
    dum(:,order(end)) = inf;
    dum(end, order) = inf;
    % find the minimum distance
    [minr minc] = find( dum == min(min(dum)) );
    order = [order; minc(1)];
end

% the pairwise distances
dum = [];
dum = data.X(order, :);
D = [];
for i = 1:size(dum,1)
    D = [D; sqrt(sum( ( dum - repmat(dum(i,:),size(dum,1),1) ).^2 , 2 ))' ];
end

figure(24)
surf(flipud(D),'EdgeColor','none')
grid off
%mesh(flipud(D))
view([0 0 90])
colormap('gray')
axis equal
% for VAT graylevel
a = get(gcf, 'ColorMap');
a = a * ( 1-min(min(D))/max(max(D)) ) + min(min(D))/max(max(D));
colormap(a);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
axis([0 size(PairDist,1) 0 size(PairDist,1)])
title('VAT on the original data')
hold off

%--------------------------------------------------------------------------
% just a try: initialization from the other point!
order = [inic2];
dum = [];
for i = 2 : size(PairDist,1)
    % + new sample 
    dum = [dum; PairDist(order(end), :)];
    dum(:,order(end)) = inf;
    dum(end, order) = inf;
    % find the minimum distance
    [minr minc] = find( dum == min(min(dum)) );
    order = [order; minc(1)];
end

% the pairwise distances
dum = [];
dum = data.X(order, :);
D = [];
for i = 1:size(dum,1)
    D = [D; sqrt(sum( ( dum - repmat(dum(i,:),size(dum,1),1) ).^2 , 2 ))' ];
end

figure(25)
surf(flipud(D),'EdgeColor','none')
grid off%mesh(flipud(D))
view([0 0 90])
colormap('gray')
axis equal
% for VAT graylevel
a = get(gcf, 'ColorMap');
a = a * ( 1-min(min(D))/max(max(D)) ) + min(min(D))/max(max(D));
colormap(a);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
axis([0 size(PairDist,1) 0 size(PairDist,1)])
title('VAT on the original data')
hold off

%---------------------------------------------------------------
% based on the original single linkage order
dum = [];
dum = data.X(sc, :);
D = [];
for i = 1:size(dum,1)
    D = [D; sqrt(sum( ( dum - repmat(dum(i,:),size(dum,1),1) ).^2 , 2 ))' ];
end

figure(26)
surf(flipud(D),'EdgeColor','none')
grid off
%mesh(flipud(D))
view([0 0 90])
colormap('gray')
axis equal
% for VAT graylevel
a = get(gcf, 'ColorMap');
a = a * ( 1-min(min(D))/max(max(D)) ) + min(min(D))/max(max(D));
colormap(a);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
axis([0 size(PairDist,1) 0 size(PairDist,1)])
title('Single Linkage based VAT')
hold off

