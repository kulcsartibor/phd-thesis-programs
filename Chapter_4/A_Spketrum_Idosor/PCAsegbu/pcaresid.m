function [cost,pc,avg]  = pcaresid(x,ndim,flag);
[m,n] = size(x);
if prod(size(ndim)) > 1
    error('Requires a scalar second input.');
end
if ndim >= n
    error('The number of columns in the first input must exceed the value of the 2nd input.');
end
[pc,score,latent] = princomp(x);
avg = mean(x);
avgx = avg(ones(m,1),:);
retain = pc(:,1:ndim)';
predictx = avgx + score(:,1:ndim)*retain;
residuals = x - predictx;
if flag==1
    %cost=sum(sum(residuals.^2));
     cost=mean(mean(residuals.^2));
else
   %cost=sum(sum([score(:,1:ndim).^2]')');
   cost=mean(mean([score(:,1:ndim).^2]')');
end   

