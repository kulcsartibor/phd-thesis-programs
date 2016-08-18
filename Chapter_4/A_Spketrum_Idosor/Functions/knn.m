function YEst = knn(DM, Y, Nnum)

YEst = zeros(size(DM,1),1);
for i = 1:size(DM,1)
	
	LocDist = DM(i,:);
	LocDist = sort(LocDist);
	LocIn = find((LocDist(2)) <= (DM(i,:)) & (DM(i,:) <= LocDist(Nnum+1)));
% 	YEst(i) = ((1./DM(i,LocIn))*Y(LocIn))./sum(1./DM(i,LocIn));
	YEst(i) = mean(Y(LocIn));
	
end



