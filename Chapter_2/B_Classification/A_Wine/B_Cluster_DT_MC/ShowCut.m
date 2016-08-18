%%
global Type
Y = [a1 a2];

tree=C45(Y,Type);

%%
area = [min(Y(:,1)) min(Y(:,2)) ; max(Y(:,1)) max(Y(:,2))];

vgplot2(area, tree, 1);