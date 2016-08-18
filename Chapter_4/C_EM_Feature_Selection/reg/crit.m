
function C = crit(alpha,DF)

% Critical Value C for Regression Coefficients
%
% If you have the statistics toolbox installed you may use
% 'C = tinv(alpha/2,DF);' instead.
%
% The standard is alpha/2 and yields the critical value for a two-tailed
% hypothesis. For different purpose you may use alpha/1 for a one-tailed
% test.
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


C = qt(alpha/2,DF);

end
