function [sizes,x0,str,ts]=obj(t,x,be,flag);
global i jel w

if ((flag==0))
	sizes=[0 1 1 0 0 0 1];
	x0=[0];
	str=[];
   ts=[0.4 0];
   i=0;
   w=6.5;
   jel=1;
   

elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
	ts=[];
elseif ((flag==3))


i=i+1;
   if i==150;
          if w==10.5
            jel=-1;
	  end
          if w==6.5
            jel=1;
	  end
	  w=w+jel*0.5;
	  i=0;
   end	

sizes=[w];
	x0=[];
	str=[];
	ts=[];

else 
	sizes=[];
	x0=[];
	str=[];
	ts=[];
end
