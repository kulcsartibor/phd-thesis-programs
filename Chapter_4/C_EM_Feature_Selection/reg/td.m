function v = td(x,DF)

% Estimate the value v of the t-distribution
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


v = gamma((DF + 1) / 2) ./ sqrt(DF * pi) ./ gamma(DF / 2) .* (1 + x .^ 2 ./ DF) .^ ( - (DF + 1) / 2);

end