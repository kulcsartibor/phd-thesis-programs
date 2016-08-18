function [nbh, prm1] = agr_par_opres(Agr, fs1, X , DistM)

global lfs1 lfs2 N_fs1 l_X l_DistM methode

% methode = 'FMIN2';
methode = 'PATTERN';

l_X = X;
l_DistM = DistM;

% disp(fs1)

lfs1 = insert_linparam(fs1(2:end-1),1);
% disp(lfs1)
lfs2 = Agr;
nlinnodes1 = get_nlin_nodes(lfs1);

eval(['X_ag1 = ' nlinnodes1 ';']);

N_fs1 = numel(find(lfs1 == 'C'));

if(N_fs1 >0)
	
	switch methode
		case 'FMIN2'
			[Mt, Mc] = breeding_agrres(Agr,fs1,X,DistM);
			nbh1 = Mt*Mc;
			
			Aeq = []; % [zeros(1,N_fs1+N_fs2) 1 1];
			beq = []; % 4;
			LB = [ones(N_fs1,1)];
			UB = [10*ones(N_fs1,1)];
			
			options=optimset(	'Algorithm', 'active-set',...
								'Display', 'off',...
								'DiffMinChange', 1);
			prm1 = fmincon(@optfun,...
				[5*ones(N_fs1,1)],...	% Kezdeti érték
				[],[],...					% Egyenlõtlenségi kéynszer
				Aeq,beq,...					% Egyenlõségi kényszer
				LB,...						% Alsó korlát
				UB,...					% Felsõ korlát
				[],...
				options);

			agr1 = insert_param_value(lfs1, prm1);
			disp(prm1')
% 			disp(Agr)
% 			disp(fs1)
			[Mt, Mc] = breeding_agrres(Agr,agr1,l_X,l_DistM);
			nbh = Mt*Mc;
			disp([nbh1 nbh])
			
		case 'PATTERN'
			[Mt, Mc] = breeding_agrres(Agr,fs1,X,DistM);
			nbh1 = Mt*Mc;
			
			Aeq = []; % [zeros(1,N_fs1+N_fs2) 1 1];
			beq = []; % 4;
			LB = [zeros(N_fs1,1)]; %[ones(N_fs1,1)];
			UB = [10*ones(N_fs1,1)];
			
			options=psoptimset(	'Cache','on',...
								'InitialMeshSize',1,...
								'InitialPenalty', 10,...
								'TimeLimit',5,...
								'Display','off');
							
			prm1 = patternsearch(@optfun_par,...
				[5*ones(N_fs1,1)],...	% Kezdeti érték
				[],[],...					% Egyenlõtlenségi kéynszer
				Aeq,beq,...					% Egyenlõségi kényszer
				LB,...						% Alsó korlát
				UB,...					% Felsõ korlát
				[],...
				options);

			agr1 = insert_param_value(lfs1, prm1);

			[Mt, Mc] = breeding_agrres(Agr,agr1,l_X,l_DistM);
			nbh = Mt*Mc;
			disp([nbh1 nbh])
	end
	
else
	[Mt, Mc] = breeding_agrres(fs1{1},fs1{1},loc_X,loc_DistM);
	nbh = Mt*Mc;
	prm1 = [];
	prm2 = [];
	
end