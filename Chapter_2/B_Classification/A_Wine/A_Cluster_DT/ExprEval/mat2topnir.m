function agregate = mat2topnir(s)

agregate = s;
m = regexp(agregate,'X\(:,\d+\)','match');
m = unique(m);
Wl = 4776:-4:4000;

for i = 1:numel(m)
	idx = str2double(regexp(m{i},'\d+','match'));
	agregate = strrep(agregate, m{i}, ['W' num2str(Wl(idx))]);
end

% agregate = remove_barcet(agregate);
