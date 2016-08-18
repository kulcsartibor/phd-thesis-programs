% ! A 2007b MATLABban az STRFIND függvény nagybetûkkel leírva ismûködött,
% de a 2013a-ban már csupa kisbetûvel írva (strfind) fut csak le.

clc
clear all
format long

% -------------------------------------------------------------------------
% 1.1. lépés:
% A számítások alapját képezõ adathalmaz készítése a "modellek_HDS.xlsx" szerkezete alapján.
% Feltételezések:
% 1) az adatok az 1. munkalapon találhatóak
% 2) az elsõ 2 oszlop és elsõ 2 sor csak szöveg

[szam, szoveg, szamESszoveg] = xlsread('modellek_HDS.xlsx',1); % Három készül: az egyik csak a számadatokat tartalmazza, a második csak a szöveges adatokat, a harmadik minden adatot.
[a,b]=size(szam);
[c,d]=size(szoveg);         % c=a+2  d=b+2
[c,d]=size(szamESszoveg);   % SO és SASO méretei valóban egyeznek
SA=szam;
SO=szoveg;
SASO=szamESszoveg;

% 1.2. lépés:
% A modell kiválasztása

% M=1   Modell: HDS_FUTOGAZ_T                (EM_bem.docx 4. oldal)
%       N=6 (5 változó az egyenlet jobb oldalán, plusz 1: a target)
% 
% M=2   Modell: HDS_FOGY_GOZ_T               (EM_bem.docx 5. oldal)
%       N=6
% 
% M=3   Modell: HDS_GOZ_T                    (EM_bem.docx 5. oldal)
%       N=6
% 
% M=4   Modell: HDS_TERM_GOZ_T               (EM_bem.docx 6. oldal)
%       N=6
% 
% M=5   Modell: HDS_VILLEN_T                 (EM_bem.docx 7. oldal)
%       N=3

% Az N változó a modellben szereplõ összes változó száma. N-1 darab független
% változó van és 1 darab függõ változó. Az N. változó mindig a
% függõ változó, az 1., 2., ..., N-1. független vó.-k beolvasási sorrendje 
% az EM_bem.docx egyenleteiben látható sorrendet követi. 

M=4
Ngyujto=[6 6 6 6 3];            % Az Ngyujto vektor segítségével a modell számának megadása után N egyértelmû.     
N=Ngyujto(1,M)

% Az adott modellhez tartozó adatok kigyûjtése.

% Az adathalmazból meg kell keresünk a vizsgált mennyiségeket és azok
% naplózott értékeit. A VAL cella tartalmazza azokat a tag-eket, amelyeket
% meg kell keresni a szoveges adatokat tartalmazó tömbben. Az EM_bem.docx
% és az Excel néha különbözõ tag-gel jelöl egy adott mennyiséget. A VAL
% cella elemeinek meghatározásakor az Excel-fájl jelölése volt a
% meghatározó, hiszen abban kell majd megkeresni az egyes mennyiségeket. 

% -------------------------------------------------------------------------
% 2. lépés:
% A modellben szereplõ mennyiségek idõsorainak megkeresése.

if M==1
    VAL{1,1}='HFK2051'	;
    VAL{2,1}='O401 1. Kamra DT'    ;
    VAL{3,1}='O401 2. Kamra DT'  ;
    VAL{4,1}='HTK';
    VAL{5,1}='FG4 ATLAG_SURUSEG_NM3';
    VAL{6,1}='DHDS_EM_UNIT_FUELGAS.PV';        
elseif M==2
    VAL{1,1}='HFK2051';
    VAL{2,1}='HFT8008';
    VAL{3,1}='HFT8019';
    VAL{4,1}='HF5003';
    VAL{5,1}='HTK';
    VAL{6,1}='DHDS_EM_CONS_STEAM.PV';          
elseif M==3
    VAL{1,1}='HFK2051';
    VAL{2,1}='HFT8008';
    VAL{3,1}='HFT8019';
    VAL{4,1}='HF5003';
    VAL{5,1}='HTK';
    VAL{6,1}='DHDS_EM_TECHN_STEAM.PV';         
elseif M==4
    VAL{1,1}='HFK2051';
    VAL{2,1}='HFT8008';
    VAL{3,1}='HFT8019';
    VAL{4,1}='HF5003';
    VAL{5,1}='HTK';
    VAL{6,1}='DHDS_EM_PROD_STEAM.PV';          
elseif M==5
    VAL{1,1}='HFK2051';
    VAL{2,1}='HTK';                % Változó még elvileg a "Friss H2 tisztaság" is, de erre nincs adat az Excelben, és a molos modell sem veszi figyelembe.
    VAL{3,1}='DHDS_EM_UNIT_ELEC.PV';           
