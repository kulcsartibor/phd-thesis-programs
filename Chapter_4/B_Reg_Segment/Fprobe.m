function outl = Fprobe(X,Y,V1,V2)
	
	if nargin < 3
		error('Túl kevés paraméter!!');
	end

	fail = [];
	Vm = max([V1+1 V2+1]);
	
	for i = 1:size(X,1)-Vm
		Sa = std(Y(i:i+V1));
		St = std(X(i:i+V2));
		
		if((Sa/St) > finv(0.95,V1,V2))
			fail = [fail i+Vm-1];
		end
	end
	outl = unique(fail);
end
