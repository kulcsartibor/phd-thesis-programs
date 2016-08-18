function [fuzdist]=JPfuz_dist(w,C,k,maxl)

   N=length(w);
   d_eu=L2_distance(w,w);
   Gk = knngraph2(d_eu,k,'k');
   Gk=max(Gk,diag(max(diag(Gk),1)));
   sim=zeros(N,N);
   alfa=0.2;
   for i=1:N
       for j=i+1:N
           seta=[i];
           setb=[j];
           for l=1:maxl %%tovagyûrûzik
               neigha=sum(Gk(:,seta),2)>0;
               neighb=sum(Gk(:,setb),2)>0;
               sim(i,j)=(1-alfa)*sim(i,j)+alfa*((sum(min(neigha,neighb)))/sum(max(neigha,neighb))); %+neigha(j,1)+neighb(i,1)
               seta=find(neigha==1);
               setb=find(neighb==1);
           end
       end
   end
   sim=max(sim,sim');
   fuzdist=1-sim;