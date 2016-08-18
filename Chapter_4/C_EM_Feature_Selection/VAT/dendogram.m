function sc=dendogram(X)
% DENDOGRAM Generates a dendogram from the reults produced by a cluster
%           analysis.
%
%           Matrix X must take the following form.
%             Column 1: Level of new link
%             Column 2: Entity no x
%             Column 3: joining entity no y
%             Column 4: To form entity no z
%             Where the entity numbers take the values 1 to number of
%             entities, and the new entity numbers carry on increasing
%             numerically.
%
%           EXAMPLE:
%
%           X =
%
%               2.1     1     2     6
%               2.8     4     5     7
%               4.3     3     7     8
%               5.9     6     8     9

%           Written by Paul Terrill, July 1996.
%           E-mail: pkt1@ukc.ac.uk

% Notes:
% sc holds position of entities along the x-axis
% ct holds x co-ordinate used for plotting
% yc holds y coord according to level of joins

[m,n]=size(X);

% Firstly sort out the order that the entities appear on
% the x-axis and stor in sc

sc=X(m,[2 3]);                   
for i=1:m-1
  j=m-i;
  l=length(sc);
  sci=find(sc==X(j,4));
  sc(sci)=[];
  sc=[sc(1:sci-1) X(j,[2 3]) sc(sci:l-1)];
end

rg=max(X(:,1))-min(X(:,1));
ymin=min(X(:,1))-(rg)/10;
ymax=max(X(:,1))+(rg)/10;
clf
%axis([0 m+1 ymin ymax])                    % Set axis ranges
set(gca,'XTick',[1:m+1])                   % Set position of X tic marks
set(gca,'XTickLabels',sc(1:m+1))           % Set x tic labels 
hold on

yc=ymin*ones(1,m+1);                       % Set initial yc as x-axis
ct=1:m+1;                                  % Set initial x co-ord for plotting
for i=1:m
  y10=yc(X(i,2));
  y20=yc(X(i,3));
  y2=X(i,1);                               % y2 = level of join
  x1=ct(find(ct(X(i,2))==sc));             % Find plotting co-ords for
  x2=ct(find(ct(X(i,3))==sc));             % the entities joined
  plot([x1 x1],[y10 y2]);                  % Plot first vertical line
  plot([x2 x2],[y20 y2]);                  % Plot second vertical line
  plot([x1 x2],[y2 y2]);                   % Plot horizontal connecting line
  ct=[ct (x1+x2+0.0001)/2];                %
  sc=[sc (x1+x2+0.0001)/2];                % Update ct, sc and yc
  yc=[yc y2];                              %
end
ylabel('Level')
