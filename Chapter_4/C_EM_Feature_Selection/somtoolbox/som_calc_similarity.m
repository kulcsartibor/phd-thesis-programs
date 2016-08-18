function [A] = som_calc_similarity(sM, varargin)

%SOM_ORDER_CPLANES Orders and shows the SOM component planes.
%
% P = som_order_cplanes(sM, [[argID,] value, ...])
%
%  som_order_cplanes(sM);
%  som_order_cplanes(sM,'comp',1:30,'simil',C,'pca');
%  P = som_order_cplanes(sM);
%
%  Input and output arguments ([]'s are optional): 
%   sM       (struct) map or data struct
%            (matrix) a data matrix, size * x dim
%   [argID,  (string) See below. The values which are unambiguous can
%    value]  (varies) be given without the preceeding argID.
%
%   P        (matrix) size n x * (typically n x 2), the projection coordinates
%   
% Here are the valid argument IDs and corresponding values. The values
% which are unambiguous (marked with '*') can be given without the
% preceeding argID.
%   'comp'    (vector) size 1 x n, which components to project, 1:dim by default
%   'simil'  *(string) similarity measure to use 
%                      'corr'        linear correlation between component planes
%                      'abs(corr)'   absolute value of correlation (default)
%                      'umat'        as 'abs(corr)' but calculated from U-matrices
%                      'mutu'        mutual information (not implemented yet)
%             (matrix) size n x n, a similarity matrix to be used             
%   'proj'   *(string) projection method to use: 'SOM' (default), 
%                      'pca', 'sammon', 'cca', 'order', 'ring'
%   'msize'   (vector) size of the SOM that is used for projection
%   'show'   *(string) how visualization is done: 'planes' (default), 
%                      'names', or 'none'
%   'mask'    (vector) dim x 1, the mask to use, ones(dim,1) by default
%   'comp_names' (cell array) of strings, size dim x 1, the component names
%
% The visualized objects have a callback associated with them: by
% clicking on the object, the index and name of the component are printed
% to the standard output.
% 
% See also SOM_SHOW.

% Copyright (c) 2000 by the SOM toolbox programming team.
% Contributed to SOM Toolbox on June 16th, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 120600 070601

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% sM
if isstruct(sM), 
  switch sM.type
  case 'som_map', 
    D = sM.codebook; dim = size(D,2); cnames = sM.comp_names; mask = sM.mask; 
    ismap = 1; 
  case 'som_data', 
    D = sM.data; dim = size(D,2); cnames = sM.comp_names; mask = ones(dim,1); 
    ismap = 0; 
  otherwise, error('Invalid first argument.');
  end                  
else
  D = sM; 
  dim = size(D,2); mask = ones(dim,1);
  cnames = cell(dim,1); 
  for i = 1:dim, cnames{i} = sprintf('Variable%d',i); end
  ismap = 0; 
end

% defaults
comps = 1:dim; 
simil = 'abs(corr)';
proj = 'SOM'; 
show = 'planes'; 
mapsize = NaN;

% varargin
i=1;
while i<=length(varargin),
  argok = 1;
  if ischar(varargin{i}),
    switch varargin{i},
     % argument IDs
     case 'mask',       i=i+1; mask = varargin{i};
     case 'comp_names', i=i+1; cnames = varargin{i};
     case 'comp',       i=i+1; comps = varargin{i}; 
     case 'proj',       i=i+1; proj = varargin{i}; 
     case 'show',       i=i+1; show = varargin{i}; 
     case 'simil',      i=i+1; simil = varargin{i}; 
     case 'msize',      i=i+1; mapsize = varargin{i};
     % unambiguous values
     case {'corr','abs(corr)','umat','mutu'}, simil = varargin{i}; 
     case {'SOM','pca','sammon','cca','order','ring'}, proj = varargin{i}; 
     case {'planes','names','none'}, show = varargin{i}; 
     otherwise argok=0;
    end
  else
    argok = 0;
  end
  if ~argok,
    disp(['(som_order_cplanes) Ignoring invalid argument #' num2str(i+1)]);
  end
  i = i+1;
end

if strcmp(show,'planes') & ~ismap, 
  warning('Given data is not a map: using ''names'' visualization.'); 
  show = 'names'; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% similarity matrix

%fprintf(1,'Calculating similarity matrix\n');

% use U-matrix
if strcmp(simil,'umat'), 
  if ~ismap, error('Given data is not a map: cannot use U-matrix similarity.'); end
  U = som_umat(sM);
  D = zeros(prod(size(U)),dim); 
  m = zeros(dim,1);
  for i=1:dim, m=m*0; m(i)=1; U = som_umat(sM,'mask',m); D(:,i) = U(:); end
end

% components
D = D(:,comps);
cnames = cnames(comps);
mask = mask(comps);
dim = length(comps);
  
% similarity matrix
if ischar(simil), 
  switch simil, 
  case {'corr','abs(corr)','umat'}, 
    A = zeros(dim);
    me = zeros(1,dim);
    for i=1:dim, 
        me(i) = mean(D(isfinite(D(:,i)),i)); D(:,i) = D(:,i) - me(i); 
    end  
    for i=1:dim, 
      for j=i:dim, 
        c = D(:,i).*D(:,j); c = c(isfinite(c));
        A(i,j) = sum(c)/length(c); A(j,i) = A(i,j); 
      end
    end
    s = diag(A); 
    A = A./sqrt(s*s');
    switch simil, 
    case {'abs(corr)','umat'}, A = abs(A); 
    case 'corr', A = A + 1; 
    end
  case 'mutu', 
    error('Mutual information not implemented yet.');
  end
else
  A = simil; 
end

return;