function outliers = Dixon(X,N,k)
	if nargin < 3
		error('Túl kevés paraméter!!');
	end

	Qk = [	0.941	0.970	0.994;
		0.765	0.829	0.926;
		0.642	0.710	0.821;
		0.560	0.625	0.740;
		0.507	0.568	0.680;
		0.468	0.526	0.634;
		0.437	0.493	0.598;
		0.412	0.466	0.568];
	
	n = size(X,1);
	
	fail = [];
	for i = 1:n-N
		[Y,I] = sort(X(i:i+N-1));
% 		[X(i:i+N-1) Y I]
		Qek = (Y(2)-Y(1)) / (Y(N)-Y(1));
		Qen = (Y(N)-Y(N-1)) / (Y(N)-Y(1));
		
% 		[Qek Qen]
		
		if(Qek > Qk(N-2,k))
% 			disp(['Minfail ' num2str(X(i+I(1)-1))])
			fail = [fail i+I(1)-1];
		end
		if(Qen > Qk(N-2,k))
% 			disp(['Maxfail ' num2str(X(i+I(1)-1))])
			fail = [fail i+I(N)-1];
			end
% 		pause
	end
	
	outliers = unique(fail);
end