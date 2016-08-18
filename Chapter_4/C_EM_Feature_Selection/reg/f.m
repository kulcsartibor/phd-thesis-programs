
function [F,Fp] = f(SSE,SSR,k,DF)

% F-Statistic for regression
%
% If you have the statistics toolbox installed you may use
% 'Fp = 1 - fcdf(F,DF,1);' instead.
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


F = (SSE ./ k) ./ (SSR ./ DF);

Fp = fd(F,DF,1);

end