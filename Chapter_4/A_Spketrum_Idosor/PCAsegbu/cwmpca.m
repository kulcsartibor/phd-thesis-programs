function [mu,mufi,varx,covarx,covarfi,pp,pc]=cwmfun(x,fi,nclusters,input_type,q);
min_var = 1e-4;	% constant to add to variances (resolution)
niterations=30;

[npts dim] = size(x);
[npts dimfi] = size(fi);

fi=fi-kron(ones(npts,1),mean(fi));
fi=fi./kron(ones(npts,1),std(fi));

%input_type> input('Variance clusters (0) or covariance cluster (1)?  ');
VARIANCE = 0;
COVARIANCE = 1;


%
% E-M iteration
%
pc = ones(1,nclusters)/nclusters;
f = zeros(npts,nclusters);


% generate random starting clusters
%
momentum = 0.0;
%mu = .8*rand(nclusters,dim).*kron(ones(nclusters,1),max(x)-min(x))+ kron(ones(nclusters,1),min(x));
mu = [min(x):(max(x)-min(x))/(nclusters-1):max(x)]';
dmu = zeros(nclusters,dim);
varx = ones(nclusters,dim)*0.2;
for cluster = 1:nclusters
   covarx(:,:,cluster) = diag(ones(1,dim));
end

%mufi = .8*rand(nclusters,dimfi).*kron(ones(nclusters,1),max(fi)-min(fi))+...
%    kron(ones(nclusters,1),min(fi));

mufi=fi(floor(1:(length(x)-1)/(nclusters-1):length(x)),:)
for cluster = 1:nclusters
   covarfi(:,:,cluster) = cov(fi);
  %  covarfi(:,:,cluster) =   diag(ones(1,dimfi));
end
dmufi = zeros(nclusters,dimfi);
vary = ones(1,nclusters);
varyest = ones(1,nclusters);



step = 1;
while (step <= niterations)
   
    for cluster = 1:nclusters
      if (input_type == COVARIANCE)
         cinv(:,:,cluster) = pinv(covarx(:,:,cluster));
         px(:,cluster) = (sqrt(det(cinv(:,:,cluster)))/((2*pi)^(dim/2))) ...
            * exp(-dot((x-kron(ones(npts,1),mu(cluster,:)))',(cinv(:,:,cluster)*(x-kron(ones(npts,1),mu(cluster,:)))'))'/2);
      else
         px(:,cluster) = prod((exp(-(x-kron(ones(npts,1),mu(cluster,:))).^2 ...
            ./ (2*kron(ones(npts,1),varx(cluster,:))))./ kron(ones(npts,1),sqrt(2*pi*varx(cluster,:)))),2);
       end
       
       [U dv V]	= svd(covarfi(:,:,cluster),0);
     %  [U,dv] = eig(covarfi(:,:,cluster));   
       dv=diag(dv);
       [dum,ind]=sort(diag(-dv));
       dv=dv(ind); 
       U=U(:,ind);
       ind=find(dv>0);
       U=U(:,ind);
       dv=dv(ind);
       % Reduce the transformation matrix appropriately
       TransMat = U(:,1:q);
       TransMatR = U(:,q+1:end);
       Sm = TransMat*diag(1./dv(1:q))*TransMat'; 
     %  Sm = TransMat*TransMat'; 
       det(Sm)
       dimfir=size(Sm,1);
       py(:,cluster) = (sqrt(det(Sm))/((2*pi)^(dimfir/2))) ...
            * exp(-dot((fi-kron(ones(npts,1),mufi(cluster,:)))',(Sm*(fi-kron(ones(npts,1),mufi(cluster,:)))'))'/2);
        py=real(py);
    end
   %
   %py=py./py;
   % calculate posterior and total probability
   p = sum((py .* px .* kron(ones(npts,1),pc)),2);
   pp = (py .* px .* kron(ones(npts,1),pc)) ./ (kron(p,ones(1,nclusters))+eps);
   figure(1)
   clf
   subplot(2,1,1)
   plot(px)
   subplot(2,1,2)
   plot(py)
   drawnow
   pause(0.01)
   
   
   pc = sum(pp) / npts
   step_prob(step) = mean(p);
   %
  
   % update clusters
   %
   d2 = 0;
   for cluster = 1:nclusters
      munew = momentum*dmu(cluster,:) + sum(x .* kron(pp(:,cluster),ones(1,dim))) / (npts*pc(cluster));
      dmu(cluster,:) = munew - mu(cluster,:);
      mu(cluster,:) = munew;
  
      munewfi = momentum*dmufi(cluster,:) + ... 
          sum(fi .* kron(pp(:,cluster),ones(1,dimfi))) / (npts*pc(cluster));
      dmufi(cluster,:) = munewfi - mufi(cluster,:);
      mufi(cluster,:) = munewfi;

      
      varx(cluster,:) = min_var + sum((x - kron(ones(npts,1),mu(cluster,:))).^2 .* ...
            kron(pp(:,cluster),ones(1,dim))) / (npts*pc(cluster));
      if (input_type == COVARIANCE)
         for d = 1:dim
            covarx(d,:,cluster) =  sum( (x - kron(ones(npts,1),mu(cluster,:))) .* ...
                 (kron(x(:,d),ones(1,dim)) - ones(npts,dim)*mu(cluster,d)) ...
                 .* kron(pp(:,cluster),ones(1,dim))) / (npts * pc(cluster));
           end
         covarx(:,:,cluster) = covarx(:,:,cluster) + min_var*diag(ones(1,dim));
       end
       
        for d = 1:dimfi
            covarfi(d,:,cluster) =  sum( (fi - kron(ones(npts,1),mufi(cluster,:))) .* ...
                 (kron(fi(:,d),ones(1,dimfi)) - ones(npts,dimfi)*mufi(cluster,d)) ...
                 .* kron(pp(:,cluster),ones(1,dimfi))) / (npts * pc(cluster));
         end
         covarfi(:,:,cluster) = covarfi(:,:,cluster) + min_var/1000*diag(ones(1,dimfi));
      end % cluster update loop

      
      
      
   step = step + 1;
   end % iterate step loop
%

