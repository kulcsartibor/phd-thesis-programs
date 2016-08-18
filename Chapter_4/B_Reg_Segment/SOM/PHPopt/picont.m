function [sizes,x0,str,ts]=obj(t,x,be,flag);
global hk hk1 uk nhk1 nhk ek ek1 u kr ti

if ((flag==0))
	sizes=[0 1 1 2 0 0 1];
	x0=[0];
	str=[];
   ts=[0.2 0];
   ek=0;
   u=515;

elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
	ts=[];
elseif ((flag==3))

  
t0=0.2;
w=be(1);
y=be(2);
ek1=ek;
ek=w-y;

b0=kr*(1+t0/ti);
b1=-kr;

u=u+b0*ek+b1*ek1;

sizes=[u];
	x0=[];
	str=[];
	ts=[];

else 
	sizes=[];
	x0=[];
	str=[];
	ts=[];
end


