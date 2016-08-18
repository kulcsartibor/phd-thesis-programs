clc
clear all
format long

M=1;

% % [szam, szoveg, szamESszoveg] = xlsread('HDS_1.xlsx',1);
% % [a,b]=size(szam);
% % [c,d]=size(szoveg);         % c=a+3  d=b+1
% % [c,d]=size(szamESszoveg);   % SO és SASO méretei valóban egyeznek
% % SA=szam;
% % SO=szoveg;
% % SASO=szamESszoveg;
% % 
% % % M=1           KEI: HDS üzem fogyasztott fûtõgáz           az Excelben a 2.oszlop, SA-nban az 1., azaz az M. !
% % % M=2           KEI: HDS üzem fogyasztott gõz               az Excelben a 3.oszlop, SA-nban az 2., azaz az M. !
% % % M=3           KEI: HDS üzem technológiai gõzfogyasztás    az Excelben a 4.oszlop, SA-nban az 3., azaz az M. !       
% % % M=4           KEI: HDS üzem termelt gõz                   az Excelben a 5.oszlop, SA-nban az 4., azaz az M. !
% % % M=5           KEI: HDS üzem villamos energia fogyasztás   az Excelben a 6.oszlop, SA-nban az 5., azaz az M. !     
% % 
% % % a szûretlen értékek mátrixa: SE
% % 
% % SE=[SA(:,M) SA(:,6:end)];         % a számokat tartalmazó mátrix 6. oszlopában kezdõdnek a potenciálisan releváns független változók
% % 
% % % Kiszûrjük azokat a sorokat, amelyekben számadat helyett az Excelben "No Good Data..." szerepelt.
% % % Ezeken a helyeken az SA-ban NaN szerepel, ez lesz a szûrés alapelve.
% % % A szûrt, már csak számadatokat tartalmazó mátrix: E.
% % 
% % E=SE;
% % i=1;
% % vege=0;
% % while vege==0
% %     if nnz(isnan(E(i,:))) ~=0      % ha az adott sorban van NaN, akkor az isnan vaktorban lesz 0-tól különbözõ elem, és így erre a vektorra az nnz függvény 0-tól különbözõ eredményt ad ---- ha ez történik, töröljük az aktuális sort!
% %         E(i,:)=[];
% %     else
% %         i=i+1;          % ha töröltem egy sort, nem növelem i-t, mert a következõ ciklusban azt a sort vizsgálom, ami ebben a ciklusban még i+1. volt, de a törlés miatt i. lett
% %     end
% %     if i+1>length(E(:,1))   % ha a következõ vizsgálandó sor már nem is létezik, mert a mátrix aljára értünk, akkor leáll a szûrés
% %         vege=1;
% %     end
% % end
% % 
% % % Ellenõrzés:  numel(E) egyenlõ numel(isnan(E)) -vel? 
% % 
% % if M==1
% %     save('E_M1.mat','E')
% % end

if M==1
    load('E_M1.mat')
end

%%
addpath .\somtoolbox

% % clear komponensek
% % komponensek=cell(1,length(E(1,:)));
% % komponensek(1,1)=SO(2,M+1);
% % komponensek(1,2:end)=SO(2,7:end)
% % 
% % if M==1
% %     save('komponensek_M1.mat','komponensek')
% % end

if M==1
    load('komponensek_M1.mat')
end


%% Trajektória kirajzolás: szakaszosan, hogy az idõbeli alakulást
%% nyomonkövessük (két komponensen, példaképp)
% sD=som_data_struct(E,'comp_names', komponensek)
% sM=som_make(sD)          % sM=som_make(sD,'lattice','rect')
% 
% som_show(sM,'comp',[1 2])
% 
% bmus=som_bmus(sM,sD);
% L=length(bmus);
% n=0;
% for i=[2:floor(L/20):20*floor(L/20) L]
%     n=n+1   % csak azért íratom ki, hogy lássam: a 21 újrarajzolás során éppen hányadiknál tartunk
%     som_show_add('traj',bmus(1:i),'SubPlot','all')
% end
%%
sD=som_data_struct(E,'comp_names', komponensek)
sM=som_make(sD,'lattice','rect')
figure(1)
% som_show(sM)
%%
figure(2)
[O,A]=som_order_cplanes_MODOSITOTT(sM)

figure(3)
plot(O(:,1),max(O(:,2))-O(:,2),'r.','markers',24)
text(O(:,1),max(O(:,2))-O(:,2),komponensek)
%%
xKomp=O(:,1);
yKomp=max(O(:,2))-O(:,2);
 
