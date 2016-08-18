function [cd_geo_JPfuz]=geo_JPfuz_dist(w,C,k,maxl)

% Compute the geodesic distances between the points(w) regarding to the
% connectivity graf (C).
% dfva

n=length(w);
cd_JPfuz=JPfuz_dist(w,C,k,maxl);
cd_JPfuz=cd_JPfuz.*C;
cd_JPfuz=sparse(cd_JPfuz);
cd_geo_JPfuz = dijkstra(cd_JPfuz ,1:n);