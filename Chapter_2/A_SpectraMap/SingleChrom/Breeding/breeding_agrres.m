function [Mt,Mc] = breeding_agrres(fss1,fss2,X,DistM)
%Calculates linear parameters and error values
%  [mse,corcfsq,theta,Yv] = gpols_lsq(fss,X,Y);
%    mse <- mean squared error
%    corcfsq <- square correlation coeffc.
%    theta <- identified linear parameters (last element is the bias)
%    fss -> cell array of function strings
%    X,Y -> regression matrix and output vector
%

Y = [eval(fss1) eval(fss2)];

[Mt,Mc,V,U] = trustcont(10, X, Y, DistM, L2_distance(Y',Y'));