hasonl=A(1,:)';
hasonl_szoveggel=num2str(hasonl)
figure(5)
plot(xKomp,yKomp,'r.','markers',24)
text(xKomp,yKomp,hasonl_szoveggel)

similarity=cell(length(komponensek),2);
similarity(:,1)=komponensek';
for i=1:length(komponensek)
    similarity{i,2}=hasonl(i);
end
similarity
%%
H=hasonl;
n=1;
for i=1:length(komponensek)
    hely=find(hasonl==max(H));
    similarity_descent(n,:)=similarity(hely,:);
    n=n+1;
    H(H==max(H))=[];
end
similarity_descent
%%
% az adathalmaz átrendezése: 1. oszlop a KEI, 
% a 2. oszlop a KEI-hez való hasonlóság csökkenõ sorrendjében 1. SOM komponense,
% a 3. oszlop a KEI-hez való hasonlóság csökkenõ sorrendjében 2. SOM komponense, 
% stb.
% akorábbi adathalmaz E volt, az új EE lesz

EE(:,1)=E(:,1);
n=2;
for i=2:length(komponensek)
    s=similarity_descent{i,1};
    ind=find(ismember(komponensek,s));
    EE(:,n)=E(:,ind);
     n=n+1;
end
%% PLS, rekurzívan: elõször a similarity_descent szerinti elsõ két változóra (n=2), majd az elsõ háromra (n=3), majd az elsõ négyre (n=4), stb
%% és mindegyik fenti cikluson belüls is van egy ciklus: a PLS látens változóinak száma 2,3,...,n.

KORR=zeros(length(komponensek)-2)

y=EE(:,1);
for n=2:length(komponensek)-1
    for i=2:n
        x=EE(:,2:2+n-1);
        [XL,YL,XS,YS,BETA] = plsregress(x,y,i);
        yfit = [ones(size(x,1),1) x]*BETA;
        Mk=corrcoef(yfit,y);
        KORR(i-1,n-1)=Mk(1,2);
    end
end
KORR
%%
figure(6)
hold on
for n=2:length(komponensek)-1
    for i=2:n
        plot(n,KORR(i-1,n-1),'o')
    end
end
xlabel('n')
ylabel('KORR')
grid on
%%
% kiválasztjuk azt az esetet, amikor már viszonylag magas a korreláció, de
% nem túl sok a bemenet... saját vélemény elsõ nekifutásra:
if M==1
    n=7;
    ii=7;
end

x=EE(:,2:2+n-1);
[XL,YL,XS,YS,BETA] = plsregress(x,y,ii);
yfit = [ones(size(x,1),1) x]*BETA;
Mk=corrcoef(yfit,y);
KE=Mk(1,2)
%%
% a MOL-modell eredménye
if M==1
    ma=find(ismember(similarity_descent(:,1),'ALAPANYAG'));
    mb=find(ismember(similarity_descent(:,1),'1.KAMRA HOFOKSZABALYZAS'));
    mc=find(ismember(similarity_descent(:,1),'O401 Kemence Belépõ hõfok'));
    md=find(ismember(similarity_descent(:,1),'2.KAMRA HOFOKSZABALYZAS'));
    me=find(ismember(similarity_descent(:,1),'KÜLSÕ HÕMÉRSÉKLET'));
    mf=find(ismember(similarity_descent(:,1),'FG4 ATLAG_SURUSEG_NM3'));
    y_MOL_regr=0.000143*EE(:,ma).^1.5 +0.019763*((E(:,mb)-EE(:,mc))+(E(:,md)-EE(:,mc)))/2 -0.00146 * EE(:,me)+0.619604*EE(:,mf)-0.32028;
end
%%
% egy idagramon: mérés + PLS-modell szerinti becslés + MOL szerinti becslés
t=[1:length(y)];

figure(7)
whitebg('black')
hold on
plot(t,y,'g')
plot(t,y_MOL_regr,'m')
plot(t,yfit,'y')
%% Validálás
%Mondjuk: minden 5.hét adataira

% 5*7*24=840
% 1*7*24=168
% 4*7*24=672
N=floor(length(y)/840);
for i=1:N
    x_valid((i-1)*168+1:i*168,:)  =  x((i*840-167):(i*840),:);  %% a kivett adatok (minden 5. hét)
    y_valid((i-1)*168+1:i*168,:)  =  y((i*840-167):(i*840),:);
end

for i=1:N
    x_marad((i-1)*672+1:i*672,:)  =  x((i-1)*840+1:(i-1)*840+672,:); 
    y_marad((i-1)*672+1:i*672,:)  =  y((i-1)*840+1:(i-1)*840+672,:);
