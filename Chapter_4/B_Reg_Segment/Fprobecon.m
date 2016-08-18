function outl = Fprobecon(Y,St,V1,V2)
	
	if nargin < 3
		error('Túl kevés paraméter!!');
	end

	fail = [];
	Vm = V1+1;
	
	for i = 1:size(Y,1)-Vm
		Sa = std(Y(i:i+V1));
		
		if((Sa/St) > finv(0.95,V1,V2))
			fail = [fail i+Vm-1];
		end
	end
	outl = unique(fail);
end
