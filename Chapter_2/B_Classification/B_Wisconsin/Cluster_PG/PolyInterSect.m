function [separation, distrange] = PolyInterSect(X,Y,CIndex,Display_result)

% Display_result = 1;
if(Display_result)
	hold off
	plot(X,Y,'.')
	hold on
end

try
	for i=1:numel(CIndex)
		lxy = [X(CIndex{i}) Y(CIndex{i})];

		lxy = unique(lxy,'rows');
		
		nni = find(isnan(lxy(:,1)));
		nni = union(nni, find(isinf(lxy(:,1))));
		nni = union(nni, find(isnan(lxy(:,2))));
		nni = union(nni, find(isinf(lxy(:,2))));
		
		lxy(nni,:) = [];
		
		K = convhull(lxy(:,1),lxy(:,2));
		S(i).vertices = lxy(K,:);
		S(i).centcoord = centroid(S(i).vertices);
	end
	
	
	if(Display_result)
		for i = 1:numel(S)
			plot(S(i).vertices(:,1),S(i).vertices(:,2),'k-','LineWidth',2);
			plot(S(i).centcoord(1),S(i).centcoord(2),'r.','MarkerSize',8);
		end
	end
	
	iarea = 0;
	carea = 0;
	distrange = 0;
	
	for i = 1:numel(S)-1
		iarea = iarea + polyarea(S(i).vertices(:,1),S(i).vertices(:,2));
		for j = i+1:numel(S)
			carea = carea + areaintersection(S(i).vertices, S(j).vertices, 10);
			distrange = distrange + pdist([S(i).centcoord; S(j).centcoord]);
			if(Display_result)
				line([S(i).centcoord(1) S(j).centcoord(1)],[S(i).centcoord(2) S(j).centcoord(2)],'Color',[0 1 0])
			end
		end
	end
	
	iarea = iarea + polyarea(S(numel(S)).vertices(:,1),S(numel(S)).vertices(:,2));
	
% 	separation = iarea/(iarea+carea);
	separation = 1- carea/iarea;
% 	disp([separation carea]);

	distrange = distrange/(3*max(max(pdist([X Y]))));
% 	disp(distrange);
	
	if(Display_result)
		title([num2str(separation) '  ' num2str(carea)])
		drawnow
	end
	
	

catch exception
	disp(exception)
	separation = 0;
	distrange = 0;
	return
end










