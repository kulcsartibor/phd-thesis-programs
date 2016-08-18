function yk1=delunfun(uk,yk);

global modelpar tri node par sMap
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delaunay function evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dum1=som_normalize([yk uk yk],sMap.comp_norm);   %
yk1=par{som_bmus(sMap, [dum1(1:end-1) NaN])}'*[dum1(1:end-1) 1]';
yk1=som_denormalize([yk1 yk1 yk1],sMap.comp_norm);   %
yk1=yk1(end);

