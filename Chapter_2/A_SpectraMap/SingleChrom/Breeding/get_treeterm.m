function fs = get_treeterm(popu)
%Gets information string about the best solution of a population
%  [sout,tree] = gpols_result(popu,info);
%   sout <- text (string)
%   tree <- the best solution
%   popu -> population structure
%   info -> info mode (1,2)


bestix = 1;

tree = popu.chrom{bestix}.tree;

s = tree_stringrc(tree,1,popu.symbols);
s = strrep(s,'*','.*');
s = strrep(s,'/','./');
s = strrep(s,'^','.^');
s = strrep(s,'\','.\');
fs = sprintf('%s',s);



  