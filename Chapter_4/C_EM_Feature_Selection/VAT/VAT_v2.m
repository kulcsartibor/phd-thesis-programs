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
    order = [order; minc(1)]; %order based on the similarity
end

%the pairwise distances (REORDEING)
D=sqrt(PairDist);
D=D(order,:);
D=D(:,order);
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

