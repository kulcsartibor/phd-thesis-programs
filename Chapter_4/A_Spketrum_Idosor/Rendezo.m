

%% Dátumkeresés

DTime = zeros(size(Name,1),1);
for i = 1:size(Name,1)
	DTime(i) = datenum(regexp(Name{i},'\d+_\d+','match'), 'mmdd_HHMM', 2012);
end

%% Lehúzás

X(:,3700:end) = [];
WaveN(3700:end) = [];


X = X-repmat(mean(X(:,1:1500),2),1,size(X,2));


%%

% X = X./repmat(sum(X,2),1,size(X,2));

%%

V = var(X,1,2);
LowIndex = union(find(V < 0.11),  find(V > 0.13));

X(LowIndex, :) = [];
DTime(LowIndex) = [];
V(LowIndex) = [];