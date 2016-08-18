function [sizes,x0,str,ts]=obj(t,x,be,flag);
global modelpar tri node par  w alfa em em1 alfa2

if ((flag==0))
	sizes=[0 1 1 3 0 0 1];
	x0=[0];
	str=[];
   ts=[0.2 0];
   u=515;
   w=7;
   alfa=0.6;
   alfa2=0.6;
   em=0;
   em1=0;

elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
	ts=[];
elseif ((flag==3))
 
wk=w;   
w=alfa*be(1)+(1-alfa)*wk;
em1=em;
em=alfa2*be(3)+(1-alfa2)*em1;
y=be(2);

u=invdelunfun(w-em,y);

if isempty(u)|abs(u)==inf|u==NaN %There is no solution, because of the steps
	if w>y   
      u=522;
   else
     u=512;
   end
end

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


