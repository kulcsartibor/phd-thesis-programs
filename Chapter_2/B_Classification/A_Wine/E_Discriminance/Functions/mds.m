function [positions, error, ev] = mds(d, order)
% function [positions, error] = mds(d, order)
% Compute the multidimensional scaling that produces the best positions
% given the two dimensional (symmetric) distance matrix supplied as an input.
% Return the order-dimension position data.

% Malcolm Slaney and Michele Covell, "Matlab Multidimensional Scaling Tools,"
% Interval Technical Report #2000-025, 2000 (also available at
% http://web.interval.com/papers/2000-025/).


if nargin < 2
	order = 2;
end

n = size(d,1);
A = -1/2*d.^2;
ardot = 1/n * ones(n,1) * sum(A);
asdot = 1/n * sum(A')' * ones(1,n);
adotdot = 1/n/n * sum(sum(A)) * ones(n,n);

B = A - ardot - asdot + adotdot;
[u,s,v] = svd(B);

positions = (v*s.^.5)';


% if size(positions,1) > 1
% 	plot(positions(1,:),positions(2,:),'bx');
% 	title('2D MDS Solutions');
% 	if nargin < 1
% 		hold on
% 		plot(x(1,:),x(2,:),'r+')
% 		title('2D MDS Solutions (red are test input locations)');
% 		hold off
% 	end
% 	drawnow;
% end
ev = diag(s);

error = [];
if nargout > 1
	for order=1:min(10,size(positions,1))
		error(order) = 0;
		for i=1:n
			for j=1:n
				this_d = sqrt(sum((positions(1:order,i) - ...
						positions(1:order,j)).^2));
				error(order) = error(order) + ...
					(this_d - d(i,j)).^2;
			end
		end
	end
end
positions = positions(1:order,:);