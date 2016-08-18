function f = optfun_par(c)
global lfs1 lfs2 N_fs1 l_X l_DistM


agr1 = lfs2;
agr2 = insert_param_value(lfs1, c(1:N_fs1));

[Mt Mc] = breeding_agrres(agr1,agr2,l_X,l_DistM);

f = -100*(Mt*Mc);

% disp(agr1)
% disp(agr2)
