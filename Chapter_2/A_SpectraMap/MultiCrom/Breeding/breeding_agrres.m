function [Mt,Mc] = breeding_agrres(fss1,fss2,X,DistM)
%Calculates linear parameters and error values

% disp(['Agr1: ' fss1])
% disp(['Agr2: ' fss2])

Y = [eval(fss1) eval(fss2)];

% Y(:,1) = (Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));

[Mt,Mc,V,U] = trustcont(10, X, Y, DistM, L2_distance(Y',Y'));



