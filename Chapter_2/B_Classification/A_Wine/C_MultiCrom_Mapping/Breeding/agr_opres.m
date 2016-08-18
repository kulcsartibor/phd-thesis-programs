function [nbh, prm1, prm2, k1, k2] = agr_opres(fs1,fs2, X , DistM)

global lfs1 lfs2 N_fs1 N_fs2 l_X l_DistM methode

% methode = 'FMIN';
% methode = 'PCA2';
% methode = 'FMIN';
methode = 'PATTERN';
% methode = 'PCA3';

k1 = 0;
k2 = 0;


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
			
		case 'PATTERN'
			
			[Mt, Mc] = breeding_agrres(fs1,fs2,X,DistM);
			nbh1 = Mt*Mc;
			
			Aeq = [zeros(1,N_fs1+N_fs2) 1 1];
			beq = 1;
			LB = [zeros(N_fs1+N_fs2,1); 0; 0];
			UB = [10*ones(N_fs1+N_fs2,1); 10; 10];

			options=psoptimset(	'Cache','on',...
								'InitialMeshSize',1,...
								'InitialPenalty', 10,...
								'TimeLimit',5,...
								'Display','off',...
								'UseParallel', 'always');
							
			prm = patternsearch(@optfun,...
				[ones(N_fs1+N_fs2,1); 1; 1],...	% Kezdeti érték
				[],[],...						% Egyenlõtlenségi kéynszer
				Aeq,beq,...						% Egyenlõségi kényszer
				LB,...							% Alsó korlát
				UB,...							% Felsõ korlát
				[],...
				options);

			prm1 = prm(1:N_fs1,1);
			prm2 = prm(N_fs1+1:N_fs1+N_fs2,1);
			
			k1 = prm(end-1);
			k2 = prm(end);
			
			agr1 = insert_param_value(lfs1, prm1, k1);
			agr2 = insert_param_value(lfs2, prm2, k2);
						
			[Mt, Mc] = breeding_agrres(agr1,agr2,l_X,l_DistM);
			nbh = Mt*Mc;

			disp([nbh1 nbh])
% 			disp(agr1)
% 			disp(agr2)
% 			pause
% 			
	end

	
else
	[Mt, Mc] = breeding_agrres(fs1{1},fs1{1},loc_X,loc_DistM);
	nbh = Mt*Mc;
	prm1 = [];
	prm2 = [];
	
end