%%
% h = figure(1);	
opt = [0.8 0.3 0.7 2 2 0.1 0.1 0.01 1 0];
for c = 16:1000
	
	[popu, evnum] = breeding_mainloop(popu,X,DistM,opt);
	[resstr, resAgr1, resAgr2] = breeding_result(popu,1);
	disp(resstr);
	
	PolyInterSect2(eval(resAgr1),eval(resAgr2),TypeI,1)
	drawnow
	
	save(['.\Popu\popu_' num2str(c) '.mat'], 'popu')
% 	disp(['Mapping: ' num2str(popu1.chrom{1}.fitness)]);
% 	figure(1);
% 	hold off
% 	fs = get_treeterm(popu);
% 	
% 	plot(eval(fs{1}),eval(fs{2}),'.')
% 	xlabel(fs{1})
% 	ylabel(fs{2})
% 	title(['Mapping quality: ' num2str(popu.unit{1}.fitness) , ' G: ', num2str(c)])
% 	drawnow
% 	figure(2);
% 	hold on
% 	plot(c,popu.unit{1}.fitness,'g*')
% 	axis([1 45 0 1])
% 	drawnow
% 	saveas(h,['.\images\gen_' num2str(pics) '_' num2str(c) '.png'])
% 	close(h)
end