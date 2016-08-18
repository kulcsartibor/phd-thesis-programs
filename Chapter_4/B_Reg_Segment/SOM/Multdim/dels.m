function [sizes,x0,str,ts]=obj(t,x,be,flag);
global modelpar tri node par yk u y

if ((flag==0))
	sizes=[0 1 1 2 0 0 1];
	x0=[0];
	str=[];
   ts=[0.2 0];
   yk=7;
   u=515;
   y=7;

elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
	ts=[];
elseif ((flag==3))
   
      
u=be(1);
y=be(2);
   if y<6.9
      y=6.9;
    end

yk=delunfun(u,y);


sizes=[yk];
	x0=[];
	str=[];
	ts=[];

else 
	sizes=[];
	x0=[];
	str=[];
	ts=[];
end


