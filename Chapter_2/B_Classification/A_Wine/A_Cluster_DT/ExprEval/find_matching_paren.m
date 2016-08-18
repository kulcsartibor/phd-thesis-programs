function opos = find_matching_paren(s,p)

switch s(p)
	case '('
		j = 1;
	case ')'
		j = -1;
	otherwise
		opos = 0;
		return;
end
k = j;
i = p+j;
while(k~=0)
	if(s(i) == '(')
		k = k+1;
	elseif(s(i) == ')')
		k = k-1;
	end			
	i = i+j;
end
opos = i-j;
