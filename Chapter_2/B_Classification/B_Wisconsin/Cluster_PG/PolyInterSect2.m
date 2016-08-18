function separation = PolyInterSect2(X,Y,CIndex,Display_result)

plot(X,Y,'.')
drawnow
try
	for i=1:numel(CIndex)
		lxy = [X(CIndex{i}) Y(CIndex{i})];

		lxy = unique(lxy,'rows');
		
		nni = find(isnan(lxy(:,1)));
		nni = union(nni, find(isinf(lxy(:,1))));
		nni = union(nni, find(isnan(lxy(:,2))));
		nni = union(nni, find(isinf(lxy(:,2))));
		
		lxy(nni,:) = [];
		if ~isempty(nni)
			disp('Hibás adat')
		end
		
		lx = lxy(:,1) + eps;
		ly = lxy(:,2) + eps;
		
		K = convhull(lx,ly);

		S(i).P(1).x		= lx(K);
		S(i).P(1).y		= ly(K);
		S(i).P(1).hole	= 0;
	end
	
catch exception
	disp('Kivétel 1')
	separation = 0;
	return
end

try
% 	disp('Start Geo')
	Geo = Polygons_intersection(S,Display_result,1e-4);
% 	disp('Stop Geo')
catch exception	
	disp('Kivéte  2')
	separation = 0;
	return
end
% 	if (Display_result == 1)
% 
% 	end

try
	carea = 0;
	iarea = 0;
	for i=1:numel(Geo)		
		if(numel(Geo(i).index) == 1)
			iarea = iarea + Geo(i).area;
		end
		if(numel(Geo(i).index) > 1)
			carea = carea + Geo(i).area;
		end
	end
	separation = iarea / (iarea + carea);	
catch exception
	disp('Kivétel 3')
	separation = 0;
	return
end










