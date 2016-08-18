function [Mt,Mc,V,U] = trustcont(kn, X, Y, d_X, d_Y)

%compute the trustworthiness of the mapping
%dfva

N=size(X,1);

% d_X=L2_distance(X,X);
%d_Y=L2_distance(Y,Y);

[SX,IX]=sort(d_X);
[SY,IY]=sort(d_Y);

U=zeros(kn,N);
V=zeros(kn,N);
for i=1:N
%     for j=2:kn+1
%         if find(IX(:,i)==IY(j,i))>kn+1
%             U(j,i)=IY(j,i);
%         end
%         if find(IY(:,i)==IX(j,i))>kn+1
%             V(j,i)=IX(j,i);
%         end
%     end
   temp1= setdiff(IY(2:kn+1,i),IX(2:kn+1,i));
   temp2= setdiff(IX(2:kn+1,i),IY(2:kn+1,i));
   U(1:length(temp1),i)=temp1;
   V(1:length(temp2),i)=temp2;
end

%U={}
%for i=1:N
%   U{i}=setdiff(IY(2:kn+1,i),IX(2:kn+1,i))
%end

%U=sort(U,'descend');
%V=sort(V,'descend');

Mt=0;
Mc=0;
Mtszum=0;
Mcszum=0;
for i=1:N
    for j=1:kn
        if U(j,i)>0
            rijU=find(IX(:,i)==U(j,i))-1;
            Mtszum=Mtszum+(rijU-kn);
            if rijU<kn
%                 rijU
            end
        end
        if V(j,i)>0
            rijV=find(IY(:,i)==V(j,i))-1;
            Mcszum=Mcszum+(rijV-kn);
        end
    end
end

A=2/(N*kn*(2*N-3*kn-1));
Mt=1-A*Mtszum;
Mc=1-A*Mcszum;

if Mt>1
    %U
end
if Mc>1
    %sV
end
    
