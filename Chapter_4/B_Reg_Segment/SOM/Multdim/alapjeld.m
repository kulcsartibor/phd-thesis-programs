function [sizes,x0,str,ts]=obj(t,x,be,flag);
global ai jel aw

if ((flag==0))
	sizes=[0 1 1 0 0 0 1];
	x0=[0];
	str=[];
   ts=[0.4 0];
   ai=0;
   aw=7;
   jel=1;
   

elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
	ts=[];
elseif ((flag==3))


ai=ai+1;
   if ai==150;
          if aw==10
            jel=-1;
	  end
          if aw==7
            jel=1;
	  end
	  aw=aw+jel*0.5;
	  ai=0;
   end	

sizes=[aw];
	x0=[];
	str=[];
	ts=[];

else 
	sizes=[];
	x0=[];
	str=[];
	ts=[];
end
