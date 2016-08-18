function [sizes,x0,str,ts]=lindmc(t,x,in,flag);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Linear DMC controller
%J. Abonyi, Delft UT, Control Lab, 1999, June
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global IRM  Kc NUMH DENH N p q spv dUk_1  u pmin em alfa T0

%Initialisation part of the S-function
if ((flag==0))
   load NUMH
   load DENH

   %Parameters
   N   = 60;          % model horizon of the convolution model
   p   = 12;          % prediction horizon
   pmin= 5;
   q   = 1;           % control horizon
   T0  = 2;           % sampling time [sec]
   lam=0.0;            %0.005;				 % move suppresion factor
   alfa=0.1;

   %S-function parameters
   sizes=[0 1 1 3 0 0 1];
	x0=[0];
	str=[];
   ts=[T0 0]; 
   
   u=7; %initial input %
   em=0;
   %initialisation of the  
   dUk_1= linspace(0,0,N-1)';            	   % input-differences             
   ur   = linspace(u,u,N)';              		% old inputs
   spv=linspace(u,u,p)';							% set-point in the prediction horizon

%calculation of the SRM (Step-response model)
NUMH
DENH
T0
   SYS = TF(NUMH,DENH,T0); % you  need the control toolbox :-(
   [IRM,T] = IMPULSE(SYS,N*2); %The impulse response model
   
   Fb=70;
   par=[0.064 0.11];
	pa=par(1)*(Fb/150)^par(2); %
%   IRM=(pa^2*(0:2:N*2).*exp(-pa*(0:2:N*2)));
%   IRM=IRM';
   
   IRM=IRM./sum(IRM); %The gain should be one (for avoiding numerical the errors) 
   SRM = cumsum(IRM);  %The step-response  model
   
   A=zeros(p,q);
   for m = 1:q 
       A(:,m) = [zeros((m-1),1); SRM(1:(p-m+1))];  %The dinamic matrix
    end
   A=A(pmin:p,:);
    
   Kc = inv(A'*A+lam*eye(size(A'*A)))*A';		     % The gain matrix of the DMC



elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
   ts=[];
   
elseif ((flag==3))
   
%inputs
sp=in(1); %the set-point signal
yk=in(2);
em=in(3)*alfa+(1-alfa)*em; %The modelling error

%the set-pont vector on the pred. horizon
spv(1:p-1) = spv(2:p);
spv(p) = sp;


for fr=1:p
	P(fr)=0;
	for m=1:fr
      for i=m+1:N
         P(fr)=P(fr)+IRM(i)*dUk_1(N-(-m+i)); %remelem -
	   end
   end
 end


for i = 1:p %effect of the previous control signals
     P(i) = 0; 
     for j = 1:i
          s1 = 0;
          for l = j+1:N
               s1 = s1 + IRM(l) * dUk_1(N+j-l);
          end
          P(i) = P(i) + s1;
     end
end



%E = linspace(sp,sp,p)' - linspace(yk,yk,p)' - P';
E = (spv(pmin:p)-linspace(em,em,p-pmin+1)') - (linspace(yk,yk,p-pmin+1)' + P(pmin:p)'); %The predicted error on the pred. hor.


dUk = Kc * E; %the DMC control rule

dUk_1(1:N-2) = dUk_1(2:N-1);
dUk_1(N-1) = dUk(1);

ut = u + dUk(1); %Receding horizon strategy

if ut<14.4600
   u=14.4600
   dUk(1)=0
end
if ut>35.4089
   u=35.4089
   dUk(1)=0
end
u = u + dUk(1);
 
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











