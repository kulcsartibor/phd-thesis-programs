function e = stress_sammon(d_x,Y)

  [N dim] = size(d_x);
  
  %d_x=L2_distance(X',X');
  d_y=L2_distance(Y',Y');
  
  
  d_x_s=0;
  for i=1:N-1
      for j=i+1:N
       d_x_s=d_x_s+d_x(i,j);   
      end
  end
  
  samm_err=0;
  for i=1:N-1
      for j=i+1:N
          if d_x(i,j)~=0
            samm_err=samm_err+((d_x(i,j)-d_y(i,j))^2)/d_x(i,j);   
          end
      end
  end
  
  e=(1/d_x_s)*samm_err;
  
% diffs = d_y-d_x;
% sumDiffSq = sum(sum((diffs.^2)./d_x))/2;
% sumDissSq = sum(sum(d_x))/2;
% e = sumDiffSq/sumDissSq;
  