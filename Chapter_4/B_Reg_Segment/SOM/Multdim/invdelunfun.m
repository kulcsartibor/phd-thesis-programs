function uk=delunfun(yk1,yk);

global modelpar tri node par
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inverse of a Delaunay function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nnode=size(node,1);
nweight=size(modelpar,1);
ntri=size(tri,1);
yk1=max(min(node(:,2)),yk1);
yk=max(min(node(:,2)),yk);
yk1=min(max(node(:,2)),yk1);
yk=min(max(node(:,2)),yk);




%partial defuzzyfication
pdmodelpar=([modelpar(:,1:3) modelpar(:,4)*yk+modelpar(:,5)]);

%generation the local partial defuzzified models
dmodel=zeros(ntri,2); %;
  
 for i=1:ntri
     anode=tri(i,:);      					%the nodes of this triangule 
     
    modindex=find(pdmodelpar(:,1)==i); 	%the set of the models

    dmodel(i,:)=[pdmodelpar( modindex,3)'*par(anode) pdmodelpar( modindex,4)'*par(anode)];
 end
      
%Generate the possible inverse
pinverse=(yk1*ones(ntri,1)-dmodel(:,2))./dmodel(:,1);

%Check the solution
T=tsearch(node(:,1),node(:,2),tri,pinverse,yk*ones(ntri,1)); %these are the active traingulars

%Only that solution is good where we obtained 
rt=1:ntri;


%if there is more solution than one, take the minimum
uk=min(pinverse(find(T==rt')));
