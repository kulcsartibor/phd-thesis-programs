function segment = poliseg(data,num_segments,forceplot)


% The basic algorithm works by creating a fine segmented representation then merging the lowest cost segments until only 'num_segments' remain.

%
minres=5; %minimal resolution
degree=1;

left_x       = [1 : minres : size(data,1)-1];    % Find the left x values vector for the "fine segmented representation".
right_x      = left_x + minres;                  % Find the right x values vector for the "fine segmented representation".
right_x(end) = size(data,1);                % Special case, the rightmost endpoint.
number_of_segments = length(left_x );       % Calculate the number of segments in the initial "fine segmented representation".


% Initialize the segments in the "fine segmented representation". 
for i = 1 : number_of_segments 
   
   segment(i).lx = left_x(i);
   segment(i).rx = right_x(i);
   segment(i).mc = inf;
end;

% Initialize the merge cost of the segments in the "fine segmented representation". 
for i = 1 : number_of_segments - 1
   coef = polyfit([segment(i).lx :segment(i+1).rx]',data(segment(i).lx :segment(i+1).rx),degree);
    %  best = (coef(1)*( [segment(i).lx :segment(i+1).rx]' ))+coef(2);
    best = polyval(coef,[segment(i).lx :segment(i+1).rx]' );
   segment(i).mc = sum((data([segment(i).lx :segment(i+1).rx]')-best).^2);
end;


% Keep merging the lowest cost segments until only 'num_segments' remain. 

while  length(segment) > num_segments  
   
   
   [value, i ] = min([segment(:).mc]);                              % Find the location "i", of the cheapest merge.
      
  
   if i > 1 & i < length(segment) -1								% The typical case, neither of the two segments to be merged are end segments
      
    	coef = polyfit([segment(i).lx :segment(i+2).rx]',data(segment(i).lx :segment(i+2).rx),degree);
    	%best = (coef(1)*( [segment(i).lx :segment(i+2).rx]' ))+coef(2);
        best = polyval(coef,[segment(i).lx :segment(i+2).rx]' );
        segment(i).mc = sum((data([segment(i).lx :segment(i+2).rx]')-best).^2);
	 	segment(i).rx = segment(i+1).rx;
    	segment(i+1) = [];
    	i = i - 1;
    
        coef = polyfit([segment(i).lx :segment(i+1).rx]',data(segment(i).lx :segment(i+1).rx),degree);
    	%best = (coef(1)*( [segment(i).lx :segment(i+1).rx]' ))+coef(2);
        best = polyval(coef,[segment(i).lx :segment(i+1).rx]' );    
        segment(i).mc = sum((data([segment(i).lx :segment(i+1).rx]')-best).^2);
       
   elseif i == 1                                                    % Special case: The leftmost segment must be merged.
       
	    coef = polyfit([segment(i).lx :segment(i+2).rx]',data(segment(i).lx :segment(i+2).rx),degree);
    	%best = (coef(1)*( [segment(i).lx :segment(i+2).rx]' ))+coef(2);
        best = polyval(coef,[segment(i).lx :segment(i+2).rx]' );
    	segment(i).mc = sum((data([segment(i).lx :segment(i+2).rx]')-best).^2);

	 	segment(i).rx = segment(i+1).rx;
        segment(i+1) = [];
              
   else                                                             % Special case: The rightmost segment must be merged.
     
       segment(i).rx = segment(i+1).rx;
       segment(i).mc = inf;
       segment(i+1) = [];
    
       i = i - 1;
       
       coef = polyfit([segment(i).lx :segment(i+1).rx]',data(segment(i).lx :segment(i+1).rx),degree);
       %best = (coef(1)*( [segment(i).lx :segment(i+1).rx]' ))+coef(2);
       best = polyval(coef,[segment(i).lx :segment(i+1).rx]' );
    
       segment(i).mc = sum((data([segment(i).lx :segment(i+1).rx]')-best).^2);

   end;
           
end;


%----------------------------------------------
residuals=[];

for i = 1 : length(segment) 
   
        coef = polyfit([segment(i).lx :segment(i).rx]',data(segment(i).lx :segment(i).rx),degree);
    	%best = (coef(1)*( [segment(i).lx :segment(i).rx]' ))+coef(2);
        best = polyval(coef,[segment(i).lx :segment(i).rx]' );
        residuals = [ residuals ; sum((data([segment(i).lx :segment(i).rx]')-best).^2)];
end;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% If the user passed in an extra argument, then plot the original time series, together with the segments %%%%%%%%%%%%%


if nargin > 2
    hold on;
    plot(data,'r'); 
end; 

   
    temp = [];
    for i = 1 : length(segment) 
   
      coef = polyfit([segment(i).lx :segment(i).rx]',data(segment(i).lx :segment(i).rx),degree);
      %best = (coef(1)*( [segment(i).lx :segment(i).rx]' ))+coef(2);
      best = polyval(coef,[segment(i).lx :segment(i).rx]' );
      
      segment(i).ly = best(1);
      segment(i).ry = best(end);
      segment(i).mc = residuals(i);
      
      if nargin > 2
          if mod(i,2)
            plot([segment(i).lx :segment(i).rx]', best,'k');
        else
            plot([segment(i).lx :segment(i).rx]', best,'b');
        end  
      end;
  
      temp = [temp; [segment(i).ly segment(i).ry]];
   
    end;

    
