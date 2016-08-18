function corr = delpred(points,Y,DistM)

% border = convhull(points(:,1),points(:,2));
NNY = 1:size(Y,1);
EstY = [];
Outlier = [];
for i = 1:size(Y,1)
	LoopPoints = setdiff(NNY,i);
	estset = points(LoopPoints,:);
	EDistM = DistM(: ,LoopPoints);
	esttri = DelaunayTri(estset(:,1),estset(:,2));
	SetY = Y(LoopPoints,:);
	
	j = pointLocation(esttri, points(i,1),points(i,2));
	
	if(~isnan(j))
		Zs = [esttri.X(esttri.Triangulation(j,:),:)' ; ones(1,3)];
		Bar = Zs\[points(i,:) 1]';
		EstY = [EstY ; Bar'*SetY(esttri(j,:))];
	else
		Outlier = [Outlier; i];
	end

end
c = corrcoef(EstY,Y(setdiff(NNY,Outlier)));
corr = c(2);
% 	corr(1) = size(EstY,1);
% 	corr(2) = size(Y(setdiff(NNY,Outlier)),1);
% 	corr(3) = corrcoef(EstY,Y(setdiff(NNY,Outlier)));


% function [Y Ey] = delpred(points,Y,DistM)