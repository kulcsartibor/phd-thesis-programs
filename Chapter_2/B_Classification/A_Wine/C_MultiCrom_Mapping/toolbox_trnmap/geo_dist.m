function [cd_geo]=geo_dist(w,C)

% Compute the geodesic distances between the points(w) regarding to the
% connectivity graf (C).
% dvfa

n=length(w);
cd_eu=L2_distance(w,w);
cd_eu=cd_eu.*C;
cd_eu=sparse(cd_eu);
cd_geo = dijkstra(cd_eu ,1:n);