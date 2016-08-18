%Function to generate pieciwise linear model
global modelpar tri node par vpHs, vF

ntri=size(tri,1);
param=[];
for T=1:ntri;
   anode=tri(T,:); %vector of the actual nodes
   modindex=find(modelpar(:,1)==T);
   Beta=modelpar(modindex,3:end);
   param=[param; par(anode)'*Beta];
end

stab=find((param(:,2)<1)&(param(:,2)>0)&(param(:,1)>0));


figure(2) %plot the triangules

hold on
for i=1:ntri
   plot([node(tri(i,1),1) node(tri(i,2),1)], [node(tri(i,1),2) node(tri(i,2),2)],'k-.')
   plot([node(tri(i,1),1) node(tri(i,3),1)], [node(tri(i,1),2) node(tri(i,3),2)],'k-.')
   plot([node(tri(i,2),1) node(tri(i,3),1)], [node(tri(i,2),2) node(tri(i,3),2)],'k-.')
end

nstab=size(stab,1);
for j=1:nstab
   i=stab(j);
   plot([node(tri(i,1),1) node(tri(i,2),1)], [node(tri(i,1),2) node(tri(i,2),2)],'k-')
   plot([node(tri(i,1),1) node(tri(i,3),1)], [node(tri(i,1),2) node(tri(i,3),2)],'k-')
   plot([node(tri(i,2),1) node(tri(i,3),1)], [node(tri(i,2),2) node(tri(i,3),2)],'k-')
end

%plot the steady-state
alfa=[];
for j=1:nstab
   i=stab(j);
   vect=node(tri(i,:),:); %The matrix of the coordinates 
   vect=vect'; %the first index is the domain (u,y)
   %stac ys=bs*us+cs from y(k+1)=a*y(k)+b*u(k)+c
   bs=param(i,1)/(1-param(i,2));
   cs=param(i,3)/(1-param(i,2));
   alfa1=(bs*vect(1,2)+cs-vect(2,2))/(vect(2,1)-vect(2,2)-bs*vect(1,1)+bs*vect(1,2)); %1-2
   alfa2=(bs*vect(1,3)+cs-vect(2,3))/(vect(2,1)-vect(2,3)-bs*vect(1,1)+bs*vect(1,3)); %1-3
   alfa3=(bs*vect(1,3)+cs-vect(2,3))/(vect(2,2)-vect(2,3)-bs*vect(1,2)+bs*vect(1,3)); %2-3
   alfa=[alfa; [alfa1 alfa2 alfa3]];
   if (0<alfa1)&(alfa1<1)&(0<alfa2)&(alfa2<1)
      cord1=vect(:,1)*alfa1+vect(:,2)*(1-alfa1);
      cord2=vect(:,1)*alfa2+vect(:,3)*(1-alfa2);
      plot([cord1(1) cord2(1) ], [cord1(2) cord2(2) ],'k--');
   end
   if (0<alfa1)&(alfa1<1)&(0<alfa3)&(alfa3<1)
      cord1=vect(:,1)*alfa1+vect(:,2)*(1-alfa1);
      cord2=vect(:,2)*alfa3+vect(:,3)*(1-alfa3);
      plot([cord1(1) cord2(1) ], [cord1(2) cord2(2) ],'k--');
   end
   if (0<alfa2)&(alfa2<1)&(0<alfa3)&(alfa3<1)
      cord1=vect(:,1)*alfa2+vect(:,3)*(1-alfa2);
      cord2=vect(:,2)*alfa3+vect(:,3)*(1-alfa3);
      plot([cord1(1) cord2(1) ], [cord1(2) cord2(2) ],'k--');
   end
   
   end
      
end
 
 plot(vF(1:end-10),vpHs(1:end-10),'k');
 xlabel('F_{NaOH}(k)');
 ylabel('pH(k)');

 






%plot(data(:,1),data(:,2),'rd');
hold off

condes=0
if condes
   
Kdim=[];
Tdim=[];
Tauc=1.5;

for T=1:ntri;
   B=param(T,1);
   A=[1 -param(T,2)];
   SYS = TF(B,A,0.2) 
   SYSc=d2c(SYS);
   [NUM,DEN,TS] = TFDATA(SYSc);
   K=NUM{1}(2)./DEN{1}(2);
   Tau=DEN{1}(1)./DEN{1}(2);
   Kc=1/K*Tau/Tauc;
   Ti=Tau;
   Kdim=[Kdim Kc];
   Tdim=[Tdim Ti];
end
end   