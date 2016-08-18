function [I] =olsred(P,y,e,de)
% OLSRED removes less important clusters or rules. Assumes that each
% culster or rule corresponds to a fuzzy rule in a 0-order TS model.
%
% [I]=OLSRED(DOF,Y,E,DE)
%
% DOF   ...  fuzzy partition matrix / degree of firing (NxM)
% Y     ...  output data vector (Nx1)
% E     ...  error threshold, 0<E<1 (optional, default 0)
%            the rules needed to obtain this error ratio are selected
% DE    ...  rules contribution threshold (optional, default .05)
%            if the least important of the selected rules contributes
%            less than DE to the error reduction of the rule base,
%            no more rules are selected.
%
% I     ...  clusters/rules to keep (decreasing order of importance)
%
% Examples:
% E=0,DE=.1 :rules are selected in order of impotrance until the least
%            important rule has an error reduction ratio that contributes
%            less than 10% to that of the total rule base.
% E=.2,DE=0 :rules are selected until model has an error ratio < 20%
% E=.2,DE=.1:rules are selected until model has an error ratio < 20% OR
%            the least important rule contributes less than 10% to
%            the error reduction of the rule base
%
% See also OLSORT, FCMOLS, GKOLS 


% Magne, April 20 1999

% PARAMETERS
if(nargin<3),
   e=0;	% error stopping criterion left out
elseif(isempty(e)),
	e=0;
end;
if(nargin<4),
	de=0.05;	% change of error stopping criterion (0<e<1)
elseif(isempty(de)),
	de=0.05;
end;
P=max(P,.00001);	
%Fuzzy Basis Functions = normalized DOF
P=P./((sum(P')')*ones(1,size(P,2)));

%Prepear for OLS
[N,M]=size(P);
index=[1:M];% index of all basis functions
I=[];		% Vector to keep track of selected basis functions
W=[];
G=[];

%der=[];

% STEP 1: Select most significant basis function
w=P;
%g=(w'*y)./(sum(w.*w))';
%err=(g.^2.*(sum(w.*w)'))./(y'*y);
% Check for linear combinations
   ww=sum(w.*w);
   ii=find(ww<1e-4);%index of those who are correlated
   ww(ii)=ww(ii)+1; %avoid divide by zero
  	g=(w'*y)./ww';
   err=(g.^2.*ww')./(y'*y);
   
   err(ii)=err(ii)*0;%mask the correlated ones

i=find(err==max(err));

if(~isempty(i)),
   i=i(1);
	W=[W,w(:,i)];
	G=[G;g(i)];
	I=[I,index(i)];
	k=length(i);%+1;
   index(i)=[];
end;


err_1=sum((G.^2.*(sum(W.*W)'))./(y'*y));

stop=0;
P_all=P;
while(~stop), 
	P=P_all;P(:,I)=[];	%use all basis functions, except those already selected
	a=(W'*P);
	a=a./(sum((W'*W))'*ones(1,size(a,2)));
	w=P-W*a;
   
  % Check for linear combinations
   ww=sum(w.*w);
   ii=find(ww<1e-4);%index of those who are correlated
   ww(ii)=ww(ii)+1; %avoid divide by zero
   %	g=(w'*y)./(sum(w.*w))';
  	g=(w'*y)./(ww)';
	%  err=(g.^2.*(sum(w.*w)'))./(y'*y);
   err=(g.^2.*ww')./(y'*y);

   err(ii)=err(ii)*0;%mask the correlated ones
   err(find(isnan(err)))=ones(sum(isnan(err)),1)*0;
   i=find(err==max(err));
   
   i=i(1);
	W=[W,w(:,i)];
	G=[G;g(i)];
	
	I=[I,index(i)];
	k=k+length(i);
	index(i)=[];	%Index nummer of selected rules
	
   % stopping criterion
   % error criteria
	err=real(1-sum((G.^2.*(sum(W.*W)'))./(y'*y)));
   
   % change in error reduction<de%
   derr=((1-err)-err_1)/err_1;
   err_1=(1-err);
   %der=[der;derr];
   
	if(err<e),	% Select only MS most significant rules, or stop if error is low  
    	stop=1;
		disp('error criteria')
	elseif(k>=M),
		stop=1;
		disp('no reduction')
	elseif(derr<de),
		stop=1;
		disp('change of error criteria')
	end;
end;

%figure;
%plot(der);
%der