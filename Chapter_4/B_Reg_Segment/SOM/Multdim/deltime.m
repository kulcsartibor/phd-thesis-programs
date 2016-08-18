close all
dtime=[];
dflop=[];
tic; 
flops(0)
delaunay(rand(100,2));
dtime(1)=toc;
dflop(1)=flops;

tic; 
flops(0)
delaunay(rand(100,3)); 
dtime(2)=toc;
dflop(2)=flops;

tic; 
flops(0)
delaunay(rand(100,4)); 
dtime(3)=toc;
dflop(3)=flops;

tic; 
flops(0)
delaunay(rand(100,5)); 
dtime(4)=toc;
dflop(4)=flops;

dtime=dtime/dtime(1);
dflop=dflop/dflop(1);
plot(dtime)
hold on
plot(dflop,'r')

