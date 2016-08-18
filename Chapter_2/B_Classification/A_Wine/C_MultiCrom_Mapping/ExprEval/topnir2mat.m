function agregate = topnir2mat(s)

agregate = s;
m = regexp(agregate,'W(\d+){4}','match');
m = unique(m);
Wl = 4776:-4:4000;

for i = 1:numel(m)	
	regexp(m{i},'\d+','match')
	idx = find(Wl == str2double(regexp(m{i},'\d+','match')));
	agregate = strrep(agregate, m{i}, ['H(:,' num2str(idx),')']);
end

% agregate = remove_barcet(agregate);