end

syms V

[t,u]=size(SO);
for k=1:1:N
    V=VAL(k,1);
    for j=1:1:t
    for i=1:1:u
        S=SO(j,i);
        K=strfind(S,V{1,1}) ;            % V egy cell!!!!!
        EMPT=isempty(K{1,1});           % K egy cell!!!! 1. sorának 1. oszolpában a mátrix üres? Ha igen, a válasz 1, egyébként 0. Nekünk az lesz a fontos, ahol 0!!!!
        if EMPT==0
            x=1;
            while x <= c-2
            ERTEKEK_SZURETLEN(x,k)=SASO{x+2,i}(1,1);
            x=x+1;
            end
        end
    end
    end
end

% -------------------------------------------------------------------------
% 3. lépés:
% Az értékelhetõ adatok kiszûrése az idõsorokból.
% 
% Van olyan modell, amelyiknél a rendelkezése álló függõ változóidõsor elsõ
% néhány eleme "No Good Data For Calculation". Ezeket és az ezekhez tartozó
% független vó.-értékeket le kell vágni az ERTEKEK_SZURETLEN-bõl, 
% és a maradékkal kell késõbb dolgozni. 
% 
% Elv:
% - megkeressük a függõ vó. oszlopát
% - ebben megkeresssük a legutolsó sort, amelyben még No GOod Data van
% - eközben növelünk egy indexet, amelynek végsõ értéke éppen az az egész szám,
%   ahányadik a No Good Data utolsó sora
% - ennyi sorral csökkentjük az ERTEKEK_SZURETLEN minden oszlopát
% 
% Segítség: a V aktuális értéke éppen a felsorolás szerinti legutolsó mennyiség,
% és ez a felsorolási elvem szerint éppen a függõ vó.!

[t,u]=size(SO);
a=0;
i=1;
while a==0
        S=SO(2,i);
        K=strfind(S,V{1,1}) ;
        EMPT=isempty(K{1,1});           
        if EMPT==0
            a=1;
            celoszlopa=i;
        end
        i=i+1;
end

nogood='No Good Data';
i=1;
j=0,
K=strfind(SO(3,celoszlopa),nogood);
if K{1,1}==0            %Ahol az Excelben "[-11059] No Good Data For Calculation" van, ott, K = [10] lesz  (a lényeg, hogy nem üres), ahol már számadat, ott K = {[]}  (a lényeg, hogy üres). 
    ERTEKEK=ERTEKEK_SZURETLEN;
    p=c-2;
else
    while j==0
    K=strfind(SO(2+i,celoszlopa),nogood); 
    if K{1,1}~=0
        j=0;
        i=i+1;
    else
        j=1;
        for q=1:1:N
        for p=1:1:t-1-i   
            ERTEKEK(p,q)=ERTEKEK_SZURETLEN(p+i-1,q); 
        end
        end
    end
    end
end

% -------------------------------------------------------------------------
% 4. lépés:
% A modellparaméterek becslése nemlineáris regresszióval.

if M==1
%Modell: HDS_FUTOGAZ_T [t/h] = 
%           a * HFK2051^b + c * (HO401_DELTA1 + HO401_DELTA2)/2 + d * HTK +
%           e * HDS_FUTOGAZ_SUR + bias
    modelfun = @(B,x)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)+ERTEKEK(:,3))*0.5 + B(4)*ERTEKEK(:,4) + B(5)*ERTEKEK(:,5)+B(6)
    beta0 = [1 1 1 1 1 1];
elseif M==2
%Modell: HDS_FOGY_GOZ_T [GJ/h] =
%       a * HFK2051^b + c * (HFC8008+HFC8019)+ d * HF5003 + e * HTK + bias
    modelfun = @(B,x)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)+ERTEKEK(:,3)) + B(4)*ERTEKEK(:,4) + B(5)*ERTEKEK(:,5)+B(6)
    beta0 = [39 1 1 1 1 59];
elseif M==3
%Modell: HDS_GOZ_T [t/h] = 
%       a * HFK2051^b + c * (HFC8008+HFC8019) + d * HF5003 – e * HTK + bias
    modelfun = @(B,x)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)+ERTEKEK(:,3)) + B(4)*ERTEKEK(:,4) - B(5)*ERTEKEK(:,5)+B(6)
    beta0 = [3   0.26  0   0  0  10];
elseif M==4
%Modell: HDS_TERM_GOZ_T [GJ/h] =
%       a * HFK2051^b + c * (HFC8008+HFC8019) + d * HF5003 + e * HTK + bias
    modelfun = @(B,x)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)+ERTEKEK(:,3)) + B(4)*ERTEKEK(:,4) + B(5)*ERTEKEK(:,5)+B(6)
    beta0 = [1 1 1 1 1 1];   
