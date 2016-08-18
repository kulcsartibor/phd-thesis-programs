function agr = insert_param_value(s,val,k)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

agr = s;
idx = find(agr == 'C');
if numel(val) < numel(idx)
	val = [val; ones(numel(idx) - numel(val),1) ];
end

% numel(idx)
for i = 1:numel(idx)
	agr = [agr(1:idx(1)-1) num2str(val(i)) agr(idx(1)+1:end)];	
	idx = find(agr == 'C');
end

if nargin == 3
	agr = [num2str(k) '*(' agr ')'];
end


