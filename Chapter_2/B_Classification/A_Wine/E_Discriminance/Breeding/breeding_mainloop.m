function [popu, evnum] = breeding_mainloop(popuin,X,DistM,opt)
%Run one evolutionary loop, makes the next generation
% [popu,evnum] = gpols_mainloop(popuin,X,Y,Q,opt)
%   popu <- next generation of the population
%   evnum <- number of fun.evaulation (usually number of new individuals)
%   popuin -> the population
%   opt -> options vector, GPOLS-parameters
%   X,Y,Q -> input, output and weighting matrices (see gpols_evaluate)
%
% Remark:
%     opt(1): ggap, generation gap (0-1)
%     opt(2): pc, probability of crossover (0-1)
%     opt(3): pm, probability of mutation (0-1)
%     opt(4): selection type (integer, see gpols_selection)
%     opt(5): rmode, mode of tree-recombination (1 or 2)
%     opt(6): a1, first penalty parameter
%     opt(7): a2, second penalty parameter (0 if there is not penalty)
%     opt(8): OLS treshhold real 0-1 or integer >= 2
%     opt(9): if == 1 -> polynomial evaluation
%     opt(10): if == 1 -> evaluate all indv.s not only new offsprings
% [0.8 0.3 0.7 2 2 0.1 0.1 0.01 1 0];

% (c) Janos Madar, University of Veszprem, 2005

popun = popuin.size;
ggap = opt(1);
pc = opt(2);
pm = opt(3);
tsels = opt(4);
rmode = opt(5);
%Selection
selm = gpols_selection(popuin,ggap,pc,pm,tsels);
%New generation
popu = popuin;
newix = [];
nn = 1;
for i=1:size(selm,1)
	m = selm(i,3);
	%*** Crossover ***
	if m==1,
		p1 = selm(i,1);
		p2 = selm(i,2);
		popu.unit{nn}.chromA = popuin.unit{p1}.chromA;
		popu.unit{nn}.chromB = popuin.unit{p1}.chromB;
		%     popu1.chrom{nn}.fitness = -1;
		if nn+1<popu.size,
			popu.unit{nn+1}.chromA = popuin.unit{p2}.chromA;
			popu.unit{nn+1}.chromA = popuin.unit{p2}.chromA;
		end
		%recombinate trees
		treeA1 = popuin.unit{p1}.chromA.tree;
		treeA2 = popuin.unit{p2}.chromA.tree;
		treeB1 = popuin.unit{p1}.chromB.tree;
		treeB2 = popuin.unit{p2}.chromB.tree;
		
		[treeA1,treeA2] = tree_crossover(treeA1,treeA2,rmode,popu.symbols);
		[treeB1,treeB2] = tree_crossover(treeB1,treeB2,rmode,popu.symbols);
		
		popu.unit{nn}.chromA.tree = treeA1;
		popu.unit{nn}.chromB.tree = treeB1;
		if nn+1<=popu.size,
			popu.unit{nn+1}.chromA.tree = treeA2;
			popu.unit{nn+1}.chromB.tree = treeB2;
		end
		%remember the new individulas
		newix = [newix nn];
		nn = nn+1;
		if nn<=popu.size,
			newix = [newix nn];
			nn = nn+1;
		end
		%*** Mutation ***
	elseif m==2,
		p1 = selm(i,1);
		popu.unit{nn}.chromA = popuin.unit{p1}.chromA;
		popu.unit{nn}.chromB = popuin.unit{p1}.chromB;
		%     popu1.chrom{nn}.fitness = -1;
		%muatate tree
		treeA1 = popu.unit{p1}.chromA.tree;
		treeA1 = tree_mutate(treeA1,popu.symbols);

		treeB1 = popu.unit{p1}.chromB.tree;
		treeB1 = tree_mutate(treeB1,popu.symbols); 
		
		popu.unit{nn}.chromA.tree = treeA1;
		popu.unit{nn}.chromB.tree = treeB1;
		
		%remember the new individual
		newix = [newix nn];
		nn = nn+1;
		%*** Direct copy ***
	else
		p1 = selm(i,1);
		popu.unit{nn}.chromA = popuin.unit{p1}.chromA;
		popu.unit{nn}.chromB = popuin.unit{p1}.chromB;
		nn = nn+1;
	end
end

%if opt(10)==1 -> evaluate all indv.s
if length(opt)>9 && opt(10)==1,
	newix = [1:popu.size];
end


%Evaulate new indv.s
[popu ] = breeding_evaluate(popu,1:popun,X,DistM,[]);
popu.generation = popu.generation+1;
evnum = length(newix);
