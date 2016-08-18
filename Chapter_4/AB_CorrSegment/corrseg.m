function [segment, frob] = corrseg(data,num_segments)
% close all
% The basic algorithm works by creating a fine segmented representation then merging the lowest cost segments until only 'num_segments' remain.
minres=floor(length(data)/500); %minimal resolution

left_x       = [1 : minres : size(data,1)-1];    % Find the left x values vector for the "fine segmented representation".
right_x      = left_x + minres-1;                  % Find the right x values vector for the "fine segmented representation".
right_x(end) = size(data,1);                     % Special case, the rightmost endpoint.
number_of_segments = length(left_x );            % Calculate the number of segments in the initial "fine segmented representation".
frob = zeros(1,number_of_segments-1);
% segment(number_of_segments).lx = 0;
% segment(number_of_segments).rx = 0;
% segment(number_of_segments).corr = [];
% segment(number_of_segments).cost = inf;

% Initialize the segments in the "fine segmented representation". 
for i = 1 : number_of_segments 
	segment(i).lx = left_x(i);
	segment(i).rx = right_x(i);
	segment(i).corr = corrcoef(data(segment(i).lx :segment(i).rx,:));
	segment(i).cost = inf;
% 	frob(i) = norm(segment(i).corr,'fro');
end;
for i = 1 : number_of_segments -1
	segment(i).cost = frobenius(segment(i).corr, segment(i+1).corr );
	frob(i) = segment(i).cost;
end;

% figure
% plot(sort(frob),'*')
% figure('Name','Spectra Maps','NumberTitle','off', 'Color',[1 1 1]);
while  length(segment) > num_segments
	subplot(2,2,[1 2])
	ser = [segment(:).cost];
	[~, i ] = min(ser);
	if 0
	% 	hold off
		plot(sort(ser),'.')
	% 	hold on
	% 	plot([i],ser(i),'r*')
		subplot(2,2,3)
		surf(segment(i).corr,'EdgeColor','None')
		view(2)
		axis('square')
		set(gca,'xtick',[])
		set(gca,'ytick',[])
		set(gca,'ztick',[])
		subplot(2,2,4)
		surf(segment(i+1).corr,'EdgeColor','None')
		view(2)
		axis('square')
		set(gca,'xtick',[])
		set(gca,'ytick',[])
		set(gca,'ztick',[])
		pause
	end
	
	
	[~, i ] = min([segment(:).cost]);
	segment(i).rx = segment(i+1).rx;
	segment(i+1) = [];
	segment(i).corr = corrcoef(data(segment(i).lx :segment(i).rx,:));
	
	if i > 1
		segment(i-1).cost = frobenius(segment(i-1).corr, segment(i).corr );
	end
	
	if i < length(segment)
		segment(i).cost = frobenius(segment(i).corr, segment(i+1).corr );
	end
	
	if i == length(segment)
		segment(i).cost = inf;
	end
end

return