end
A=length(x_marad(:,1));
B=length(y)-N*840;
x_marad(A+1:A+B,:)=x(N*840+1:end,:);
y_marad(A+1:A+B,:)=y(N*840+1:end,:);

%%
% PLS a "maradékra"
[XL,YL,XS,YS,BETA] = plsregress(x_marad,y_marad,ii);
yfit_marad = [ones(size(x_marad,1),1) x_marad]*BETA;
Mk=corrcoef(yfit_marad,y_marad);
KE_marad=Mk(1,2)
%%
% az imént adódó modellel számolni az "5. hetek" modell szerinti kimenetét
yfit_valid= [ones(size(x_valid,1),1) x_valid]*BETA;
Mk_valid=corrcoef(yfit_valid,y_valid);
KE_valid=Mk_valid(1,2)
%%
% ábra a maradék hetekrõl+a rá illesztett modellrõl PLUSZ a validálási hetekrõl+a modell itt adódó eredméyeirõl

% t_valid=[];
% for i=1:N
%     pluszt=[i*840-167:i*840];
%     t_valid=[t_valid pluszt];
% end
% t_marad=[];
% for i=1:N
%     pluszt=[(i-1)*840+1:(i-1)*840+672];
%     t_marad=[t_marad pluszt];
% end
% t_marad=[t_marad N*840+1:N*840+B];

figure(8)
hold on
for i=1:N
    h(i)=plot([(i-1)*840+1:(i-1)*840+672],y_marad((i-1)*672+1:(i-1)*672+672),'w')  % N darab plot
end
    h(N+1)=plot([N*840+1:N*840+B],y_marad(N*672+1:end),'w')  % +1 plot
for i=1:N
    h(N+1+i)=plot([(i-1)*840+1:(i-1)*840+672],yfit_marad((i-1)*672+1:(i-1)*672+672),'g')  % +N plot
end
    h(2*N+2)=plot([N*840+1:N*840+B],yfit_marad(N*672+1:end),'g')  % +1 plot
for i=1:N
    h(2*N+2+i)=plot([i*840-167:i*840],y_valid((i-1)*168+1:(i-1)*168+168),'b') % +N plot
end
for i=1:N
    h(3*N+2+i)=plot([i*840-167:i*840],yfit_valid((i-1)*168+1:(i-1)*168+168),'y') % +N plot
end

felir_marad=sprintf('referenciára illesztett modell (korreláció: %d)',KE_marad);
felir_valid=sprintf('a modell eredménye a validálás hetében (korreláció: %d)',KE_valid);

legend(h([1 N+2 2*N+3 3*N+3]),'referencia idõszak /mért kimenet/',felir_marad,'validálási hét /mért kimenet/',felir_valid)
xlabel('Idõ [h]')
if M==1
    ylabel('HDS üzem, fogyasztott fûtõgáz [t/h]')
end
%%
% SOM a "maradékra"
marad=[y_marad x_marad];
sD2=som_data_struct(marad,'comp_names', similarity_descent(1:n+1,1))
sM2=som_make(sD2,'lattice','rect','msize',[10 10])
figure(9)
som_show(sM2)
%%
valid=[y_valid x_valid];

for i=1:size(valid,1)
    c=valid(i,:);
    Bmus(i,1)= som_bmus(sM2, c);
end









































%%
% Nem felhasznált próbálkozások:

% a KEI mindig a "komponensek" elsõ eleme
% a hasonlóság mérõszámára az ötlet: a figure 2-n a KEI térképétõl való
% távolság (Pitagorasz!) felhasználása!
% % xKEI=xKomp(1);
% % yKEI=yKomp(1);
% % for i=1:length(komponensek)
% %     tav(i,1)=sqrt( (xKEI-xKomp(i))^2  + (yKEI-yKomp(i))^2  );
% % end
% % 
% % tav_szoveggel=num2str(tav)
% % figure(4444)
% % plot(xKomp,yKomp,'r.','markers',24)
% % text(xKomp,yKomp,tav_szoveggel)
%%
% % Y = normpdf(tav,0,1)
% % hasonlosag=Y./normpdf(0,0,1
% % has_szoveggel=num2str(hasonlosag)
% % figure(111)
% % plot(xKomp,yKomp,'r.','markers',24)
% % text(O(:,1),max(O(:,2))-O(:,2),has_szoveggel)
%%
% % % Z  = linkage(pdist(sM.codebook));
% % % sC = som_clstruct(Z) 
% % % som_clplot(sC)
   

    












