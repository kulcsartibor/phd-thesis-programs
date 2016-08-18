global NUM DEN us alfa
sim('linid'); %simulation 

	y=simout(:,2);
   u=simout(:,1);
   us=mean(u);
   ys=mean(y);

   u=dtrend(u);
   y=dtrend(y);

	Delay=1;
   Tident=1;
   TH = arx([y u],[1 1 0]); 
   [A,B,C,D,F]=TH2POLY(TH);   
   
   
   SYS = TF(B,A,0.2) 
   SYSc=d2c(SYS);
   [NUM,DEN,TS] = TFDATA(SYSc);
   K=NUM{1}(2)./DEN{1}(2);
   Tau=DEN{1}(1)./DEN{1}(2);
   
   Tauc=1.25;
   
   Kc=1/K*Tau/Tauc
   Ti=Tau
   
   
%   K=4.7;
%  T=2.1;
   t0=0.2;
   q0=Kc;
   q1=-Kc*(1-t0/Ti)

   
   alfa=0.95;
   NUM=[A];
   DEN=[B]
   
   