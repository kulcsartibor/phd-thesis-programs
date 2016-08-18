function [f, g]=apid_hf(x)
global e0 e1 e2 kr ti error w;

  kr=x(1);
  ti=x(2);
  [kr ti]
  sim('popt1',250,[]);
   f=error
   g(1)=-x(1);
	g(2)=-x(2);
	g(3)=x(1)-20;
	g(4)=x(2)-20;
	e0=0;
	e1=0;
	u=0;
   w=7;

clear global error;
