function [popu] = breeding_evaluate(popuin,ixs,X,DistM,Q)
%Evaluates individulas and identificates their linear parameters
% popu = gpols_evaluate(popuin,ixs,X,Y,Q,optv)
%   popu <- result (population)
%   popuin -> input population
%   ixs -> vector of indexes of individulas to evaluate
%   X -> Regression matrix without bias (!)
%   Q -> Weighting vector (set empty if not used)
%   optv -> evaluation parameters (set empty for default)
%    [optv(1) optv(2)]: a1, a2 tree-size penalty parameters (default: 0,0)
%    optv(3): OLS treshold value, range: 0-1 (default: 0)
%    optv(4): if == 1 then polynomial evaluation else normal (default: 0)
global N_fs1 N_fs2;

%Output
popu = popuin;

%WLS matrices
if isempty(Q),
	Q = ones(size(X,1),1);
end
Q = diag(Q);
X = sqrt(Q)*X;

%Symbolum list
for i = 1:length(popu.symbols{1}),
	s = popu.symbols{1}{i}(1);
	if s=='*' || s=='/' || s=='^' || s=='\',
		symbols{1}{i} = strcat('.',popu.symbols{1}{i});
	else
		symbols{1}{i} = popu.symbols{1}{i};
	end
end

for i = 1:size(X,2),
	symbols{2}{i} = sprintf('X(:,%i)',i);
end

%MAIN loop
for j = ixs,
	
	%Get the tree
	tree1 = popu.unit{j}.chromA.tree;
	tree2 = popu.unit{j}.chromB.tree;
	
	%Collect the '+ parts'
	[vv1,fs1,vvdel1] = fsgen(tree1,symbols);
	[vv2,fs2,vvdel2] = fsgen(tree2,symbols);
	
	%Prune redundant parts
	tree1 = prunetree(vvdel1,tree1,symbols);
	tree2 = prunetree(vvdel2,tree2,symbols);
	
	%Collect the '+ parts'
	[vv1,fs1,vvdel1] = fsgen(tree1,symbols);
	if ~isempty(vvdel1),
		error('Fatal error: redundant strings after deleting');
	end
	
	[vv2,fs2,vvdel2] = fsgen(tree2,symbols);
	if ~isempty(vvdel2),
		error('Fatal error: redundant strings after deleting');
	end
	
	fs1 = strcat('(',tree_stringrc(tree1,1,symbols),')');
	fs2 = strcat('(',tree_stringrc(tree2,1,symbols),')');
	
	%Prune redundant parts
	tree1 = prunetree(vvdel1,tree1,symbols);
	tree2 = prunetree(vvdel2,tree2,symbols);

% 	disp(['Egyed: ' num2str(j)])
% 	[loc_fs1 N_fs1] = insert_param(fs1);
% 	[loc_fs2 N_fs2] = insert_param(fs2);

	[fitness, param1, param2, k1, k2] = agr_opres(fs1,fs2, X , DistM);
	
	%Chrom
	popu.unit{j}.tree = tree1;
	popu.unit{j}.tree = tree2;

	popu.unit{j}.fitness = fitness;

	popu.unit{j}.chromA.tree.param = param1;
	popu.unit{j}.chromA.tree.paramn = N_fs1;
	popu.unit{j}.chromA.tree.weight = k1;
	
	popu.unit{j}.chromB.tree.param = param2;
	popu.unit{j}.chromB.tree.paramn = N_fs2;
	popu.unit{j}.chromB.tree.weigth = k2;
	
end


%---------------------------------------------------------------
function [tree] = polytree(treein)
tree = treein;
v = [1];
vv = [];
i = 1;
while i <= length(v),
	ii = v(i);
	if tree.nodetyp(ii)==1 && tree.node(ii)==1,
		v = [v, ii*2, ii*2+1];
	else
		vv = [vv, ii];
	end
	i = i+1;
end
for ii = [vv],
	v = [ii];
	i = 1;
	while i <= length(v),
		if tree.nodetyp(v(i))==1,
			if tree.node(v(i))==1,
				tree.node(v(i)) = 2;
			end
			if v(i)*2+1 <= tree.maxsize,
				v = [v, v(i)*2, v(i)*2+1];
			end
		end
		i = i+1;
	end
end

%---------------------------------------------------------------
function [vv,fs,vvdel] = fsgen(tree,symbols)
%Search the '+ parts'
v = [1];
vv = [];
i = 1;
while i <= length(v),
	ii = v(i);
	if tree.nodetyp(ii)==1 && tree.node(ii)==1,
		v = [v, ii*2, ii*2+1];
	else
		vv = [vv, ii];
	end
	i = i+1;
end
fs = [];
i = 1;
for ii = [vv],
	fs{i} = strcat('(',tree_stringrc(tree,ii,symbols),')');
	i = i+1;
end
%Search the redundant '+ parts'
vvdel = [];
vvv = [];
i = 1;
while i <= length(fs),
	ok = 0;
	ii = 1;
	while ii<i && ok==0,
		ok = strcmp(fs{i},fs{ii});
		ii = ii+1;
	end
	if ok==1,
		vvdel = [vvdel, vv(i)];
	else
		vvv = [vvv, i];
	end
	i = i+1;
end

%---------------------------------------------------------------
function tree = prunetree(vvdel,treein,symbols)
%Delete subtrees
nn = [length(symbols{1}), length(symbols{2})];
tree = treein;
n = floor(tree.maxsize/2);
tree.nodetyp(vvdel) = 0;
ok = 1;
while ok,
	ok = 0;
	i = 1;
	while i<=n && ok==0,
		if (tree.nodetyp(i)==1) && (tree.nodetyp(i*2)==0 || tree.nodetyp(i*2+1)==0),
			ok = 1;
			if tree.nodetyp(i*2)==0 && tree.nodetyp(i*2+1)==0,
				tree.nodetyp(i*2) = treein.nodetyp(i*2);
				tree.nodetyp(i*2+1) = treein.nodetyp(i*2+1);
				tree.nodetyp(i) = 0;
			elseif tree.nodetyp(i*2)==0,
				tree.nodetyp(i*2) = treein.nodetyp(i*2);
				subtree = tree_getsubtree(tree,i*2+1);
				tree = tree_inserttree(subtree,tree,i,nn(2));
			else
				tree.nodetyp(i*2+1) = treein.nodetyp(i*2+1);
				subtree = tree_getsubtree(tree,i*2);
				tree = tree_inserttree(subtree,tree,i,nn(2));
			end
		elseif (tree.nodetyp(i*2)==0 || tree.nodetyp(i*2+1)==0),
			ok = 1;
			if tree.nodetyp(i*2)==0,
				tree.nodetyp(i*2) = treein.nodetyp(i*2);
			end
			if tree.nodetyp(i*2+1)==0,
				tree.nodetyp(i*2+1) = treein.nodetyp(i*2+1);
			end
		end
		i = i+1;
	end
end
