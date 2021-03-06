function ppos = find_closing_paren(s,p)
switch s(p)
	case '('
		ppos= [p find_matching_paren(s,p)];
	case ')'		
		ppos= [find_matching_paren(s,p) p];
	otherwise
		i = p;
		while((s(i) ~= '(') && (i ~= 1))
			i=i-1;
		end		
		if(i == 1) && (s(i) ~= '(')
			ppos = [1 numel(s)];
			return;
		end
		if(i == 1) && (s(i) == '(')
			ppos = [1 find_matching_paren(s,1)];
			return;
		end		
		ppos= [i find_matching_paren(s,i)];
end