elseif M==5
%Modell: HDS_VILLEN_T [GJ/h] = 
%       a * HFK2051^b + c * HTK (((+ d * H_FRISSH2))) + bias
    modelfun = @(B,x)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)) + B(4)
    beta0 = [1 1 1 1]; 
end

B = nlinfit(ERTEKEK(:,1:N-1),ERTEKEK(:,N),modelfun,beta0)
%A beállításokba belenyúlhatunk - LSCURVEFIT:
   % oldopts=optimset('lsqcurvefit')
   % options=optimset(oldopts,'MaxFunEvals',7000,'MaxIter',1000) 
   % B = lsqcurvefit(modelfun,beta0,ERTEKEK(:,1:N-1),ERTEKEK(:,N), [], [], options)
%A beállításokba belenyúlhatunk - NLINFIT:
   % oldset=statset
   % options=optimset(oldset,'MaxIter',1000000000) 
   % B = nlinfit(ERTEKEK(:,1:N-1),ERTEKEK(:,N),modelfun,beta0, options)

% -------------------------------------------------------------------------
% 5. lépés:
% A saját modellparaméterek alapján célértékeket számítunk ("....._SAJAT_REGRESSZ").
% A MOL-paraméterek alapján célértékeket számítunk ("....._MOLOS_REGRESSZ").
% A saját pataméterekkel számolt célértékek és a függõ változó rendelkezére álló értékei között korrelációs együtthatómátrixot számolunk ("R_SAJAT_M").
% A MOL-paraméterekkel számolt célértékek és a rendelkezésre álló értékek között korrelációs együtthatómátrixot számolunk ("R_MOLOS_M").
% E mátrixok fõátlóiban 1-esek szerepelnek. Mivel csak 2 idõsorból számoltuk a mátrixot, ezért a többi elem éppen a két idõsor közötti korrelációs együttható (R_SAJAT és R_MOLOS). 

for x=1:1:p
    if M==1
        HDS_FUTOGAZ_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1).^B(2) + B(3)*(ERTEKEK(x,2)+ERTEKEK(x,3))*0.5 + B(4)*ERTEKEK(x,4) + B(5)*ERTEKEK(x,5)+B(6);
    elseif M==2
        HDS_FOGY_GOZ_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1).^B(2) + B(3)*(ERTEKEK(x,2)+ERTEKEK(x,3)) + B(4)*ERTEKEK(x,4) + B(5)*ERTEKEK(x,5)+B(6);
    elseif M==3
        HDS_GOZ_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1).^B(2) + B(3)*(ERTEKEK(x,2)+ERTEKEK(x,3)) + B(4)*ERTEKEK(x,4) - B(5)*ERTEKEK(x,5)+B(6);
    elseif M==4
        HDS_TERM_GOZ_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1).^B(2) + B(3)*(ERTEKEK(x,2)+ERTEKEK(x,3)) + B(4)*ERTEKEK(x,4) + B(5)*ERTEKEK(x,5)+B(6);
    elseif M==5
        HDS_VILLEN_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1).^B(2) + B(3)*(ERTEKEK(x,2)) + B(4);
    end
end

for x=1:1:p
    if M==1
        HDS_FUTOGAZ_T_MOLOS_REGRESSZ(x,1)=0.000143*ERTEKEK(x,1).^1.5 + 0.019763*(ERTEKEK(x,2)+ERTEKEK(x,3))*0.5 -0.00146*ERTEKEK(x,4) + 0.619604*ERTEKEK(x,5)-0.25028;
    elseif M==2
        HDS_FOGY_GOZ_T_MOLOS_REGRESSZ(x,1)=0.0323*ERTEKEK(x,1).^0.782 + 0.316*(ERTEKEK(x,2)+ERTEKEK(x,3)) + 1.254*ERTEKEK(x,4) -0.3735*ERTEKEK(x,5)+22.84;        
    elseif M==3
        HDS_GOZ_T_MOLOS_REGRESSZ(x,1)=0.07827 *ERTEKEK(x,1).^0.6984 + 0.138*(ERTEKEK(x,2)+ERTEKEK(x,3)) + 0.276*ERTEKEK(x,4) - 0.02*ERTEKEK(x,5)+2.21;
    elseif M==4
        HDS_TERM_GOZ_T_MOLOS_REGRESSZ(x,1)=0.12827*ERTEKEK(x,1).^1 -0.00233211*(ERTEKEK(x,2)+ERTEKEK(x,3)) - 0.5428579*ERTEKEK(x,4) - 0.0110716 *ERTEKEK(x,5)+0.04967795;
    elseif M==5
        HDS_VILLEN_T_MOLOS_REGRESSZ(x,1)=2.855*ERTEKEK(x,1).^1.22 -9.45*(ERTEKEK(x,2)) + 6001;
    end
