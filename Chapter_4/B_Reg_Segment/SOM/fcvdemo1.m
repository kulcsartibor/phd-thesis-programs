slope=rand(2,1)*10;

slope =[0 0];
data=[];
   x=rand; 

   for i=1:50
     data(i,:)=[x+rand*0.1 x+rand*0.1];
  end;
   x=rand; 
  for i=51:100
     data(i,:)=[x+rand*0.1 x+rand*0.1];
  end;

plot(data(:, 1), data(:, 2), 'o');

[center, U, obj_fcn] = fcv1(data, 2);
plot(data(:, 1), data(:, 2), 'o');
maxU = max(U);
index1 = find(U(1, :) == maxU);
index2 = find(U(2, :) == maxU);
line(data(index1, 1), data(index1, 2), 'linestyle', '*', 'color', 'g');
line(data(index2, 1), data(index2, 2), 'linestyle', '*', 'color', 'r');
   
   