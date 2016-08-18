function Gk = knngraph2(DM,kepsz, option)

% DM: distance matrix
% kepsz: value for k or epsz
% option: 'k' or 'epsz'


DM(DM==0)=Inf;
Gk=zeros(length(DM),length(DM));

if option=='k'
    for i=1:length(DM)
        [dum,ind]=sort(DM(i,:));
        for j=1:kepsz
           % if C(i,ind(j))==1
                Gk(i,ind(j))=1;
           % end
        end
    end
end

if option=='epsz'
    Gk(DM<=kepsz)=1;
end

Gk=max(Gk, Gk');

