function [sizes,x0,str,ts]=sfpcc(t,x,be,flag);
global modelpar tri node par u_1 u eme em y_1 w y wt Hp Hc yk w_1
if ((flag==0))
   sizes=[0 1 1 2 0 0 1];
	x0=[0];
	str=[];
	ts=[0.2 0];
   Hp = 5;                 % prediction horizon
   Hc = 2;                 % control horizon

   wt=ones(Hp,1)*7;
   u=515;
   u_1=515;
   u=515;
   ulin=515;
   y_1=7;
   eme=0;
   em=0;
   w=7;
   y=7;
   

elseif ((flag==2))
	sizes=[0];
	x0=[];
	str=[];
	ts=[];
elseif ((flag==3))


lam=0.05;
t=0.2;  %sampling time   
w_1=w;
w=be(1);
yk=y;
y=be(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     calculation of the linear model                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%constraints on the variables

u_1=max(min(node(:,1)),u_1);
y=max(min(node(:,2)),y);
u_1=min(max(node(:,1)),u_1);
y=min(max(node(:,2)),y);




nnode=size(node,1);
T=tsearch(node(:,1),node(:,2),tri,u_1,yk) %this is the active traingular
anode=tri(T,:); %vector of the actual nodes
modindex=find(modelpar(:,1)==T)%the index of the active models

BetaT=[modelpar(modindex,3)'; modelpar(modindex,4)'; modelpar(modindex,5)']
parl=[];

modindex
parl=BetaT'*par(anode);

as=parl(2)
bs=parl(1)
cs=parl(3)



 
   %calculating the step-response of the linear model
      
   g(1)=bs;
   for i=2:Hp;
      g(i)=as*g(i-1)+bs;
   end;

  %plot(g);
   %Generation of the dynamic matrix
   SRM=g';
	for m = 1:Hc 
       A(:,m) = [zeros((m-1),1); SRM(1:1:(Hp-m+1))]; 
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 						 free run								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  p=zeros(Hp,1);
  p(1)=delunfun(u_1,y);
  for i=2:Hp;
     p(i)=delunfun(u_1,p(i-1));
  end


em=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The reference signal in the prediction horizon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=2:Hp
   wt(i-1)=wt(i);
end;
wt(Hp)=w;


%Unconstrained case (DMC Gain matrix)
Kc = inv(A'*A+lam*eye(size(A'*A)))*A';		     % 
E = wt - p-em;
dUk = Kc * E;

u = u_1 + dUk(1);

umin=min(node(:,1));
umax=max(node(:,1));

if u > umin
   u = umin+0.001;
 end                                     
 
 if u < umax                          
   u = umax-0.001;       
 end                                     
 u_1=u


 
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











