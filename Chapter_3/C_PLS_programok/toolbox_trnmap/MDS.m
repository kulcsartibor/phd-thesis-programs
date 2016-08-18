function [Y, R, J, n_comps] = MDS(D, options);
% isomap projection based on the shortest paths between data


if ischar(D)
     mode = 3; 
     d_func = D; 
     N = length(feval(d_func,1)); 
elseif issparse(D) 
     mode = 2; 
     N = size(D,1); 
     if ~(N==size(D,2))
          error('D must be a square matrix'); 
     end; 
else 
     mode = 1; 
     N = size(D,1); 
     if ~(N==size(D,2))
         error('D must be a square matrix'); 
     end; 
end

if nargin < 2
    options = struct('dims',1:10,'overlay',1,'comp',1,'display',1,'dijkstra',1,'verbose',1); 
end

if ~isfield(options,'dims')
     options.dims = 1:10; 
end
if ~isfield(options,'overlay')
     options.overlay = 1; 
end
if ~isfield(options,'comp')
     options.comp = 1; 
end
if ~isfield(options,'display')
     options.display = 1; 
end
if ~isfield(options,'verbose')
     options.verbose = 1; 
end
if ~isfield(options,'landmarks')
     options.landmarks = 1:N; 
end
if ~isfield(options,'dijkstra')
     options.dijkstra = 1; 
end
dims = options.dims; 
comp = options.comp; 
overlay = options.overlay; 
displ = options.display; 
verbose = options.verbose; 
landmarks = options.landmarks; 
use_dijk = options.dijkstra;


%%%%%                   FROM ISOMAPii.M FILE                      %%%%%




%%%%% Step 3: Construct low-dimensional embeddings (Classical MDS) %%%%%
disp('Constructing low-dimensional embeddings (Classical MDS)...'); 

%%%%% Remove outliers from graph %%%%%
disp('  Checking for outliers...'); 

if ((mode == 1) & (use_dijk == 0))
     [tmp, firsts] = min(D==INF);     %% first point each point connects to
else
     [tmp, firsts] = min(D==inf);     %% first point each point connects to
end
[comps, I, J] = unique(firsts);    %% first point in each connected component
n_comps = length(comps);           %% number of connected components
size_comps = sum((repmat(firsts,n_comps,1)==((1:n_comps)'*ones(1,N)))'); 
                                   %% size of each connected component
[tmp, comp_order] = sort(size_comps);  %% sort connected components by size
comps = comps(comp_order(end:-1:1));    
size_comps = size_comps(comp_order(end:-1:1)); 
if (comp>n_comps)                
     comp=1;                              %% default: use largest component
end
Y.index = find(firsts==comps(comp)); %% list of points in relevant component
Y.index = setdiff(Y.index,find(isinf(min(D)))); %% prune points that don't connect
                                                %% to any landmarks
N = length(Y.index); 
[tmp, landmarks, land_ind] = intersect(landmarks,Y.index); 
                                       %% list of landmarks in component
nl = length(landmarks); 
D = full(D(landmarks,Y.index))'; 
disp(['    Number of connected components in graph: ' num2str(n_comps)]); 
disp(['    Embedding component ' num2str(comp) ' with ' num2str(length(Y.index)) ' points.']); 

dims = unique(min(dims,nl-1));    %% don't embed in more dimensions than landmarks-1
if (nl==N)
     opt.disp = 0; 
     [vec, val] = eigs(-.5*(D.^2 - sum(D.^2)'*ones(1,N)/N - ones(N,1)*sum(D.^2)/N + sum(sum(D.^2))/(N^2)), max(dims), 'LR', opt); 
else
     subB = -.5*(D.^2 - sum(D'.^2)'*ones(1,nl)/nl - ones(N,1)*sum(D.^2)/N+sum(sum(D.^2))/(N*nl));
     opt.disp = 0; 
     [alpha,beta] = eigs(subB'*subB, max(dims), 'LR', opt); 
     val = beta.^(1/2); 
     vec = subB*alpha*inv(val); 
     clear subB alpha beta; 
end
h = real(diag(val)); 
[foo,sorth] = sort(h);  sorth = sorth(end:-1:1); 
val = real(diag(val(sorth,sorth))); 
vec = vec(:,sorth); 

D = reshape(D,N*nl,1); 
for di = 1:length(dims)
     Y.coords{di} = real(vec(:,1:dims(di)).*(ones(N,1)*sqrt(val(1:dims(di)))'))'; 
     r2 = 1-corrcoef(reshape(real(L2_distance(Y.coords{di}, Y.coords{di}(:,land_ind))),N*nl,1),D).^2; 
     R(di) = r2(2,1); 
     if (verbose == 1)
         disp(['  Isomap on ' num2str(N) ' points with dimensionality ' num2str(dims(di)) '  --> residual variance = ' num2str(R(di))]); 
     end
end

clear D; 




