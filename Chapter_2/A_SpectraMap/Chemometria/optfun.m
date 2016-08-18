function f = optfun(c)
global lfs1 lfs2 N_fs1 N_fs2 l_X l_DistM


agr1 = insert_param_value(lfs1, c(1:N_fs1), c(end-1));
agr2 = insert_param_value(lfs2, c(N_fs1+1:N_fs1+N_fs2), c(end));


% disp(agr1)
% disp(agr2)


[Mt Mc] = breeding_agrres(agr1,agr2,l_X,l_DistM);

f = -100*(Mt*Mc);
% disp(fs1)
% disp(fs2)
% disp([num2str(-f), ' Par: ', num2str(c')])
