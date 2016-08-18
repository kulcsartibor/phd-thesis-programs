
function Ci2 = ci2(Coefficients,C,SE2)

% HC2 Confidence Intervalls of the regression coefficients. The given alpha in
% the main function reg() is used to compute the critical value C here.
%
% Refers to the HC2 version respectively.
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

Ci2 = [Coefficients + C .* SE2, Coefficients - C .* SE2];

end