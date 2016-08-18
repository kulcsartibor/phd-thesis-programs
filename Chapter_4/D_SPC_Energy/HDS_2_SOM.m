%  A HDS_2.xlsx-BEN (JELENLEG) MINDEN KEI ESETÉN 79 KOMPONENS LESZ:
%  78 FÜGGETLEN VÁLTOZÓ, PLUSZ A KEI.
%  79 TÉRKÉPET EGY ÁBRACSOPORTRA FELTENNI ÉRTELMETLEN: NEM LÁTHATÓAK AZ
%  EGYES TÉRKÉPEK...
%  KÜLÖN figure-OKRA RAKOK 8-8 TÉRKÉPET, PLUSZ MINDEN FIGURE-ON RAJTA LESZ
%  (AZ ÖSSZE KOMPONENSRE KÉSZÍTETT) u-mÁTRIX IS.
%  ATTÓL FÜGGETLENÜL, HOGY EGY ÁBRÁN HÁNY TÉRKÉP SZEREPEL, A PROGRAM OLAN
%  ALAKÚ ÉS MÉRETÛ TÉRKÉPET KÉSZÍT, MINTHA MINDEN TÉRKÉP EGY ÁBRÁRA LENNE
%  FELZSÚFOLVA. EZÉRT A TÉRKÉP MÉRETÉT IS DEFINIÁLNI KELL.

clc
clear all
format long
global ERTEKEK N

[szam, szoveg, szamESszoveg] = xlsread('HDS_2.xlsx',1);
[a,b]=size(szam);
[c,d]=size(szoveg);         % c=a+3  d=b+1
[c,d]=size(szamESszoveg);   % SO és SASO méretei valóban egyeznek
SA=szam;
SO=szoveg;
SASO=szamESszoveg;

M=2;

% M=1           KEI: HDS üzem fogyasztott fûtõgáz           az Excelben a 2.oszlop, SA-nban az 1., azaz az M. !
% M=2           KEI: HDS üzem fogyasztott gõz               az Excelben a 3.oszlop, SA-nban az 2., azaz az M. !
% M=3           KEI: HDS üzem technológiai gõzfogyasztás    az Excelben a 4.oszlop, SA-nban az 3., azaz az M. !       
% M=4           KEI: HDS üzem termelt gõz                   az Excelben a 5.oszlop, SA-nban az 4., azaz az M. !
% M=5           KEI: HDS üzem villamos energia fogyasztás   az Excelben a 6.oszlop, SA-nban az 5., azaz az M. !     

% a szûretlen értékek mátrixa: SE

SE=[SA(:,M) SA(:,6:end)];         % a számokat tartalmazó mátrix 6. oszlopában kezdõdnek a potenciálisan releváns független változók

% Kiszûrjük azokat a sorokat, amelyekben számadat helyett az Excelben "No Good Data..." szerepelt.
% Ezeken a helyeken az SA-ban NaN szerepel, ez lesz a szûrés alapelve.
% A szûrt, már csak számadatokat tartalmazó mátrix: E.

E=SE;
i=1;
vege=0;
while vege==0
    if nnz(isnan(E(i,:))) ~=0      % ha az adott sorban van NaN, akkor az isnan vaktorban lesz 0-tól különbözõ elem, és így erre a vektorra az nnz függvény 0-tól különbözõ eredményt ad ---- ha ez történik, töröljük az aktuális sort!
        E(i,:)=[];
    else
        i=i+1;          % ha töröltem egy sort, nem növelem i-t, mert a következõ ciklusban azt a sort vizsgálom, ami ebben a ciklusban még i+1. volt, de a törlés miatt i. lett
    end
    if i+1>length(E(:,1))   % ha a következõ vizsgálandó sor már nem is létezik, mert a mátrix aljára értünk, akkor leáll a szûrés
        vege=1;
    end
end

% Ellenõrzés:  numel(E) egyenlõ numel(isnan(E)) -vel? 
%%
komponensek=cell(1,length(E(1,:)));
komponensek(1,1)=SO(2,M+1);
komponensek(1,2:end)=SO(2,7:end)

sD=som_data_struct(E,'comp_names', komponensek)
sM=som_make(sD,'msize',[40 30])          % sM=som_make(sD,'lattice','rect')
figure(1)
som_show(sM,'umat','all','comp',[1:8])
figure(2)
som_show(sM,'umat','all','comp',[9:16])
figure(3)
som_show(sM,'umat','all','comp',[17:24])
figure(4)
som_show(sM,'umat','all','comp',[25:32])
figure(5)
som_show(sM,'umat','all','comp',[33:40])
figure(6)
som_show(sM,'umat','all','comp',[41:48])
figure(7)
som_show(sM,'umat','all','comp',[49:56])
figure(8)
som_show(sM,'umat','all','comp',[57:64])    
figure(9)
som_show(sM,'umat','all','comp',[65:72]) 
figure(10)
som_show(sM,'umat','all','comp',[73:79])
