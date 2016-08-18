function [sizes,x0,str,ts]=obj(t,x,be,flag);

if ((flag==0))
	sizes=[0 1 1 2 0 0 1];
	x0=[0];
	str=[];
   ts=[0.4 0];
   ek=0;
 
elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
	ts=[];
elseif ((flag==3))

  
w=be(1);
y=be(2);
ek=w-y;

sizes=[ek];
	x0=[];
	str=[];
	ts=[];

else 
	sizes=[];
	x0=[];
	str=[];
	ts=[];
end


