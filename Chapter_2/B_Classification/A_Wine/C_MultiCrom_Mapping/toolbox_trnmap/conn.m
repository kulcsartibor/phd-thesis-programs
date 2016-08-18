function [C_mod]=conn(w,C_orig)    

%connect the separated graph alongh the shortest path

cd_geo=geo_dist(w,C_orig);

C_mod=C_orig;
[tmp, firsts] = min(cd_geo==Inf);     %% first point each point connects to
[comps, I, J] = unique(firsts);
n_comps = length(comps);
while n_comps>1
    w0=w(:,J==1);
    w1=w(:,J>1);
    w0_w1_eu=L2_distance(w0,w1);
    mindist=min(min(w0_w1_eu));       %% minimal distances between the group and the another objects
    [ind_w0 ind_w1]=find(w0_w1_eu==mindist);  %% indicies of the nearest objects in the subgroups
    w0_index=find(J==1);              %% indicies of the subgroups
    w1_index=find(J>1);
    C_mod(w0_index(ind_w0),w1_index(ind_w1))=1;
    C_mod(w1_index(ind_w1),w0_index(ind_w0))=1;
        
    cd_geo=geo_dist(w,C_mod);
    [tmp, firsts] = min(cd_geo==Inf);     %% first point each point connects to
    [comps, I, J] = unique(firsts);
    n_comps = length(comps);
end
    
    