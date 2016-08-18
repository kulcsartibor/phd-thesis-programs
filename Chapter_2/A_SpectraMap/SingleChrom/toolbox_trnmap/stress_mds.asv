function e = stress_mds(d_x,Y,metric)

%Compute the Mteric and non-metric stress function of MDS
%dfva

d_y=L2_distance(Y',Y');
  
if metric=='y'
    %metric
    % The Euclidean norm of the differences between the distances and the
    % dissimilarities, normalized by the Euclidean norm of the dissimilarities.
    diffs = d_y-d_x;
    sumDiffSq = sum(sum(diffs.^2))/2;
    sumDissSq = sum(sum(d_x.^2))/2;
    e = sumDiffSq./sumDissSq;
elseif metric=='n'
    %nonmetric
    % The Euclidean norm of the differences between the distances and the
    % disparities, normalized by the Euclidean norm of the distances.
    disparities = lsqisotonic(d_x, d_y);
    diffs = d_y-disparities;
    sumDiffSq = sum(sum(diffs.^2))/2;
    sumDistSq = sum(sum(d_y.^2))/2;
    e = sqrt(sumDiffSq ./ sumDistSq);
end