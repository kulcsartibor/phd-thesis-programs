clear all
close all
abra = 1 %latens es valos valtozok
rand('seed',10) %mindig ugyanazt a (veletlen) adathalmazt fogja generalni
inter=[10000 5000 20000 3000]
cuminter=cumsum(inter);
nl=[3 3 3 3] %a latens valtozok szama az egyes szegmensekben
nx=6 %a valos valtozok szama
c=4 %a csoportok/szegmensek szama
x=[]; %adatok generalasa
z=[];
%z=rand(sum(inter),nl(1));
for i=1:nl(1)
   z=[z [(sin([1:max(cumsum(inter))]./max(cumsum(inter))*rand*100))]' ];
end    
	if abra==1
		for i=1:nl(1)
   		figure(31)
  			subplot(nl(1),1,i)
 		   plot(z(:,i))
      end
   end
 
%veletlenszeruen generaljuk a valtozok kozotti osszefuggest 
T=[];
for i=1:length(inter)
   T{i}=rand(nx,nl(i));
end    

%a valos valtozok generalasa
bb=[0 cumsum(inter)];
for i=1:length(inter)
   x=[x; (T{i}*z(max(1,bb(i)):bb(i+1),:)')' ]; %sorok = mintak
end    


x=x+randn(size(x))*0.1; %zaj hozzaadasa

if abra==1
   for i=1:nx
      figure(32)
      subplot(nx,1,i)
      plot(x(:,i))
   end
end

data=[[1:length(x)]' x]; %elso oszlopban az ido



%[[seg.lx]' [seg.rx]']