function [w,C,z] = gnlp(X,tmax,n,epszi,epszf,Ti,Tf,lambdai,lambdaf, alfai, alfaf, deltai, deltaf,K)

rand('seed',0);
%Initialization
[dim N]=size(X); % dimension and number of the input data

%step1
[w,C] = nglearning(X,tmax,n,epszi,epszf,Ti,Tf,lambdai,lambdaf,K);
[C]=conn(w,C);
cd_geo=geo_dist(w,C);


Esz=[];

    
    %step2
    %not necessary

    %step3
    z=rand(2,n);
    
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