end

if M==1
    R_SAJAT_M = corrcoef(HDS_FUTOGAZ_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HDS_FUTOGAZ_T_MOLOS_REGRESSZ,ERTEKEK(:,N));
elseif M==2
    R_SAJAT_M = corrcoef(HDS_FOGY_GOZ_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HDS_FOGY_GOZ_T_MOLOS_REGRESSZ,ERTEKEK(:,N));
elseif M==3
    R_SAJAT_M = corrcoef(HDS_GOZ_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HDS_GOZ_T_MOLOS_REGRESSZ,ERTEKEK(:,N));
elseif M==4
    R_SAJAT_M = corrcoef(HDS_TERM_GOZ_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HDS_TERM_GOZ_T_MOLOS_REGRESSZ,ERTEKEK(:,N));
elseif M==5
    R_SAJAT_M=  corrcoef(HDS_VILLEN_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HDS_VILLEN_T_MOLOS_REGRESSZ,ERTEKEK(:,N));
end

R_SAJAT =R_SAJAT_M(1,2);
R_MOLOS =R_MOLOS_M(1,2);

% A korrelációs együtthatót természetesen ki lehet számolni olyan elemi 
% számításokkal, amelyekkel papíron is dolgoznánk. Ilyen részletes
% ellenõrzõ számítást nem csináltam, de a két adott mennyiség
% koverianciáját elosztva a két mennyiség szórásának szorzatával, 
% megkaphatjuk a két idõsor korrelációs együtthatóját. Ez elegendõ az ellenõrzéshez. 
% Az ellenõrzés szerint R_SAJAT és R_MOLOS fenti számítása helyes volt!
% Ellenõrzés pl. R_SAJAT-ra:
% COV_SAJAT=cov(HDS_FUTOGAZ_T_SAJAT_REGRESSZ,ERTEKEK(:,N))
% D_SAJAT_REGR=std(HDS_FUTOGAZ_T_SAJAT_REGRESSZ)
% D_ADAT=std(ERTEKEK(:,N))
% R_SAJAT=COV_SAJAT(1,2)/(D_SAJAT_REGR*D_ADAT)

% -------------------------------------------------------------------------
% 6. lépés:
% Grafikonon ábrázoljuk 
% - a függõ változó adott értékeit,
% - a saját modellparaméterek esetén adódó célértékeket,
% - a MOL-paraméterek esetén adódó célértékeket.
% Kiíratjuk a korrelációs együtthatókat is.

if M==1
    ADAT_SAJAT=HDS_FUTOGAZ_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HDS_FUTOGAZ_T_MOLOS_REGRESSZ;
elseif M==2
    ADAT_SAJAT=HDS_FOGY_GOZ_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HDS_FOGY_GOZ_T_MOLOS_REGRESSZ;
elseif M==3
    ADAT_SAJAT=HDS_GOZ_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HDS_GOZ_T_MOLOS_REGRESSZ;
elseif M==4
    ADAT_SAJAT=HDS_TERM_GOZ_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HDS_TERM_GOZ_T_MOLOS_REGRESSZ;
elseif M==5
    ADAT_SAJAT=HDS_VILLEN_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HDS_VILLEN_T_MOLOS_REGRESSZ;    
end

t=[1:p];
whitebg('black');
plot(t,ERTEKEK(:,N),'g')
hold on 
plot(t,ADAT_SAJAT(:,1),'r')
hold on 
plot(t,ADAT_MOLOS(:,1),'b')
hold on 
legend('a függõ változó adott értékei','saját modell eredménye','molos modell eredménye')
xlabel('Idõ (t) [h]');
xlim;                                   % Az xlim nélkül a diagramon csak az  idõtartománynak - a MATLAB által automatikusan választott hosszúságú - utolsó szakasza jelenik meg. Az  xlim függvény argumentum nélkülni beírásával a teljes idõsor látható.
if M==1
    ylabel('Üzemi szintû fûtõgázfogyasztás [t/h]');
elseif M==2
    ylabel('Üzemi szintû gõz(hõ)fogyasztás [GJ/h]');
elseif M==3
    ylabel('Üzemi szintû technológiai gõz(hõ)fogyasztás  [GJ/h]');
elseif M==4
    ylabel('Üzemi szintû gõz(hõ)termelés   [GJ/h]');    
elseif M==5
    ylabel('Üzemi szintû villamos energiafogyasztás [kWh]');        
end


{'Saját modell szerinti korrelációs e.h.','MOL-modell szerinti korrelációs e.h.';R_SAJAT,R_MOLOS}
