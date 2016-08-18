clear all
close all

%% Load data
load iris 
X=iris(:,1:4);
mX=mean(X);
sX=std(X);
N=size(X,1);

%% Normalization
X=(X-repmat(mX,N,1))./repmat(sX,N,1); %normáltuk 0 varhato ertek es 1 szorasra

%% Distance matrix
D=zeros(N,N);
D_pair=[];
D = [];
for i = 1:N
    D = [D; sqrt(sum( ( X- repmat(X(i,:),N,1) ).^2 , 2 ))' ];
end

%% VAT based vizualization 
 data.X=X;
 VAT_v2(data,D)
 
 