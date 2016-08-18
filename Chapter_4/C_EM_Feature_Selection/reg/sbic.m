function SBIC = sbic(Residuals,n,k)

% Estimation of the Schwarz's Bayesian Information Criteria (SBIC)
%
% Information criteria provide a tradeoff between goodness-of-fit 
% (which lowers the sum of squared residuals) and the model's complexity, 
% which is measured by the number of parameters k+1.
% 
% Information criteria have to be minimized over choices of k+1.
%
% Since the penalty for additional regressors is larger in BIC, 
% this criterion tends to favor more parsimonious models than AIC.
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
% Copyright 2011 | L�on Bueckins | leon.bueckins@googlemail.com
%
% If you have any questions or suggestions for improvements, feel free to
% contact me.
%
%


SBIC = log(1./n * (Residuals'*Residuals)) + ((k+1)./n) .* log(n);

end