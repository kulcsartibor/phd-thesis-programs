function bcatpos = find_barcets(s)

bcatpos = [];
for i = 1:numel(s)
	if (s(i) == '(') || (s(i) == ')')
		bcatpos = [bcatpos; find_closing_paren(s,i)];
	end
end

bcatpos = unique(bcatpos,'rows');

