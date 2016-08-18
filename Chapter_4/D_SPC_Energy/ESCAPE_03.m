% ESCAPE_02.m után futtatható

KORR.PLS_all=zeros(length(comps)-2)

%%
figure(111)
[O,A]=som_order_cplanes_MODOSITOTT(sM)

% figure(222)
% plot(O(:,1),max(O(:,2))-O(:,2),'r.','markers',24)
% text(O(:,1),max(O(:,2))-O(:,2),comps)
%%
xKomp=O(:,1);
yKomp=max(O(:,2))-O(:,2);
 
hasonl=A(1,:)';
hasonl_szoveggel=num2str(hasonl)
% figure(333)
% plot(xKomp,yKomp,'r.','markers',24)
% text(xKomp,yKomp,hasonl_szoveggel)
%%
similarity=cell(length(comps),2);
similarity(:,1)=comps';
for i=1:length(comps)
    similarity{i,2}=hasonl(i);
end
similarity
%%
H=hasonl;
n=1;
for i=1:length(comps)
    hely=find(hasonl==max(H));
    similarity_descent(n,:)=similarity(hely,:);
    n=n+1;
    H(H==max(H))=[];
end
similarity_descent
%%
% Red.x átrendezett verziója: 
% az 1. oszlop a KEI-hez való hasonlóság csökkenõ sorrendjében 1. SOM komponense,
% a  2. oszlop a KEI-hez való hasonlóság csökkenõ sorrendjében 2. SOM komponense, 
% stb.
% Val.x-re és Full.x-re ismeg kell csinálni!!
Redx_sor=Red.x;
Valx_sor=Val.x;
Fullx_sor=Full.x;
n=1;
for i=2:length(comps)
    s=similarity_descent{i,1};
    ind=find(ismember(comps,s))-1;
    Redx_sor(:,n)=Red.x(:,ind);
    Valx_sor(:,n)=Val.x(:,ind);   
    Fullx_sor(:,n)=Full.x(:,ind);       
    n=n+1;
end
%%
for n=2:length(comps)-1
    for i=2:n
        [XL,YL,XS,YS,BETA] = plsregress(Redx_sor(:,1:n),Red.y(:,M),i);
        y_red_becs = [ones(size(Redx_sor(:,1:n),1),1) Redx_sor(:,1:n)]*BETA;
        Mk=corrcoef(y_red_becs,Red.y(:,M));
        KORR.PLS_all(i-1,n-1)=Mk(1,2);
    end
end


%%
figure(2)
whitebg('w')
hold on
for n=2:length(comps)-1
    for i=2:n
        plot(n,KORR.PLS_all(i-1,n-1),'o')
    end
end
xlabel('n')
ylabel('KORR.PLS')
grid on
%%
if M==1
    nn=6;
    ii=6;
elseif M==2
    nn=6;
    ii=6;
elseif M==3
    nn=6;
    ii=6;
elseif M==4
    nn=6;
    ii=6;
end

[XL,YL,XS,YS,BETA] = plsregress(Redx_sor(:,1:nn),Red.y(:,M),ii);

y_val_plsbecs = [ones(size(Valx_sor(:,1:nn),1),1) Valx_sor(:,1:nn)]*BETA;
Mk=corrcoef(y_val_plsbecs,Val.y(:,M));
KORR.PLS=Mk(1,2)



