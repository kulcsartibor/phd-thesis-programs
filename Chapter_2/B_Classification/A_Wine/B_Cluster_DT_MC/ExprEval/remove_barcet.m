function agregate = remove_barcet(s)

agregate = s;
m = regexp(agregate,'\(W[\d]{4})','match');
m = unique(m);

for i = 1:numel(m)
	agregate = strrep(agregate, m{i}, m{i}(2:end-1));
end


