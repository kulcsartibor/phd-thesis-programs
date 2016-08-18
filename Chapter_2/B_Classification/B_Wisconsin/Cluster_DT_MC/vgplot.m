function vgplot(area,tree,node)

xmin = area(1,1);
xmax = area(2,1);
ymin = area(1,2);
ymax = area(2,2);

% pause

[node tree.depth(node) tree.feature(node)]
if(tree.feature(node) == 1)
	lh = line([tree.cut(node) tree.cut(node)], [ymin ymax]);
else
	lh = line([xmin xmax], [tree.cut(node) tree.cut(node)]);
end
	
if(tree.depth(node) <= tree.depth(node+1))	

	if(tree.feature(node) == 1)
		if(tree.larger(node) == 1)
% 			disp('f1 Elsõ')
			xmin = tree.cut(node);
		else
% 			disp('f1 Második')
			xmax = tree.cut(node);
		end
	else
		if(tree.larger(node) == 1)
% 			disp('f2 Elsõ')
			ymin = tree.cut(node);
		else
% 			disp('f2 Második')
			ymax = tree.cut(node);
		end
	end
	carea = [xmin ymin; xmax ymax];
	tree.area{node} = carea;
	if(node + 1 == numel(tree.depth))
		return
	end
	if(tree.depth(node) == tree.depth(node+1))
		vgplot(area,tree,node+1);
	else
		vgplot(carea,tree,node+1)
	end
else	
	if(node + 1 == numel(tree.depth))
		return
	end
	vgplot(tree.area{node+1},tree,node+1)
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

