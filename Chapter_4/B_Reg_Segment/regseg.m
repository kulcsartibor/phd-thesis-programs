function [segment, Ym] = regseg(Y,X,num_segments,forceplot)


% The basic algorithm works by creating a fine segmented representation then merging the lowest cost segments until only 'num_segments' remain.
minres=50; %minimal resolution

%
[N,n]=size(X);%itt n=n+1, ui. az utolso oszlopban 1-van


%

left_x       = [1 : minres : N-1];          % Find the left x values vector for the "fine segmented representation".
right_x      = left_x + minres;             % Find the right x values vector for the "fine segmented representation".
right_x(end) = N;                           % Special case, the rightmost endpoint.
number_of_segments = length(left_x );       % Calculate the number of segments in the initial "fine segmented representation".


% Initialize the segments in the "fine segmented representation". 
for i = 1 : number_of_segments 
   segment(i).lx = left_x(i);
   segment(i).rx = right_x(i);
   segment(i).mc = inf; %Merge cost
end;

% Initialize the merge cost of the segments in the "fine segmented representation". 
for i = 1 : number_of_segments - 1
    index=[segment(i).lx :segment(i+1).rx];%minden a jobb oldali syomsyeddal kozosen ertelmezett
% 	[size(X(index,:)) size(Y(index,:))]
    segment(i).P = X(index,:)\Y(index,:); 
    segment(i).mc = mean( (X(index,:)*segment(i).P - Y(index,:)).^2); %mean van, nem atlag, ez nem bunteti a hosszu szegmenseket
end;


% Keep merging the lowest cost segments until only 'num_segments' remain. 
while  length(segment) > num_segments  
   
   [value, i ] = min([segment(:).mc]);                              % Find the location "i", of the cheapest merge.
      
  
   if i > 1 & i < length(segment) -1								% The typical case, neither of the two segments to be merged are end segments
      
        index=[segment(i).lx :segment(i+2).rx]; %mivel osszevonjuk, az index i+2
    	segment(i).P = X(index,:)\Y(index,:); 
        segment(i).mc = mean( (X(index,:)*segment(i).P - Y(index,:)).^2); %mean van, nem atlag, ez nem bunteti a hosszu szegmenseket
 	 	segment(i).rx = segment(i+1).rx; %modositjuk a hatatrokat
    	segment(i+1) = [];
    	i = i - 1;
        %Uj szegmens jott letre, igy az elotte levo szegmens merging
        %costjat is frissiteni kell 
        index=[segment(i).lx :segment(i+1).rx];
    	segment(i).P = X(index,:)\Y(index,:); 
        segment(i).mc = mean( (X(index,:)*segment(i).P - Y(index,:)).^2); %mean van, nem atlag, ez nem bunteti a hosszu szegmenseket
       
   elseif i == 1        % Special case: az elso, baloldalo szegmenst kell osszevonni
       
	    index=[segment(i).lx :segment(i+2).rx]; %mivel osszevonjuk, az index i+2
    	segment(i).P = X(index,:)\Y(index,:); 
        segment(i).mc = mean( (X(index,:)*segment(i).P - Y(index,:)).^2); %mean van, nem atlag, ez nem bunteti a hosszu szegmenseket
 	 	segment(i).rx = segment(i+1).rx; %modositjuk a hatatrokat
    	segment(i+1) = [];
              
   else  % Special case: az utolso szegmenst kell osszevonni
     
       segment(i).rx = segment(i+1).rx;
       segment(i).mc = inf;
       segment(i+1) = [];
    
       i = i - 1;
       
       index=[segment(i).lx :segment(i+1).rx];
       segment(i).P = X(index,:)\Y(index,:); 
       segment(i).mc = mean( (X(index,:)*segment(i).P - Y(index,:)).^2);
   end;
           
end;


%Final model, itt mar nem az összevonasi modellek es koltsegek szerepelnek!!!!!
Ym=[];
for i = 1 : length(segment) -1 
        index=[segment(i).lx :segment(i).rx]; %ITT mar csak a szegmens hatarai vannak
         segment(i).M = X(index,:)\Y(index,:); %a szegmens vegso modellje
         segment(i).Ym = X(index,:)*segment(i).P; %becsult kimenet a szegmensre
         Ym= [ Ym; segment(i).Ym];
         segment(i).mse = mean(segment(i).Ym - Y(index,:).^2);
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% If the user passed in an extra argument, then plot the original time series, together with the segments %%%%%%%%%%%%%


if nargin > 2
    hold on;
    plot(Ym,'Color',[1 0.75 0],'LineWidth',2); 
    plot(Y,'Color',[0 0 0]); 
% 	plot(Y,'k.','MarkerSize',4); 
%     plot(Ym,'k+','MarkerSize',4); 
    maxy=1;
    miny=0;
    for i = 1 : length(segment) 
        line([segment(i).lx segment(i).lx],[miny maxy])
    end    
end; 

   
  

    
