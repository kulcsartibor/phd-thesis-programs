
function SE2 = se2(Covb2)

% HC2 Standard Errors (SEs) of the regression coefficients.
%
% The Variance-Covariance matrix is based upon the article by White(1980)
% and yields heteroscedasticity consistent standard errors and
% t-statistics. However improvements to this approach will be added in
% future releases.
%
% For detailed information see: 
% White, H. (1980). Using least squares to approximate unknown regression functions. 
% International Economic Review, 21(1):149-170.
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


SE2 = sqrt(diag(Covb2));

end