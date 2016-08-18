function vgplot(area,tree,node)

xmin = area(1,1);
xmax = area(2,1);
ymin = area(1,2);
ymax = area(2,2);


if(tree.feature(node) == 1)
		line([tree.cut(1) tree.cut(node)], [ymin ymax]);
else
		line([xmin xmax], [tree.cut(node) tree.cut(node)]);
end
	
if(tree.depth(node) <= tree.depth(node+1))

	if(tree.feature(1) == 1)
		if(tree.larger == 1)
			xmin = tree.cut(node);
% 			xmax = tree.cut(node);
		else
			xmax = tree.cut(node);
% 			xmin = tree.cut(node);
		end
	else
		if(tree.larger == 1)
			ymin = tree.cut(node);
% 			ymax = tree.cut(node);
		else
			ymax = tree.cut(node);
% 			ymin = tree.cut(node);
		end
	end
	carea = [xmin ymin; xmax ymax];
	tree.area{node} = carea;
	disp('Elsõ')
	pause	
	vgplot(carea,tree.node+1)
else	
	disp('Második')
	pause
	vgplot(tree.area{node+1},tree.node+1)
end


	


% % area = [	xmin	ymin
% %			xmax	ymax]
% xmin = area(1,1);
% xmax = area(2,1);
% ymin = area(1,2);
% ymax = area(2,2);
% 
% In1 = find(tree.depth == dp)
% 
% 
% In2 = intersect(In1,intersect(find(tree.feature == 1),intersect(find(tree.cut >= xmin),find(tree.cut <= xmax))))
% 
% 
% In3 = intersect(In1,intersect(find(tree.feature == 2),intersect(find(tree.cut >= ymin),find(tree.cut <= ymax))))
% 
% 

