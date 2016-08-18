function [w,C_mod,z,C_orig] = np_trnmap(X,tmax,n,epszi,epszf,Ti,Tf,lambdai,lambdaf, alfai, alfaf, deltai, deltaf, disttype, finet)

%Neighborhood preserving TRNMap= TRNMap with non metric MDS

%rand('seed',10);
N=length(X);
Esz=[];
 
% create TRN 
  [w, C_orig]=trn(X,tmax,n,epszi,epszf,Ti,Tf,lambdai,lambdaf);
  %figdrawn(X,w,C_orig,'TRN');
   
% connect the objects  
  [C_mod]=conn(w,C_orig);
  %figdrawn(X,w,C_mod,'Connected TRN');                  
          
% calculate the geodesic distance 
  if disttype=='e' %Eulclidian
      cd_geo=geo_dist(w,C_mod); %Eulclidian
  elseif disttype=='f' %transitive fuzzy similarity
      k=10; 
      maxl=4; 
      cd_geo=geo_JPfuz_dist(w,C_mod,k,maxl); % fuzzy
  end
  
% mapping (non-metric MDS)
  [z,stress,disparities] = mdscale(cd_geo,2,'criterion','stress','start','random');
  z=z';
  
% fine tuning
  if finet=='y'
    
      for i=1:tmax
        %step4
        x=X(:,floor(N*rand)+1);

        %step5
        dist=[];
        dist=sum((w-repmat(x,1,size(w,2))).^2,1)';
        [dist2,index]=sort(dist);
        bmu=index(1);

        %step6
        [rgd,rindex]=sort(cd_geo(:,bmu));
        [rgd2,rindexk]=sort(rindex);

        %step7
        alfa=alfai*((alfaf/alfai)^(i/tmax));
        delta=deltai*((deltaf/deltai)^(i/tmax));
        D=L2_distance(z,z);
        E=0;
        for k=1:n
            if mod(k,100)==0
                E=E+(D(k,bmu)-cd_geo(k,bmu))^2*exp(-((rindexk(k)-1)/delta)^2);
            end
            if k~=bmu
                z(:,k)=z(:,k)+alfa*exp(-((rindexk(k)-1)/delta)^2)*((D(k,bmu)-cd_geo(k,bmu))/D(k,bmu)).*(z(:,bmu)-z(:,k));
            end
        end
        Esz=[Esz;E];
      end
      
  end