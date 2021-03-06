
function Pv1 = pv1(Tv1,DF)

% HC1 P values of the regression coefficients, H0:Beta_j = 0
%
% If you have the statistics toolbox installed you may use
% 'Pv1 = 2*tcdf(-abs(Tv1),DF);' instead.
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

Pv1 = 2*td(-abs(Tv1),DF);

end
