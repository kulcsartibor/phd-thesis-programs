
function Covb1 = covb1(MSE,x)

% HC1 Variance-Covariance Matrix of the regression coefficients
%
% This is the normal Variance-Covariance matrix that assumes that
% Gauss-Markov assumptions I-IV hold and thus is not robust towards
% heteroscedasticity, autocorrelation or any other form of correlation
% (e.g. spatial).
%
% Version 1.0
% ---------------------------------------------------------------------------
%
% Copyright Notice:
%
% You are allowed to use the code for your private and commercial purpose
% and change it to meet your requirements. You are not allowed to
% redistribute or sell it as a whole or fragments of it. When using it,
% cite it.
% 
% Copyright 2011 | Léon Bueckins | leon.bueckins@googlemail.com
%
% If you have any questions or suggestions for improvements, feel free to
% contact me.
%
%


Covb1 = MSE * (inv(x' * x));

end