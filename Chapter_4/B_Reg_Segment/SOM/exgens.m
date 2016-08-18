function [sizes,x0,str,ts]=obj(t,x,be,flag);
global i val frec frec0 count vF vpHs

if ((flag==0))
	sizes=[0 1 1 0 0 0 1];
	x0=[0];
	str=[];
   ts=[0.2 0];
   frec=(2/0.2)*0.75;
   frec0=1;
   val=7;
   count=1;
   i=1;
   rand('state',0);
   
elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
	ts=[];
elseif ((flag==3))

count=count+1;
if count>i
   i=round(rand*2*frec+frec0); %lenght of this signal
   val=rand*(522-512)+512;   (10.75-6.75)+6.75; %; 
   count=0;
end
   
sizes=[val];
	x0=[];
	str=[];
	ts=[];

else 
	sizes=[];
	x0=[];
	str=[];
	ts=[];
end
