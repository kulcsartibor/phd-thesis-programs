function [Coefficients, Estimates, Residuals, stats] = reg(y,x,alpha,constant)

% Performs a Multivariate OLS Regression of the type:
%
% y = alpha + beta_1 * x_1 + . . . + beta_j * x_j + epsilon 
%
% function [Coefficients, Estimates, Residuals, stats] = reg(y,x,alpha,constant)
%
% Version: 1.0
%
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% This function does a standard multivariate OLS regression with the given
% regressors in x. The regressors are supposed to be column vectors and the
% observations in rows.
% The regressand should be given by y, as column vector respectively. There
% is no need to add a constant manually in x. It is added automatically
% when constant is set to 1. The degrees of freedom are estimated
% accordingly. Alpha reflects the level of significance. Standard should be
% 0.05.
% The regression coefficients, estimates and residuals of the model are
% given in separate matrices. Additional information can be found in stats.
%
% The main advantage over the standard regression codes provided by matlab
% is that it is faster and offers more information at a comprehense place
% so you have all information needed at your fingertips.
%
% Furthermore this function does not (!) require any additional toolboxes
% like the statistics toolbox to be installed.
%
% This function offers as well heteroscedasticity consistent standard
% errors (White 1980) and will soon be further expanded in that matter.
%
% Additionally the ability to perform a rolling window regression on the given
% data is provided. Use the provided wreg() function for this. The function will 
% give the exact same information and results as the standard reg() function but
% stores the model information of each regression. Hence the detection of
% structural breaks will be simplified. You can specify the window size and
% the step size as well. See help wreg() for detailed information. In fact
% all statistics of the reg() function are provided, as well as
% heteroscedasticity consistent standard errors.
%
% Example of usage:
%
% x = randi([1,100],100,5);
% y = randi([1,3],100,1);
%
% [Coefficients, Estimates, Residuals, stats] = reg(y,x,0.05,1);
%
%
% Hint for beginners: 
% 
% Please check your data upon the Gauss-Markov assumptions I-IV,
% otherwise your model might give you biased/wrong results!
%
% Please note that I am not allowed to provide mex functions (to further speed
% improvement), but the code should be right away suitable for conversion.
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


[n,k] = size(x);

if constant == 1
    x = [ones(n,1),x]; % A column with ones as constant is added automatically
    DF = n - k - 1; % Adjusting the degrees of freedom
else
    DF = n - k;
end;

%% Function Calls

Coefficients = ols(y,x); % Regression coefficients beta_i
Estimates = est(Coefficients,x); % Regression estimates for y --> y^
Residuals = u(Estimates,y); % Residuals of the regression
SST = sst(y); % Sum of squared totals
SSE = sse(Estimates,y); % Sum of squared explained
SSR = ssr(SST,SSE); % Sum of squared residuals
R2 = r2(SSE,SST); % Coefficient of determination, R^2
R2adj = r2adj(R2,n,DF); % Adjusted R^2
MSE = mse(SSR,DF); % Mean squared error of the regression model
RMSE = rmse(MSE); % Root mean squared error
C = crit(alpha,DF); % Critical Value
[F,Fp] = f(SSE,SSR,k,DF); % F-Test for the overall Model Fit
AIC = aic(Residuals,n,k); % Akaike Information Criteria (AIC)
SBIC = sbic(Residuals,n,k); % Schwarz's Bayesian Information Criteria (SBIC)

%% HC1 = 'Normal' Standard Errors
%
% These Standard Errors assume that the data provided is homoscedastic,
% meaning a constant variance for the residuals. Hence the Gauss-Markov
% assumption No. 3 is assumed to hold.

Covb1 = covb1(MSE,x); % Variance-Covariance Matrix of the regression coefficients
SE1 = se1(Covb1); % standard errors of the regression coefficients
Tv1 = tv1(Coefficients,SE1); % t-values of the regression coefficients
Ci1 = ci1(Coefficients,C,SE1); % Confidence intervalls of the regression coefficients
Pv1 = pv1(Tv1,DF); % P-values for the null hypothesis H0:Beta_j = 0 (2-tailed)

HC1 = struct( 'Covariance_Matrix',Covb1,...
              'Standard_Errors',SE1,...
              'T_values',Tv1,...
              'P_values',Pv1,...
              'Confidence_Intervalls',Ci1);

%% HC2 = 'White' Standard Errors
%
% These Standard Errors (and the derived statistics) are robust to general
% forms of heteroscedasticity.
% 
% For detailed information see: 
% White, H. (1980). Using least squares to approximate unknown regression functions. International Economic Review, 21(1):149?170.

Covb2 = covb2(Residuals,x,Coefficients); % Variance-Covariance Matrix of the regression coefficients
SE2 = se2(Covb2); % standard errors of the regression coefficients
Tv2 = tv2(Coefficients,SE2); % t-values of the regression coefficients
Ci2 = ci2(Coefficients,C,SE2); % Confidence intervalls of the regression coefficients
Pv2 = pv2(Tv2,DF); % P-values for the null hypothesis H0:Beta_j = 0 (2-tailed)

HC2 = struct( 'Covariance_Matrix',Covb2,...
              'Standard_Errors',SE2,...
              'T_values',Tv2,...
              'P_values',Pv2,...
              'Confidence_Intervalls',Ci2);

%% Information provided in stats

stats = struct( 'N',n,...
                'k',k,...
                'df',DF,...
                'SSE',SSE,...
                'SSR',SSR,...
                'SST',SST,...
                'R2',R2,...
                'adjusted_R2',R2adj,...
                'MSE',MSE,...
                'RMSE', RMSE,...
                'AIC',AIC,...
                'SBIC',SBIC,...
                'F_value',F,...
                'Fp_value',Fp,...
                'Critical_Value',C,...
                'HC1_normal',HC1,...
                'HC2_White',HC2);            
            
end