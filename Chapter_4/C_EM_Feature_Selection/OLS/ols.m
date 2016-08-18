function [th,I] =ols(P,y)
% OLS uses orthogonal least squares to calculate singleton
% rule consequents assuming a zero-order TS model.
%
% [P,I]=OLS(DOF,Y)
%
% DOF   ...  fuzzy partition matrix / degree of firing (NxM)
% Y     ...  output data vector (Nx1)
%
% P     ...  Mx1 vector of rule consequents
% I     ...  Rule order
%
% See also OLSRED, OLSORT


% Magne, april 1999

%Fuzzy Basis Functions = normalized DOF
%P=P./((sum(P')')*ones(1,size(P,2)));

%Prepear for OLS
[N,M]=size(P);
A=diag(ones(1,M),0);
index=[1:M];% index of all basis functions
I=[];		% Vector to keep track of selected basis functions
W=[];
G=[];

% STEP 1: Select most significant basis function
w=P;
% Check for linear combinations
   ww=sum(w.*w);
   ii=find(ww<1e-14);%index of those who are correlated
   ww(ii)=ww(ii)+1; %avoid divide by zero
   g=(w'*y)./ww';
   err=(g.^2.*ww')./(y'*y);
   err(ii)=err(ii)*0;%mask the correlated ones
   
i=find(err==max(err));
	i=i(1);

W=[W,w(:,i)];
G=[G;g(i)];
I(1,:)=index(i);
k=length(i);
index(i)=[];

P_all=P;
while(k<M), 
	P=P_all;P(:,I)=[];	%use all basis functions, except those already selected
	a=(W'*P);
   a=a./(sum((W'*W))'*ones(1,size(a,2)));
	w=P-W*a;
	% Check for linear combinations
   ww=sum(w.*w);
   ii=find(ww<1e-14);%index of those who are correlated
   ww(ii)=ww(ii)+1; %avoid divide by zero
   %	g=(w'*y)./(sum(w.*w))';
   
   g=(w'*y)./ww';
	%  err=(g.^2.*(sum(w.*w)'))./(y'*y);
   err=(g.^2.*ww')./(y'*y);

   err(ii)=err(ii)*0;%mask the correlated ones
   err(find(isnan(err)))=ones(sum(isnan(err)),1)*0;
   
   i=find(err==max(err));
   	i=i(1);%select only one per time
        A(1:k,k+1)=a(:,i);

%	E=[E;max(err)];
	W=[W,w(:,i)];
	G=[G;g(i)];
	I(size(I,1)+1,1:length(i))=index(i);
	k=k+length(i);
	index(i)=[];	%Index nummer of selected rules
end;

%% solv for the parameters
th=inv(A)*G;
th=th(I);