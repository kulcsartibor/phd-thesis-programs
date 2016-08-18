function [center, U, obj_fcn] = fcv(data, cluster_n, options)
% FCV Find clusters with fuzzy c-variety clustering.
%	[CENTER, U, OBJ_FCN] = FCM(DATA, CLUSTER_N) applies fuzzy c-means
%	clustering method to a given data set. Input and output arguments of
%	this function are:
%
%		DATA: data set to be clustered; where each row is a sample data
%		CLUSTER_N: number of clusters (greater than one)
%		CENTER: final cluster centers, where each row is a center
%		U: final fuzzy partition matrix (or MF matrix)
%		OBJ_FCN: values of the objective function during iterations 
%
%	FCM(DATA, CLUSTER_N, OPTIONS) use an additional argument OPTIONS to
%	control clustering parameters, stopping criteria, and/or iteration
%	info display:
%		
%		OPTIONS(1): exponent for the partition matrix U (default: 2.0)
%		OPTIONS(2): max. number of iterations (default: 100) 
%		OPTIONS(3): min. amount of improvement (default: 1e-5)
%		OPTIONS(4): info display during iteration (default: 1)
%	
%	If any entry of OPTIONS is NaN (not a number), the default value is
%	used instead. The clustering process stops when the max. number of
%	iteration is reached, or when the objective function improvement
%	between two consecutive iteration is less than the min. amount of
%	improvement specified.
%	
%	For example:
%
%	data = rand(100, 2);
%	[center, U, obj_fcn] = fcv(data, 2);
%	plot(data(:, 1), data(:, 2), 'o');
%	maxU = max(U);
%	index1 = find(U(1, :) == maxU);
%	index2 = find(U(2, :) == maxU);
%	line(data(index1, 1), data(index1, 2), 'linestyle', '*', 'color', 'g');
%	line(data(index2, 1), data(index2, 2), 'linestyle', '*', 'color', 'r');
%
%	See also FCVDEMO, INITFCV, IRISFCV, DISTFCV, and STEPFCV.

%	Janos Abonyi and Roger Jang, 

if nargin ~= 2 & nargin ~= 3,
	error('Too many or too few input arguments!');
end

data_n = size(data, 1);
in_n = size(data, 2);

% Change the following to set default options

default_options = [2;	% exponent for the partition matrix U
		100;	% max. number of iteration
		1e-5;	% min. amount of improvement
		1];	% info display during iteration 

if nargin == 2,
	options = default_options;
else
	% If "options" is not fully specified, pad it with default values.
	if length(options) < 4,
		tmp = default_options;
		tmp(1:length(options)) = options;
		options = tmp;
	end
	% If some entries of "options" are nan's, replace them with defaults.
	nan_index = find(isnan(options)==1);
	options(nan_index) = default_options(nan_index);
	if options(1) <= 1,
		error('The exponent should be greater than 1!');
	end
end

expo = options(1);		% Exponent for U
max_iter = options(2);		% Max. iteration
min_impro = options(3);		% Min. improvement
display = options(4);		% Display info or not

obj_fcn = zeros(max_iter, 1);	% Array for objective function

U = initfcv(cluster_n, data_n);			% Initial fuzzy partition
% Main loop
for i = 1:max_iter,
	[U, center, obj_fcn(i)] = stepfcv1(data, U, cluster_n, expo);
	if display, 
		fprintf('Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
	end
	% check termination condition
	if i > 1,
		if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro, break; end,
	end
end

iter_n = i;	% Actual number of iterations 
obj_fcn(iter_n+1:max_iter) = [];
