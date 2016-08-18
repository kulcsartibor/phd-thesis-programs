% CLINK  Complete Link luster Analysis.
%        CLINK carries out a Complete-link cluster-analysis on the 
%        matrix D. If there are ties in the dissimilarity matrix, the 
%        dendogram may not be unique. This method should not normally be
%        used in isolation. The resulting dendogram can be constructed
%        from the results produced either by hand, or by using DENDOGRAM.
%        Matrix D is the dissimilarity matrix.
%
%        Re-written from a minitab macro by Eryl Bassett. 
%
%        See also SLINK, DENDOGRAM

disp('******************************************************')
disp('******************************************************')
disp('****                                              ****')
disp('****                 CLINK.M                      ****')
disp('****                                              ****')
disp('****        By Paul Terrill, July 1996            ****')
disp('****                                              ****')
disp('**** Performs a Complete Link Cluster Analysis on ****')
disp('**** the matrix D.                                ****')
disp('****                                              ****')
disp('******************************************************')

mx=max(max(abs(D)))+1;
k1=length(D);
D1=D+diag(mx*ones(1,k1));       % Dist matrix, but diag entries 
                                % greater than all the other entries. 

ct=1:2*k1-1;                    % Used in the loop below
i=1;                            %

%
% Perform a loop to implement the clustering algorithm
% storing the results in various vectors.
%

for j=1:k1-1
  [v,r]=min(abs(D1));           % Find smallest distance entry which 
  [v1,c]=min(v);                % corresponds to entities r and c.
  r=r(c);                       % Clustering level is v1.

  rc=max(D1(r,:),D1(c,:));      %
  D1(r,:)=mx*ones(1,k1);        %
  D1(:,r)=[mx*ones(1,k1)]';     % Form new distance matrix
  D1(c,:)=rc;                   %
  D1(:,c)=rc';                  %

  level(i)=v1;
  ent1(i)=ct(c);
  ent2(i)=ct(r);
  ent3(i)=ct(k1+i);
  ct(r)=ent3(i);
  ct(c)=ent3(i);
  i=i+1;
end

%
% Display the results
%

disp(' ')
disp('Column 1: Level')
disp('Column 2: Entity')
disp('Column 3: Joining')
disp('Column 4: To Form')
disp(' ')
res=[level' ent1' ent2' ent3'];
disp(res)
disp('To draw the resulting dendogram type')
disp('dendogram(res)')
disp(' ')

clear S1 S2 r c ct i j mx v v1 D1 rc ent1 ent2 ent3 level
