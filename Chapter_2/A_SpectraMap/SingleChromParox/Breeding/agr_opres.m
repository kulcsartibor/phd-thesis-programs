function [nbh, prm1, prm2] = agr_opres(fs1,fs2, X , DistM)

global lfs1 lfs2 N_fs1 N_fs2 l_X l_DistM methode

% methode = 'FMIN';
methode = 'PCA3';

l_X = X;
l_DistM = DistM;

lfs1 = insert_linparam(fs1(2:end-1),1);
lfs2 = insert_linparam(fs2(2:end-1),1);


nlinnodes1 = get_nlin_nodes(lfs1);
nlinnodes2 = get_nlin_nodes(lfs2);

eval(['X_ag1 = ' nlinnodes1 ';']);
eval(['X_ag2 = ' nlinnodes2 ';']);

N_fs1 = numel(find(lfs1 == 'C'));
N_fs2 = numel(find(lfs2 == 'C'));

if(N_fs1+N_fs2 >0)
	
	switch methode
		case 'PCA1'			
			[Mt, Mc] = breeding_agrres(fs1,fs2,X,DistM);
			nbh1 = Mt*Mc;
			if(size(X_ag1,2) > 1)
				c = mean(X_ag1);
				Xp = X_ag1 - repmat(c, size(X_ag1,1), 1);
				covar = cov(Xp);
				opt.disp = 0;
				[prm1, D] = eigs(covar, 1, 'LA', opt); %#ok<*NASGU>
			else
				prm1 = 1;
			end
			
			if(size(X_ag2,2) > 1)
				c = mean(X_ag2);
				Xp = X_ag2 - repmat(c, size(X_ag2,1), 1);
				covar = cov(Xp);
				opt.disp = 0;
				[prm2, D] = eigs(covar, 1, 'LA', opt);
			else
				prm2 = 1;
			end
			
% 			prm1(:,1)
% 			prm2(:,1)
			
			agr1 = insert_param_value(lfs1, prm1(:,1));
			agr2 = insert_param_value(lfs2, prm2(:,1));
			
			
			
			[Mt, Mc] = breeding_agrres(agr1,agr2,l_X,l_DistM);
			nbh = Mt*Mc;
			
			disp([N_fs1 N_fs2 nbh1 nbh])
		
		case 'PCA2'
			
			[Mt, Mc] = breeding_agrres(fs1,fs2,X,DistM);
			nbh1 = Mt*Mc;
			
			X_ag = [X_ag1 X_ag2];
			c = mean(X_ag);
			Xp = X_ag - repmat(c, size(X_ag,1), 1);
			covar = cov(Xp);
			opt.disp = 0;
			[prm, D] = eigs(covar, 1, 'LA', opt); %#ok<*NASGU>

			
			prm1 = prm(1:N_fs1,1);
			prm2 = prm(N_fs1+1:N_fs1+N_fs2,1);
			
			agr1 = insert_param_value(lfs1, prm1);
			agr2 = insert_param_value(lfs2, prm2);
			
			
			
			[Mt, Mc] = breeding_agrres(agr1,agr2,l_X,l_DistM);
			nbh = Mt*Mc;
			
			disp([N_fs1 N_fs2 nbh1 nbh])
			
		case 'PCA3'
			
			[Mt, Mc] = breeding_agrres(fs1,fs2,X,DistM);
			nbh1 = Mt*Mc;
			
			X_ag = [X_ag1 X_ag2];
			c = mean(X_ag);
			Xp = X_ag - repmat(c, size(X_ag,1), 1);
			covar = cov(Xp);
			opt.disp = 0;
			[prm, D] = eigs(covar, 2, 'LA', opt); %#ok<*NASGU>

			
			prm1 = prm(1:N_fs1,1);
			prm2 = prm(N_fs1+1:N_fs1+N_fs2,2);
			
			agr1 = insert_param_value(lfs1, prm1);
			agr2 = insert_param_value(lfs2, prm2);
			
			
			
			[Mt, Mc] = breeding_agrres(agr1,agr2,l_X,l_DistM);
			nbh = Mt*Mc;
			
			disp([N_fs1 N_fs2 nbh1 nbh])
			
		case 'FMIN'
			
			[Mt, Mc] = breeding_agrres(fs1,fs2,X,DistM);
			nbh1 = Mt*Mc;
			options = optimset('Display','off');
% 			options = optimset('DiffMinChange', 0.1);

			prm = fminunc(@optfun,ones(N_fs1+N_fs2,1).*[1:(N_fs1+N_fs2)]'/(N_fs1+N_fs2),options);
			
% 			prm = fmincon(@optfun,ones(N_fs1+N_fs2,1).*[1:(N_fs1+N_fs2)]'/(N_fs1+N_fs2),...
% 				[],[],ones(1,N_fs1+N_fs2),1,zeros(N_fs1+N_fs2,1),ones(N_fs1+N_fs2,1),[],options);
			
			
			
			% 			prm = fminunc(@optfun,rand(N_fs1+N_fs2,1));
			prm1 = prm(1:N_fs1,1);
			prm2 = prm(N_fs1+1:N_fs1+N_fs2,1);
			
			agr1 = insert_param_value(lfs1, prm1);
			agr2 = insert_param_value(lfs2, prm2);
						
			[Mt, Mc] = breeding_agrres(agr1,agr2,l_X,l_DistM);
			nbh = Mt*Mc;
% 	
% 			disp([N_fs1 N_fs2 nbh1 nbh prm'])
% 			disp(lfs1)
% 			disp(lfs2)
% 			
	end
	% 	disp(lfs1)
	% 	disp(agr1)
	% 	disp(lfs2)
	% 	disp(agr2)
	% 	[params,fmin] = patternsearch(@optfun,...
	% 		ones(N_fs1+N_fs2,1),[],[],[],[],...
	% 		-1000*ones(N_fs1+N_fs2,1),...
	% 		1000*ones(N_fs1+N_fs2,1));
	% 	params
	%
	
	% 	options = optimset('DiffMinChange',1);
	% 	options = optimset('DiffMinChange', 0.1, 'DiffMaxChange', 0.2);
	% 	params = fminunc(@optfun,ones(N_fs1+N_fs2,1),options);
	% 	nbh = -optfun(params);
	
	% 	nbh = -fmin;
	% 	prm1 = params(1:N_fs1);
	% 	prm2 = params(N_fs1+1:N_fs1+N_fs2);
	
else
	[Mt, Mc] = breeding_agrres(fs1{1},fs1{1},loc_X,loc_DistM);
	nbh = Mt*Mc;
	prm1 = [];
	prm2 = [];
	
end