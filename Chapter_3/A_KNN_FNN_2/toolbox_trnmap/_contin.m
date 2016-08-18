function Mc = contin(kn, X, Y, d_X, d_Y)

%compute the continuity of the mapping
%dfva

N=length(X);

% d_X=L2_distance(X,X);
% d_Y=L2_distance(Y,Y);

[SX,IX]=sort(d_X);
[SY,IY]=sort(d_Y);

V=zeros(kn,N);
for i=1:N
    for j=2:kn+1
        if find(IY(:,i)==IX(j,i))>kn+1
            V(j,i)=IX(j,i);
        end
    end
end

V=sort(V,'descend');

Mcszum=0;
for i=1:N
    for j=1:kn
        if V(j,i)>0
            rij=find(IY(:,i)==V(j,i));
            Mcszum=Mcszum+(rij-kn);
        end
    end
end

Mc=1-(2/(N*kn*(2*N-3*kn-1)))*Mcszum;
