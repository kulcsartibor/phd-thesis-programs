function [Mt,Mc] = breeding_agrres(fss1,fss2,X,DistM)
%Calculates linear parameters and error values
%  [mse,corcfsq,theta,Yv] = gpols_lsq(fss,X,Y);
%    mse <- mean squared error
%    corcfsq <- square correlation coeffc.
%    theta <- identified linear parameters (last element is the bias)
%    fss -> cell array of function strings
%    X,Y -> regression matrix and output vector
%

% (c) Janos Madar, University of Veszprem, 2005

% disp(['Agr1: ' fss1])
% disp(['Agr2: ' fss2])
% disp(' ')
% Y = [eval(fss1{1}) eval(fss2{1})];


Y = [eval(fss1) eval(fss2)];

% Y(:,1) = (Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));

[Mt,Mc,V,U] = trustcont(10, X, Y, DistM, L2_distance(Y',Y'));



