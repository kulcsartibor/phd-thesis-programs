function result = topnir(Prop, Param, DistM)

Yp = zeros(size(Prop,1),size(Prop,2));

Dm = Param.Dmax * (Param.RSphere/100);

Nnb = Param.Nnb;
Nprop = size(Prop,2);
NSamp = size(Prop,1);

for i = 1:Nprop
	Y = Prop(:,i);
	NullY = find(Prop(:,i) == -9999);
	
	for j = 1:NSamp
		FarSamp = find(DistM(j,:) > Dm);		
		[Di,CloseI] = sort(DistM(j,:),2,'ascend');

		GoodNb = setdiff(CloseI,union(NullY,FarSamp),'stable');		
		if(length(GoodNb) <= 1)
			Yp(j,i) = -9999;		
		elseif((length(GoodNb) > 1) && (length(GoodNb) < (Nnb + 1)))
			Neibs = GoodNb(2:end);
		else
			Neibs = GoodNb(2:Nnb+1);
		end
% 		disp(Neibs)
		Yp(j,i) = mean(Y(Neibs));		
	end
	NNull = setdiff(1:NSamp , NullY);
% 	plot(Prop(NNull,i),Yp(NNull,i),'.')
% 	pause
end

result.Y = Prop;
result.Yp = Yp;
end