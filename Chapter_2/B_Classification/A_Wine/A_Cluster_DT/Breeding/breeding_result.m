function [sout, Agr1, Agr2] = breeding_result(popu,info)
%Gets information string about the best solution of a population
%  [sout,tree] = gpols_result(popu,info);
%   sout <- text (string)
%   tree <- the best solution
%   popu -> population structure
%   info -> info mode (1,2)
%

% (c) Janos Madar, University of Veszprem, 2005

if info == 0,
  sout = sprintf('Iter \t Fitness \t Solution');
  return;
end

best = popu.unit{1}.fitness;
bestix = 1;
for i = 1:popu.size,
  if popu.unit{i}.fitness > best,
    best = popu.unit{i}.fitness;
    bestix = i;
  end
end
treeA = popu.unit{bestix}.chromA.tree;
treeB = popu.unit{bestix}.chromB.tree;

if info == 1,
  sout = sprintf('Gen: %3i. \t Fit: %f \r\n',popu.generation,best);
  s = tree_stringrc(treeA,1,popu.symbols);
  s = strrep(s,'*','.*');
  s = strrep(s,'/','./');
  s = strrep(s,'\','.\');
  s = insert_linparam(s,1);
  s = insert_param_value(s,treeA.param,treeA.weight);
  Agr1 = s;
  sout = sprintf('%s \t Agr 1: \t %s \r\n',sout,s);
  
  s = tree_stringrc(treeB,1,popu.symbols);
  s = strrep(s,'*','.*');
  s = strrep(s,'/','./');
  s = strrep(s,'\','.\');
  s = insert_linparam(s,1);
  s = insert_param_value(s,treeB.param,treeB.weigth);
  Agr2 = s;
  sout = sprintf('%s \t Agr 2: \t %s',sout,s);
  
%   sout = replaceparam(sout,popu.chrom{bestix}.tree.param(popu.chrom{bestix}.tree.paramn));
  return;
end

if info == 2,
  sout = sprintf('fitness: %f,  mse: %f',best,popu.chrom{bestix}.mse);
  [vv,fs] = fsgen(tree,popu.symbols);
  for i = 1:length(fs),
    sout = sprintf('%s\n %f * %s +',sout,tree.param(i),fs{i});
  end
  sout = sprintf('%s\n %f',sout,tree.param(i+1));
  sout = insert_param(sout);
  sout = replaceparam(sout,popu.chrom{bestix}.tree.param(popu.chrom{bestix}.tree.paramn));
  return;
end

sout = '???';

%---------------------------------------------------------------
function [vv,fs,vvdel] = fsgen(tree,symbols);
%Search the '+ parts'
v = [1];
vv = [];
i = 1;
while i <= length(v),
  ii = v(i);
  if tree.nodetyp(ii)==1 & tree.node(ii)==1,
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
  while ii<i & ok==0,
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

  