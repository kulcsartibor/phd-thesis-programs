function [f,v,tm,ts,Pi,ft,Pq] = PCAclust(data,c,q)

lambda=0.95; %duzzasztasi parameter (ha = 1, marad az eredeti)
%Scheduling variables = t, az utolso oszlop
t=data(:,1);
%Regressors
%reg=data(:,1:end-no); %ez lesz az x
x=data(:,2:end); %ez lesz az x

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inicialize
e = 1e-2;
m=2; %sulyozo kitevo
[n,nx]=size(x); %elemszam: n = mintak szama, nx = valtozok szama 

F0 = eye(nx,nx)*det(cov(x)).^(1/nx); %"egységmátrix" a duzzasztáshoz

x1=ones(n,1); %egyes oszlop
tm = linspace(t(1),t(end),c+2);
tm=tm(2:end-1); %a kezdeti csop.kozeppontok ne legyenek az elejen es a vegen

 for j = 1 : c                       % for all clusters
      tv = t - tm(j); %a csop.kozponttol valo tavolsag
      ts(j)=((tm(2)-tm(1))/2).^2; %a szorasnegyzet kozelitese
      dt(:,j)=(2*pi*ts(j))^(-1/2)*exp(-0.5*(tv).^2/ts(j)); %az idopont j-edik csop.-ba tartozasanak val.-e (N x c)
 end;
   dt=dt/max(max(dt)); %ne legyen a val. nagyobb egynel (azer' ma')
   f0 = (dt ./ (sum(dt')'*ones(1,c))); %normalt valoszinusegek
   Pi=ones(c,1)/c; %csoport bekovetkezesenek valoszinusege
%-------------------------

%csoportositas az idoben

  f = zeros(n,c);                 % partition matrix
  iter = 0;                       % iteration counter
  while  max(max(f0-f)) > e
%for i=1:1
  iter = iter + 1;
  f = f0;
  fm = f.^m; %sulyozo kitevore: negyzetre emelve 
  sumf = sum(fm); %szumma mu
  %Calculate centers
  tm = ((fm'*t)./(sumf')); %csop.kozeppontok frissitese (38. eq)                 ?MERT VAN NEGYZETRE EMELVE?
   for j = 1 : c                       % for all clusters 
      Pi(j)=1/n*sum(fm(:,j)); %csop. a priori valoszinusege (41. eq)
      tv = t - tm(j); %csop.kozponttol valo tavolsag
      %ts(j) = std(tv.*fm(:,j)); 
      ts(j)=1/(sumf(j))*(tv'*(tv.*fm(:,j))); %szorasnegyzet szamolasa (39. eq)
      dt(:,j)=(2*pi*ts(j))^(-1/2)*exp(-0.5*(tv).^2/ts(j)); %az idopont j-edik csop.-ba tartozasanak val.-e (N x c) 
   end;
   iter
   f0 = (dt ./ (sum(dt')'*ones(1,c)));
  end %while max(max(f0-f)) > e
 
ft=f0;

%End inic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   f = zeros(n,c);                 % partition matrix
   iter=0
   
	maxhiba=[]; %lasd: PCA
  
% Iterate

	

  Pq=[];


while  max(max(f0-f)) > e
%for i=1:100

  Lel=[]; 
  
  iter = iter + 1;
  f = f0;
  fm = f; 
  sumf = sum(fm);
  

         %Calculate centers
         tm = ((fm'*t)./(sumf')); %csop.kozeppont az idoben
         v = ((fm'*x)./(sumf'*ones(1,nx ))); %csop.kozeppont az adatokban

  
  for j = 1 : c                       % for all clusters
      
      

      
      %p(c) Prior probabilities
      Pi(j)=1/n*sum(fm(:,j)); %(41. eq)

      %itt szamolod a szorasokat
      tv = t - tm(j); %csop.kozepponttol valo tavolsag az idoben
      ts(j)=(1/(sumf(j))*(tv'*(tv.*fm(:,j)))); %szorasnegyzet
      dt(:,j)=(2*pi*ts(j))^(-1/2)*exp(-0.5*(tv).^2/ts(j)); %az idopont j-edik csop.-ba tartozasanak val.-e (N x c) 


    
      %ide jon a PCA identifik. illetve hibaja 
      %itt mar jo lesz az x
      xv = x - x1*v(j,:); %csop.kozepponttol valo tavolsag az adatokban
      F(:,:,j) = ones(nx,1)*fm(:,j)'.*xv'*xv/sumf(j); %j-edik csop. fuzzy kovariancia-matrixa (53. eq)
%      F(:,:,j) = lambda*(F(:,:,j))+(1-lambda)*eye(size(F(:,:,j),1)); %duzzasztas az atloban (invertalhatosag kedveert)
		F(:,:,j) = lambda*(F(:,:,j))+(1-lambda)*F0; %duzzasztas
      
      if 1
      if iter == 1
         
         pq = q;
         [res,vs(j),lel,suml] = probPCAc(x,F(:,:,j),v(j,:),pq); %lekepezes hibaja, szoras, elhagy. saj.ertekek osszege
         if lel/suml > 0.4
            while lel/suml > 0.4 %a sajatertekek/variancia 40%-at engedjuk elvesziteni
	         	[res,vs(j),lel,suml]=probPCAc(x,F(:,:,j),v(j,:),pq); %lekepezes hibaja, szoras, elhagy. saj.ertekek osszege, a sajatertekek osszege
    	   		pq = pq+1;
     		   end
            Pq(j) = pq-1;
         else
         	Pq(j) = pq;     
         end           
         
      else
         
         pq = Pq(j);
         [res,vs(j),lel] = probPCAc(x,F(:,:,j),v(j,:),pq); %lekepezes hibaja, szoras, elhagy. saj.ertekek osszege
         if lel > 1.075*maxhiba
            while lel > 1.075*maxhiba
            	[res,vs(j),lel] = probPCAc(x,F(:,:,j),v(j,:),pq); %lekepezes hibaja, szoras, elhagy. saj.ertekek osszege
           		pq = pq+1;
        		end
            Pq(j) = pq-1;
         end
                  
      end
      
		Lel(j) = Pi(j)*lel; %az elhagyott sajatvektorok osszege sulyozva a csop. a priori val.-vel
   	end
   
%      [res,vs(j)] = probPCAc(x,F(:,:,j),v(j,:),q); %lekepezes hibaja, szoras, elhagy. saj.ertekek osszege
		      
      dr(:,j)=(2*pi*vs(j))^(-1/2)*exp(-0.5*(res)/vs(j)); %az adatpont j-edik csop.-ba tartozasanak val.-e (N x c)

%      res=sqrt(sum((res.^2)')');
%      no=nx;  
%      Pyj=1/(nx*Pi(j))*(res'*(res.*repmat(fm(:,j),1,no))); %3.6 bellow		
%      Pyj=diag(diag(Pyj));
%      dr(:,j)=((det(inv(Pyj))^(1/2))/((2*pi)^(no/2))*exp(-1/2*sum((res*inv(Pyj).*res)')'));
%  
        
   	  %Covariance matrix of the error
   	  %eF(:,:,j) = ones(nx,1)*fm(:,j)'.*res'*res/sumf(j);
        %eM(:,:,j)=diag(diag(eF(:,:,j)));
        %eM(:,:,j)=eF(:,:,j);
        %p(x,c)
%      dr(:,j)=(det(inv(eM(:,:,j)))^(1/2))/((2*pi)^(nx/2)).*exp(-1/2*sum((res*inv(eM(:,:,j)).*res)')');   
%      dr(:,j)=(vs(j)^(-1/2))/((2*pi)^(1/2))*exp(-1/2*res.*(1./vs(j)).*res);
     
%p(y,x,c)

      d(:,j) = dt(:,j).*dr(:,j)*Pi(j); %ketfajta tavolsagmertek: idoben es az adatok szintjen (hasonlo 43. eq.-hoz)
            
%      d(:,j) = dr(:,j)*Pi(j); %csak az adatok szintjen csoportositva
%      d(:,j) = dt(:,j)*Pi(j); %csak az idoben csoportositva
      
   end; %for j = 1 : c
   
	     
   iter
   f0 = (d ./ (sum(d')'*ones(1,c))); %part. matrix frissitese: val. normalasa a ket tavolsagmertekkel
   maxhiba = sum(Lel) %a megengedheto max. hiba a PCA-ban a kovetkezo iteracioban
   Pq
   
end %while  max(max(f0-f)) > e

f=f0;
fm = f;
sumf = sum(fm);


figure(1)
plot((1:length(f)),f)
title('Csop.-ba tartozás valószínûsége normálva: a normált bázisfüggvény avagy a partíciós mátrix')
figure(2)
plot((1:length(d)),d)
title('Csop.-ba tartozás valószínûsége normálás nélkül: a bázisfüggvények')
figure(3)
plot((1:length(dt)),dt ./ (sum(dt')'*ones(1,c)));
title('A szegmentálás eredménye: csop.-ba tartozás valószínûsége normálva az IDÕ szintjén')
