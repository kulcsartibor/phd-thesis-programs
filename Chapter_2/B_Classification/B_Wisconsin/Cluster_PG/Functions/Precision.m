function [Prec Rec F1 Acc] = Precision(Dm1, Dm2)

TP = 0;
FP = 0;
FN = 0;
Mach = 0;
Nn = 0;
N = size(Dm1,1);

% for i = 1:N
% 	for j = i+1:N
% 		set1 = sort(Dm1(i,:));
% 		set2 = sort(Dm2(i,:));
% 		
% % 		I1 = find(Dm1(i,:) == set1(2));
% % 		I2 = find(Dm2(i,:) == set2(2));
% % 		
% % 		Nn = Nn +1;
% % 		if(ismember(j,I1) && ismember(j,I2))
% % 			TP = TP+1;
% % 			Mach = Mach+1;
% % % 			[j I1 I2 TP FP FN Mach]
% % 		elseif(ismember(j,I1) && ~ismember(j,I2))
% % 			FN = FN+1;
% % % 			[j I1 I2 TP FP FN Mach]
% % 		elseif(~ismember(j,I1) && ismember(j,I2))
% % 			FP = FP+1;
% % % 			[j I1 I2 TP FP FN Mach]
% % 		else
% % 			Mach = Mach+1;
% % 		end
% 
% 		Nn = Nn +1;
% 		if((Dm1(i,j) == set1(2)) && ((Dm2(i,j) == set2(2))))
% 			TP = TP+1;
% 			Mach = Mach+1;
% 		elseif((Dm1(i,j) == set1(2)) && ((Dm2(i,j) ~= set2(2))))
% 			FN = FN+1;
% 		elseif((Dm1(i,j) ~= set1(2)) && ((Dm2(i,j) == set2(2))))
% 			FP = FP+1;
% 		else
% 			TP = TP+1;
% 			Mach = Mach+1;
% 		end
% 		
% 	end
% end

for i = 1:N
	set1 = sort(Dm1(i,:));
	set2 = sort(Dm2(i,:));
	I1 = find(Dm1(i,:) == set1(2));
	I2 = find(Dm2(i,:) == set2(2));
% 	A = [A;length(I1) length(I2)];
	if(I1 == I2)
		TP = TP+1;
	else
		FN = FN+1;
		FP = FP+1;
	
	for j = i+1:N
		Nn = Nn +1;
		if((Dm1(i,j) == set1(2)) && ((Dm2(i,j) == set2(2))))
			Mach = Mach+1;
		elseif((Dm1(i,j) ~= set1(2)) && ((Dm2(i,j) ~= set2(2))))
			Mach = Mach+1;
		end
		
	end
end


[TP FP FN Nn Mach]
Prec = TP/(TP+FP);
Rec = TP/(TP+FN);
F1 = 2*(Prec*Rec)/(Prec+Rec);
Acc = Mach / Nn;
end