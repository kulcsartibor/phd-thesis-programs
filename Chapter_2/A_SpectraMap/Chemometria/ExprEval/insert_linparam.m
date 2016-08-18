function expr = insert_linparam(s,k)
if (nargin == 1)
	sk = 0;
else
	sk = k;
end
if sum(ismember(s,'(')) > sk
	s1 = 1;
	e1 = find_matching_paren(s,1);
	s2 = e1+2;
% 	[s2 numel(s)] (s2 > numel(s)) || 
	if (s2 > numel(s)) || (s(e1+2) == '*') || (s(e1+2) == '/') || (s(e1+2) == '\')
		expr = ['C*(' s ')'];
	elseif (s(e1+1) == '+') || (s(e1+1) == '-')
		e2 = find_matching_paren(s,s2);
		expr = ['(' insert_linparam(s(s1+1:e1-1),k) ')' s(e1+1) '(' insert_linparam(s(s2+1:e2-1),k) ')'];		
	end
else
% 	expr = s;
	expr = ['C*(' s ')'];
end



% if sum(ismember(s,'(')) > 0
% 	s1 = 1;
% 	e1 = find_matching_paren(s,1);
% 	s2 = e1+2;
% 	e2 = find_matching_paren(s,s2);
% 	
% 	if(s(e1+1) == '*') || (s(e1+1) == '/') || (s(e1+1) == '\')
% 		expr = s;
% 	elseif (s(e1+1) == '+') || (s(e1+1) == '-')
% 		expr = ['C*(' insert_linparam(s(s1+1:e1-1)) ')' s(e1+1) 'C*(' insert_linparam(s(s2+1:e2-1)) ')'];		
% 	end
% else
% 	expr = s;
% end



