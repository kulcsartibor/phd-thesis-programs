function pls_model = pls(x,y,vl)
%
% Model for Partial Least Squares regression or discriminant analysis
%
% pls_model = pls(x,y,vl,'da')
%
% input:
% x (samples x descriptors)	for calibration
% y (samples x variables)   for regression or
%   (samples x classes)     for discriminant analysis. Classes numbers must be >0
% vl (1 x 1)                number of latent variables to model
% 'da' (char)               to indicate PLS-discriminant analysis (in PLS regression it is no used)
%
% output:
% pls_model struct with:
%   Data (struct)                X and Y input, and classes (for PLS-DA)
%   VLvar (2 x vl)               cumulative variance (%) explained by model for X and Y.
%   Ypc (samples x variables)    predicted variables or
%       (samples x classes)      predicted classes for calibration samples
%   T (samples x vl)             x-scores
%   P (descriptors x vl)         x-loadings
%   W (descriptors x vl)         x-weights
%   U (samples x vl)             y-scores
%   Q (variables x vl)           y-loadings
%   B (descriptors x variables)  regression vectors
%   B0 (1 x 1)                   regression intercept for (mean(y,1))-(mean(x,1))
%   Lo (samples x 1)             leverages for samples
%   SR (samples x variables)     studentized residuals for samples       
%   Lv (variables x 1)           leverages for variables       
%
%   For PLS-R:
%   RMSEc (1 x variavles)        Root Mean Square Error for calibration
%   R2c (1 x variavles)          Correlation Coefficient for calibration
%   RMSEc_Yrand (1 x variavles)  RMSEc for Y-randomization test (mean of 10 shuffles)
%   R2c_Yrand (1 x variavles)    R2c for Y-randomization test (mean of 10 shuffles)
%
%   For PLS-DA:
%   Succ (1 x 1)                 Success (%) of classification for calibration samples
%   Succ_Yrand (1 x 1)           Success (%) of classification for Y-randomization test
%
% See also plscv, plspred
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil

yo=y;

%---------------------------

[T,P,U,Q,W,beta,var_LV] = plsr(x,y,vl);

ypc=[ones(size(x,1),1) x]*beta;

[s,v]=size(ypc);
rmsec=zeros(1,v);
Rc=zeros(1,v);

    for inv=1:v
        rmsec(1,inv)=sqrt(sum((ypc(:,inv)-yo(:,inv)).^2)/size(yo(:,inv),1));
        Rc(1,inv)=abs(nonzeros(diag((corrcoef(ypc(:,inv),yo(:,inv))),1)));
    end
    
    %--- leverages
        a=vl;
        Lo = diag(T(:,1:a)*pinv(T(:,1:a)'*T(:,1:a))*T(:,1:a)');
        Lv = diag(P(:,1:a)*P(:,1:a)');
    %--- student residues
        for i=1:size(yo,2)
        res=ypc(:,i)-yo(:,i);
        resy=sqrt((1/(size(res,1)-1)*((ones(size(res,1),1)-Lo).^(-2))'.*res')*res); 
        SR(:,i) = res./(resy*sqrt(ones(size(res,1),1)-Lo)); 
        end
    %---    
        
           
pls_model.Data.X=x;
pls_model.Data.Y=y;

pls_model.Data.PLStype='re';

pls_model.VLvar=var_LV;
pls_model.Ypc=ypc;
pls_model.T=T;
pls_model.P=P;
pls_model.W=W;
pls_model.U=U;
pls_model.Q=Q;
pls_model.B=beta(2:size(beta,1),:);
pls_model.B0=beta(1,:);
pls_model.Lo=Lo;
pls_model.SR=SR;

for i=1:size(pls_model.SR,1)
if isnan(pls_model.SR(i))==1
pls_model.SR(i)=0;
end
end

pls_model.Lv=Lv;

pls_model.RMSEc=rmsec;
pls_model.R2c=Rc.^2;


%--------------Y-randomization
for nyr=1:10

	yy=yo;
	for iyr=1:size(yy,2)
	yrand=yy;
	yrand=shuffle(yy);
	end

	[T,P,U,Q,W,beta,var_LV] = plsr(x,yrand,vl);

	ypc=[ones(size(x,1),1) x]*beta;
	
	[s,v]=size(ypc);
	rmsec=zeros(1,v);
	Rc=zeros(1,v);

	for inv=1:v		
		rmsecyr(nyr,inv)=sqrt(sum((ypc(:,inv)-yrand(:,inv)).^2)/size(yrand(:,inv),1));
		Rcyr(nyr,inv)=abs(nonzeros(diag((corrcoef(ypc(:,inv),yrand(:,inv))),1)));
	end
end

pls_model.RMSEc_Yrand=mean(rmsecyr);
pls_model.R2c_Yrand=mean(Rcyr.^2);


%---plsr---
function [T,P,U,Q,W,B,var_LV] = plsr(x,y,lv)

[n,m]=size(x);
[l,k]=size(y);
P=zeros(m,lv);
Q=zeros(k,lv);
T=zeros(n,lv);
U=zeros(n,lv);
W=zeros(m,lv);
V=zeros(m,lv);
cv=x'*y;

for i=1:lv
    [ai,bi,ci]=svd(cv,'econ');
    ai=ai(:,1);
    ci=ci(:,1);
    bi=bi(1);
    ti=x*ai;
    normti=norm(ti);
    ti=ti./normti;
    P(:,i)=x'*ti;
    qi=bi*ci/normti;
    Q(:,i)=qi;
    T(:,i)=ti;
    U(:,i)=y*qi;
    W(:,i)=ai./normti;
    vi=P(:,i);
    
    for repeat=1:2
        for j=1:i-1
            vj=V(:,j);
            vi=vi-(vi'*vj)*vj;
        end
    end
    
    vi=vi./norm(vi);
    V(:,i)=vi;
    cv=cv-vi*(vi'*cv);
    Vi=V(:,1:i);
    cv=cv-Vi*(Vi'*cv);
end

for i=1:lv
    ui=U(:,i);
    for repeat=1:2
        for j=1:i-1
           tj=T(:,j);
           ui=ui-(ui'*tj)*tj;
        end
    end
    U(:,i)=ui;
end

B=W*Q';
B=[(mean(y,1))-(mean(x,1))*B;B];
    
var_LV=[sum(P.^2,1)./sum(sum(x.^2,1));sum(Q.^2,1)./sum(sum(y.^2,1))];
var_LV=cumsum(((var_LV*100)'),1);

%-------shuffle--------
function y = shuffle(x)
y = x(randperm(length(x)),:);