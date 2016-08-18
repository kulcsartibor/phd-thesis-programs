function mds_metr_err = stress_metr_mds(d_x,Y)

  [N dim] = size(d_x);
  
  %d_x=L2_distance(X',X');
  d_y=L2_distance(Y',Y');
   
  mds_metr_err=0;
  for i=1:N-1
      for j=i+1:N
       mds_metr_err=mds_metr_err+(d_x(i,j)-d_y(i,j))^2;   
      end
  end
  
  
  