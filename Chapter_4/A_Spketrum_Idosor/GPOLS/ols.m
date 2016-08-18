%----------------------------------------------------------------------
function [err,theta] = ols(P,Y,q);
% OLS - Orthogonal Least Squares
%  [err,theta] = ols(P,Y,q);
%   P: regressor matrix (n*m) /m: number of regressors/
%   Y: output vector (n*1) /n: number of data points/
%   err: error reduction ratio vector (m*1)
%   theta: parameter vector (m*1)
%   q: q=0 -> [err] = ...; q~=0 -> [err,theta] = ...
%
%  Y = P*theta + e,
%   where Y: outputs, P: regressors, theta: parameters, e: error 


%Orthogonal decomposition ("economy size"):
[W,A] = qr(P,0);
%Error reduction ratios:
D = W'*W;
G = inv(D)*W'*Y;
yty = (Y'*Y);
err = zeros(size(P,2),1);
for i = 1:size(P,2),
  %err(i) = G(i)*G(i)*W(:,i)'*W(:,i)/yty;
  err(i) = (YY'*W(:,i))^2 / ((YY'*YY)*(W(:,i)'*W(:,i)));
end
%Parameter vector:
if q ~= 0,
  theta = inv(A)*G;
end
