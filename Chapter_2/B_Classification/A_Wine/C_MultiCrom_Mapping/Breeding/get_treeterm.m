function fs = get_treeterm(popu)
%Gets information string about the best solution of a population
%  [sout,tree] = gpols_result(popu,info);
%   sout <- text (string)
%   tree <- the best solution
%   popu -> population structure
%   info -> info mode (1,2)


bestix = 1;

treeA = popu.unit{bestix}.chromA.tree;
treeB = popu.unit{bestix}.chromB.tree;

s = tree_stringrc(treeA,1,popu.symbols);
s = strrep(s,'*','.*');
s = strrep(s,'/','./');
s = strrep(s,'^','.^');
s = strrep(s,'\','.\');
fs{1} = sprintf('%s',s);

s = tree_stringrc(treeB,1,popu.symbols);
s = strrep(s,'*','.*');
s = strrep(s,'/','./');
s = strrep(s,'^','.^');
s = strrep(s,'\','.\');
fs{2} = sprintf('%s',s);
  