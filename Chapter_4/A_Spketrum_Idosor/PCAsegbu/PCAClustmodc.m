function [f,v,tm,ts,Pi,ft,np,dt,dr] = PCAclust(data,c,q,tavmod)

lambda=1; %duzzasztasi parameter (ha = 1, marad az eredeti)
%Scheduling variables = t, az utolso oszlop
t=data(:,1)/max(data(:,1));
%Regressors
%reg=data(:,1:end-no); %ez lesz az x
x=data(:,2:end); %ez lesz az x

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inicialize
e = 1e-4;
m=2; %sulyozo kitevo
[n,nx]=size(x); %elemszam: n = mintak szama, nx = valtozok szama 

F0 = eye(nx,nx)*det(cov(x)).^(1/nx); %"egys�gm�trix" a duzzaszt�shoz
x1=ones(n,1); %egyes oszlop

if size(c,1)==1

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

else
    f0=c;
    c=size(f0,2);
end


ft=f0;

%End inic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   f = zeros(n,c);                 % partition matrix
   iter=0
   
% Iterate

while  max(max(f0-f)) > e
%for i=1:100

  Lel=[]; 
  
  iter = iter + 1;
  
  if iter == 200; 
%      break 
  end
  f = f0;
  fm = f.^m; 
  %fm = f; 
  sumf = sum(fm);
  

         %Calculate centers
         tm = ((fm'*t)./(sumf')); %csop.kozeppont az idoben
         v = ((fm'*x)./(sumf'*ones(1,nx ))); %csop.kozeppont az adatokban

  
  for j = 1 : c                       % for all clusters
      
      

      
      %p(c) Prior probabilities
      Pi(j)=1/n*sum(fm(:,j)); %(41. eq)

      %itt szamolod a szorasokat
      tv = t - tm(j); %csop.kozepponttol valo tavolsag az idoben
      ts(j)=max((1/(sumf(j))*(tv'*(tv.*fm(:,j)))),eps); %szorasnegyzet
      dt(:,j)=(2*pi*ts(j))^(-1/2)*exp(-0.5*(tv).^2/ts(j)); %az idopont j-edik csop.-ba tartozasanak val.-e (N x c) 


    
      %ide jon a PCA identifik. illetve hibaja 
      %itt mar jo lesz az x
      xv = x - x1*v(j,:); %j-edik csop.kozepponttol valo tavolsag az adatokban
      F(:,:,j) = ones(nx,1)*fm(:,j)'.*xv'*xv/sumf(j); %j-edik csop. fuzzy kovariancia-matrixa (53. eq)
	%	F(:,:,j) = lambda*(F(:,:,j))+(1-lambda)*F0; %duzzasztas
       

    
       [U s V]	= svd(F(:,:,j),0);
       dv=diag(s);
        ind=find(dv>0);
        U=U(:,ind);
        dv=dv(ind);

        %dv	= sqrt((dv));
        %dv(dv<0) = 0; %because of the rounding
        %remove the zero dv;s
        
       % s2_temp = cumsum(l(end:-1:1))./[1:data_dim]';
       % Compute total variance and fractional variance
        if q(j)<1
            min_frac=q(j);
            total_variance = sum(dv);
            frac_var = dv./total_variance;
            greater = (frac_var > min_frac);
            size_pc = sum(greater);
        else
            size_pc =q(j);
        end    
        np(j)=min(max(size_pc,2),length(dv)); %min. 2 PC are needed, 
    %  np(j)=length(dv)
    

        % Reduce the transformation matrix appropriately
        
       
        TransMat = U(:,1:np(j));
        TransMatR = U(:,np(j)+1:end);
        
      if tavmod == 0 %Q stat PCA: tav = hipersiktol valo tav.
        % Transform the data
        xvt=(xv*TransMat);
       %Residual of the projection
        res=(xvt*TransMat')-xv;
        Q=(sum([res.*res]'))';
        %Rem. variance
        vs(j)= sum(dv(np(j)+1:end))/(nx-np(j)); % LESZ A SZORAS
        %dr(:,j)=(2*pi*vs(j))^(-1/2)*exp(-0.5*(Q)/vs(j)); 
        Sm = TransMatR*diag(1./dv(np(j)+1:end))*TransMatR'; %EZ MAR AZ INVERZ
        dr(:,j)=(2*pi)^(-(nx-np(j))/2)*(prod(dv(np(j)+1:end)))^(-1/2)*exp(-1/2*sum((xv*Sm.*xv)')');
        
      elseif tavmod == 1 % T2 hipersikra vetitett adatok csopkozp-tol valo tav.
        %Reduced inverese
        Sm = TransMat*diag(1./dv(1:np(j)))*TransMat'; %EZ MAR AZ INVERZ
        dr(:,j)=(2*pi)^(-np(j)/2)*exp(-1/2*sum((xv*Sm.*xv)')'); %*(prod(dv(1:np(j))))^(-1/2)
      end
      
      dr=dr./dr;
      d(:,j) = dt(:,j).*dr(:,j)*Pi(j); %ketfajta tavolsagmertek: idoben es az adatok szintjen (hasonlo 43. eq.-hoz)

      
   end; %for j = 1 : c
      np   
	     
   iter
%   d = (d+max(max(d))*10e-10).^(1/(m-1));
  %  d=abs(real(d));
   f0 = (d ./ (sum(d')'*ones(1,c))); %part. matrix frissitese: val. normalasa a ket tavolsagmertekkel
   
   %np
   
end %while  max(max(f0-f)) > e

f=f0;
fm = f;
sumf = sum(fm);

figure(10)
plot((1:length(f))/240,f)
title('Csop.-ba tartoz�s val�sz�n�s�ge norm�lva: a norm�lt b�zisf�ggv�ny')
V=axis;
axis([0 round(length(f)/240) V(3) V(4)])
grid on
xlabel('id� (�ra)')

figure(20)
subplot(2,1,1)
plot((1:length(dr))/240,dr)
grid on
V=axis;
axis([0 round(length(dr)/240) V(3) V(4)])
subplot(2,1,2)
plot((1:length(d))/240,d)
axis([0 round(length(d)/240) V(3) V(4)])
title('Csop.-ba tartoz�s val�sz�n�s�ge norm�l�s n�lk�l: a b�zisf�ggv�nyek')
grid on
xlabel('id� (�ra)')

figure(30)
plot((1:length(dt))/240,dt ./ (sum(dt')'*ones(1,c)));
%title('A szegment�l�s eredm�nye: csop.-ba tartoz�s val�sz�n�s�ge norm�lva az ID� szintj�n')
V=axis;
axis([0 round(length(dt)/240) V(3) V(4)])
grid on
xlabel('Time [h]')