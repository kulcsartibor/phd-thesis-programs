function [Coefficients, Estimates, Residuals, stats, rolling_window] = wreg(y,x,alpha,constant,window,step)

% Performs a Multivariate rolling window OLS Regression of the type:
%
% y = alpha + beta_1 * x_1 + . . . + beta_j * x_j + epsilon 
%
% function [Coefficients, Estimates, Residuals, stats, rolling window] = wreg(y,x,alpha,constant,window,step)
%
% Version: 1.0
%
% This function is based upon reg() and thus gives the same results and
% information upon the model specified. The rolling window technique allows
% you to perform multiple regressions on subsets of your data. 
% 
% The window size specifies the number of observations that is used for each 
% regression and should be of the size 1 <= window <= N. Where N is your whole 
% samplesize. Please note that very small windows will lead to misspecification.
%
% The step size specifies the number of observations that is jumped from
% iteration to iteration. For example a step size of '1' and a window size
% of 100 would perform the first regression on obs 1-100 and the second one
% from 2-101. Setting the step size to the same size as the window would
% divide your sample in n independent subsamples. Be aware that step sizes greater 
% than the window size would lead to uncovered/unused observations.
% 
% The 'rolling_window' matrix gives you additional information about the
% start and end point of each subset. The number of observations used can
% be checked in stats.N.
%
% Please note that in case your sample cannot be evenly divided by the window
% and step size specified the remaining observations at the end will not be used.
% You might perform a separate regression on them by hand.
%
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

stoppingpoint = (length(x)-window+1);

rolling_window = zeros(2,stoppingpoint);

[Coefficients, Estimates, Residuals, stats] = reg(y(1:window,:),x(1:window,:),alpha,constant);

i = 0;

HC1_cell = cell(1,1); %#ok<NASGU>
HC2_cell = cell(1,1); %#ok<NASGU>


    for s = 1:step:stoppingpoint

        i = i + 1;
        
        [Coefficients(:,i), Estimates(:,i), Residuals(:,i), stats] = reg2(y(s:s+window-1,1),x(s:s+window-1,:),alpha,constant,stats,i);

        rolling_window(1,i) = s; % Start
        rolling_window(2,i) = s+window-1; % Stop

    end
    
    rolling_window(:,i+1:end) = [];

end