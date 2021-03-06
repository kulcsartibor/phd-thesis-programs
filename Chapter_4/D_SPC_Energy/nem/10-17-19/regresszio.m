% ! A 2007b MATLABban az STRFIND f�ggv�ny nagybet�kkel le�rva ism�k�d�tt,
% de a 2013a-ban m�r csupa kisbet�vel �rva (strfind) fut csak le.

clc 
clear all
format long
global ERTEKEK N

% -------------------------------------------------------------------------
% 1.1. l�p�s:
% A sz�m�t�sok alapj�t k�pez� adathalmaz k�sz�t�se a "modellek_HDS.xlsx" szerkezete alapj�n.
% Felt�telez�sek:
% 1) az adatok az 1. munkalapon tal�lhat�ak
% 2) az els� 2 oszlop �s els� 2 sor csak sz�veg    !!!!!!!

[szam, szoveg, szamESszoveg] = xlsread('M_10_feldolgozhat�.xlsx',1); % H�rom k�sz�l: az egyik csak a sz�madatokat tartalmazza, a m�sodik csak a sz�veges adatokat, a harmadik minden adatot.
[a,b]=size(szam);
[c,d]=size(szoveg);         % c=a+2  d=b+2
[c,d]=size(szamESszoveg);   % SO �s SASO m�retei val�ban egyeznek
SA=szam;
SO=szoveg;
SASO=szamESszoveg;

% 1.2. l�p�s:
% A modell kiv�laszt�sa

% Az N v�ltoz� a modellben szerepl� �sszes v�ltoz� sz�ma. N-1 darab f�ggetlen
% v�ltoz� van �s 1 darab f�gg� v�ltoz�. Az N. v�ltoz� mindig a
% f�gg� v�ltoz�, az 1., 2., ..., N-1. f�ggetlen v�.-k beolvas�si sorrendje 
% az EM_bem.docx egyenleteiben l�that� sorrendet k�veti. 

M=10
Ngyujto=[6 6 6 6 3 4 0 0 0 4 0 5 8 5 0 0 5 4 4];            % Az Ngyujto vektor seg�ts�g�vel a modell sz�m�nak megad�sa ut�n N egy�rtelm�.     
N=Ngyujto(1,M)

% Az adott modellhez tartoz� adatok kigy�jt�se.

% Az adathalmazb�l meg kell keres�nk a vizsg�lt mennyis�geket �s azok
% napl�zott �rt�keit. A VAL cella tartalmazza azokat a tag-eket, amelyeket
% meg kell keresni a szoveges adatokat tartalmaz� t�mbben. Az EM_bem.docx
% �s az Excel n�ha k�l�nb�z� tag-gel jel�l egy adott mennyis�get. A VAL
% cella elemeinek meghat�roz�sakor az Excel-f�jl jel�l�se volt a
% meghat�roz�, hiszen abban kell majd megkeresni az egyes mennyis�geket. 

% -------------------------------------------------------------------------
% 2. l�p�s:
% A modellben szerepl� mennyis�gek id�sorainak megkeres�se.

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
    VAL{2,1}='HTK';                % V�ltoz� m�g elvileg a "Friss H2 tisztas�g" is, de erre nincs adat az Excelben, �s a molos modell sem veszi figyelembe.
    VAL{3,1}='DHDS_EM_UNIT_ELEC.PV'; 
elseif M==6
    VAL{1,1}='DHDSHFF2052.PVA';
    VAL{2,1}='DHDSHTCH4116.PVA';
    VAL{3,1}='DHDSHTCH4117.PVA';
    VAL{4,1}='DHDS_EM_HO401_TIN.PV';    
elseif M==10
    VAL{1,1}='DHDSHT1275.PVA';
    VAL{2,1}='DHDSHF4011.PV';
    VAL{3,1}='DBK5RTI1000.DACA.PV';
    VAL{4,1}='DHDS_EM_HO403_TOUT.PV';    
elseif M==12
    VAL{1,1}='DHDSGO_S.LA';
    VAL{2,1}='DHDSHDSKONV.PVA';
    VAL{3,1}='DHDSGO_E95.LA';
    VAL{4,1}='DHDSHT2118.PVA';
    VAL{5,1}='DHDS_EM_K201_SRAT.PV';
elseif M==13
    VAL{1,1}='DHDSHF2005';
    VAL{2,1}='DHDSHF2010';
    VAL{3,1}='DHDSHF2020';
    VAL{4,1}='DHDSHT2122';
    VAL{5,1}='DHDSHT2118';    
    VAL{6,1}='DHDSHFCA2008';    
    VAL{7,1}='DBK5RTI1000';     
    VAL{8,1}='K201 Fejnyom�s'; 
elseif M==14
    VAL{1,1}='DHDSGO_KFP.LA';
    VAL{2,1}='DHDSHDSKONV.PVA';
    VAL{3,1}='DHDSGO_S.LA';
    VAL{4,1}='DHDSHT4101.PVA'; 
    VAL{5,1}='DHDS_EM_K202_SRAT.PV'; 
elseif M==17
    VAL{1,1}='DHDSHFK7001.PV';
    VAL{2,1}='DHDSHPA7313.PVA';
    VAL{3,1}='DHDSHPH7327.PVA';
    VAL{4,1}='DBK5RTI1000.DACA.PV';
    VAL{5,1}='DHDS_EM_V301_DRAIN.PV';    
elseif M==18
    VAL{1,1}='DHDSHF7001.PV';
    VAL{2,1}='DBK5RTI1000.DACA.PV';
    VAL{3,1}='DHDSHT6106.PVA';
    VAL{4,1}='DHDS_EM_V301_TIN.PV';
elseif M==19
    VAL{1,1}='DHDSHFC3002.PV';
    VAL{2,1}='DHDSHP7361.PVA';
    VAL{3,1}='DHDSHP7356.PVA';
    VAL{4,1}='DHDS_EM_V302_DRAIN.PV';
end


[t,u]=size(SO);
for k=1:1:N
    V=VAL(k,1);
    for j=1:1:t
    for i=1:1:u
        S=SO(j,i);
        K=strfind(S,V{1,1}) ;            % V egy cell!!!!!
        EMPT=isempty(K{1,1});           % K egy cell!!!! 1. sor�nak 1. oszolp�ban a m�trix �res? Ha igen, a v�lasz 1, egy�bk�nt 0. Nek�nk az lesz a fontos, ahol 0!!!!
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
% 3. l�p�s:
% Az �rt�kelhet� adatok kisz�r�se az id�sorokb�l.
% 
% Van olyan modell, amelyikn�l a rendelkez�se �ll� f�gg� v�ltoz�id�sor els�
% n�h�ny eleme "No Good Data For Calculation". Ezeket �s az ezekhez tartoz�
% f�ggetlen v�.-�rt�keket le kell v�gni az ERTEKEK_SZURETLEN-b�l, 
% �s a marad�kkal kell k�s�bb dolgozni. 
% 
% Elv:
% - megkeress�k a f�gg� v�. oszlop�t
% - ebben megkeresss�k a legutols� sort, amelyben m�g No GOod Data van
% - ek�zben n�vel�nk egy indexet, amelynek v�gs� �rt�ke �ppen az az eg�sz sz�m,
%   ah�nyadik a No Good Data utols� sora
% - ennyi sorral cs�kkentj�k az ERTEKEK_SZURETLEN minden oszlop�t
% 
% Seg�ts�g: a V aktu�lis �rt�ke �ppen a felsorol�s szerinti legutols� mennyis�g,
% �s ez a felsorol�si elvem szerint �ppen a f�gg� v�.!

[t,u]=size(SO);
a=0;
i=1;
s=1;
while a==0
        S=SO(s,i);
        K=strfind(S,V{1,1}) ;
        EMPT=isempty(K{1,1});           
        if EMPT==0
            a=1;
            celoszlopa=i;
        end
        if i < N+2
            i=i+1;
        else
            i=1;
            s=2;
        end
end

nogood='No Good Data';
i=1;
j=0,
K=strfind(SO(3,celoszlopa),nogood);
if K{1,1}==0            %Ahol az Excelben "[-11059] No Good Data For Calculation" van, ott, K = [10] lesz  (a l�nyeg, hogy nem �res), ahol m�r sz�madat, ott K = {[]}  (a l�nyeg, hogy �res). 
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
% 4. l�p�s:
% A modellparam�terek becsl�se nemline�ris regresszi�val.

if M==1
%Modell: HDS_FUTOGAZ_T [t/h] = 
%           a * HFK2051^b + c * (HO401_DELTA1 + HO401_DELTA2)/2 + d * HTK +
%           e * HDS_FUTOGAZ_SUR + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)+ERTEKEK(:,3))*0.5 + B(4)*ERTEKEK(:,4) + B(5)*ERTEKEK(:,5)+B(6)
    beta0 = [1 1 1 1 1 1];
elseif M==2
%Modell: HDS_FOGY_GOZ_T [GJ/h] =
%       a * HFK2051^b + c * (HFC8008+HFC8019)+ d * HF5003 + e * HTK + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)+ERTEKEK(:,3)) + B(4)*ERTEKEK(:,4) + B(5)*ERTEKEK(:,5)+B(6)
    beta0 = [39 1 1 1 1 59];
elseif M==3
%Modell: HDS_GOZ_T [t/h] = 
%       a * HFK2051^b + c * (HFC8008+HFC8019) + d * HF5003 � e * HTK + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)+ERTEKEK(:,3)) + B(4)*ERTEKEK(:,4) - B(5)*ERTEKEK(:,5)+B(6)
    beta0 = [3   0.26  0   0  0  10];
elseif M==4
%Modell: HDS_TERM_GOZ_T [GJ/h] =
%       a * HFK2051^b + c * (HFC8008+HFC8019) + d * HF5003 + e * HTK + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)+ERTEKEK(:,3)) + B(4)*ERTEKEK(:,4) + B(5)*ERTEKEK(:,5)+B(6)
    beta0 = [1 1 1 1 1 1];   
elseif M==5
%Modell: HDS_VILLEN_T [GJ/h] = 
%       a * HFK2051^b + c * HTK (((+ d * H_FRISSH2))) + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1).^B(2) + B(3)*(ERTEKEK(:,2)) + B(4)
    beta0 = [1 1 1 1]; 
elseif M==6
%Modell: HO401_WA_TIN_T [�C] =
%       a * HFF2052 + b * HTCH4116 + c * HTCH4117 + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1) + B(2)*ERTEKEK(:,2) + B(3)*ERTEKEK(:,3)+ B(4)
    beta0=[1 1 1 1];
elseif M==10
% Modell: HTCH4161_T [�C] = a * HT1275 + b * HF4011 + c * HTK + bias  
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1) + B(2)*ERTEKEK(:,2) + B(3)*ERTEKEK(:,3)+ B(4)
    beta0=[1 1 1 1];
elseif M==12
% Modell: HSTM2RAFK201_T = a * HGO_S + b * HDSKONV + c * HGO_E95 + d * HT2118 + bias  
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1) + B(2)*ERTEKEK(:,2) + B(3)*ERTEKEK(:,3)+ B(4)*ERTEKEK(:,4)+B(5)
    beta0=[1 1 1 1 1];    
elseif M==13
% Modell: HP2333_T= a * (HFK2005 + HFK2010 + HFK2020)+ b * HT2122 + c * HT2118 + d * HFCA2008 + e * HTK + bias  
    modelfun = @(B,ERTEKEK)B(1)*(ERTEKEK(:,1) + ERTEKEK(:,2)+ ERTEKEK(:,3))+ B(2)*ERTEKEK(:,4)+B(3)*ERTEKEK(:,5)+B(4)*ERTEKEK(:,6)+B(5)*ERTEKEK(:,7)+B(6)
    beta0=[1 1 1 1 1 1];
elseif M==14
%Modell: HSTM2DSLK201_T = a * HGO_KFP + b *HDSKONV + c *HGO_S + d * HT4101 + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1) + B(2)*ERTEKEK(:,2) + B(3)*ERTEKEK(:,3)+ B(4)*ERTEKEK(:,4)+B(5);
    beta0=[1 1 1 1 1];
elseif M==17
%Modell: HI7501_T = a * HF7001 + b * HPA7313 + c * HPH7327 + d * HTK + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1) + B(2)*ERTEKEK(:,2) + B(3)*ERTEKEK(:,3)+ B(4)*ERTEKEK(:,4)+B(5);
    beta0=[1 1 1 1 1];    
elseif M==18
%Modell: HTA3125_T = a * HF7001 + b * HTK + c * HT6106 + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1) + B(2)*ERTEKEK(:,2) + B(3)*ERTEKEK(:,3)+ B(4)
    beta0=[1 1 1 1];
elseif M==19
%Modell: HI7502_T= a * HFC3002 + b * HP7361 + c * HP7356 + bias
    modelfun = @(B,ERTEKEK)B(1)*ERTEKEK(:,1) + B(2)*ERTEKEK(:,2) + B(3)*ERTEKEK(:,3)+ B(4)
    beta0=[1 1 1 1];
end

B = nlinfit(ERTEKEK(:,1:N-1),ERTEKEK(:,N),modelfun,beta0)
%A be�ll�t�sokba beleny�lhatunk - LSCURVEFIT:
   % oldopts=statset('lsqcurvefit')
   % options=statset(oldopts,'MaxFunEvals',7000,'MaxIter',1000) 
   % B = lsqcurvefit(modelfun,beta0,ERTEKEK(:,1:N-1),ERTEKEK(:,N), [], [], options)
%A be�ll�t�sokba beleny�lhatunk - NLINFIT:
   % oldset=statset('nlinfit')
   % options=statset(oldset,'MaxIter',1000000000) 
   % B = nlinfit(ERTEKEK(:,1:N-1),ERTEKEK(:,N),modelfun,beta0) %, options)

% -------------------------------------------------------------------------
% 5. l�p�s:
% A saj�t modellparam�terek alapj�n c�l�rt�keket sz�m�tunk ("....._SAJAT_REGRESSZ").
% A MOL-param�terek alapj�n c�l�rt�keket sz�m�tunk ("....._MOLOS_REGRESSZ").
% A saj�t patam�terekkel sz�molt c�l�rt�kek �s a f�gg� v�ltoz� rendelkez�re �ll� �rt�kei k�z�tt korrel�ci�s egy�tthat�m�trixot sz�molunk ("R_SAJAT_M").
% A MOL-param�terekkel sz�molt c�l�rt�kek �s a rendelkez�sre �ll� �rt�kek k�z�tt korrel�ci�s egy�tthat�m�trixot sz�molunk ("R_MOLOS_M").
% E m�trixok f��tl�iban 1-esek szerepelnek. Mivel csak 2 id�sorb�l sz�moltuk a m�trixot, ez�rt a t�bbi elem �ppen a k�t id�sor k�z�tti korrel�ci�s egy�tthat� (R_SAJAT �s R_MOLOS). 

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
    elseif M==6
        HO401_WA_TIN_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1) + B(2)*ERTEKEK(x,2) + B(3)*ERTEKEK(x,3)+ B(4);
    elseif M==10
        HTCH4161_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1) + B(2)*ERTEKEK(x,2) + B(3)*ERTEKEK(x,3)+ B(4);
    elseif M==12
        HSTM2RAFK201_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1) + B(2)*ERTEKEK(x,2) + B(3)*ERTEKEK(x,3)+ B(4)*ERTEKEK(x,4)+B(5);
    elseif M==13
        HP2333_T_SAJAT_REGRESSZ(x,1)=B(1)*(ERTEKEK(x,1) + ERTEKEK(x,2) + ERTEKEK(x,3))+ B(2)*ERTEKEK(x,4)+B(3)*ERTEKEK(x,5)+B(4)*ERTEKEK(x,6)+B(5)*ERTEKEK(x,7)+B(6);
    elseif M==14
        HSTM2DSLK201_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1) + B(2)*ERTEKEK(x,2) + B(3)*ERTEKEK(x,3)+ B(4)*ERTEKEK(x,4)+B(5);    
    elseif M==17
        HI7501_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1) + B(2)*ERTEKEK(x,2) + B(3)*ERTEKEK(x,3)+ B(4)*ERTEKEK(x,4)+B(5);
    elseif M==18
        HTA3125_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1) + B(2)*ERTEKEK(x,2) + B(3)*ERTEKEK(x,3)+ B(4);
    elseif M==19
        HI7502_T_SAJAT_REGRESSZ(x,1)=B(1)*ERTEKEK(x,1) + B(2)*ERTEKEK(x,2) + B(3)*ERTEKEK(x,3)+ B(4);
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
    elseif M==6
        HO401_WA_TIN_T_MOLOS_REGRESSZ(x,1)=0.12*ERTEKEK(x,1) + 0.324*ERTEKEK(x,2) + 0.324*ERTEKEK(x,3)+ 90.2;
    elseif M==10
        HTCH4161_T_MOLOS_REGRESSZ(x,1)=0.859*ERTEKEK(x,1) + (-0.036)*ERTEKEK(x,2) + 0.0561*ERTEKEK(x,3)+ 68.55;
    elseif M==12
        HSTM2RAFK201_T_MOLOS_REGRESSZ(x,1)=-0.045*ERTEKEK(x,1) +  0.508*ERTEKEK(x,2) + 0.0415*ERTEKEK(x,3)- 0.231*ERTEKEK(x,4)+85.5;
    elseif M==13
        HP2333_T_MOLOS_REGRESSZ(x,1)=0.00121*(ERTEKEK(x,1) + ERTEKEK(x,2) + ERTEKEK(x,3))+ -0.000537*ERTEKEK(x,4)+0.00347*ERTEKEK(x,5)+0.00349*ERTEKEK(x,6)+0.00267*ERTEKEK(x,7)-0.75;
    elseif M==14
        HSTM2DSLK201_T_MOLOS_REGRESSZ(x,1)=0.0106*ERTEKEK(x,1) - 0.429*ERTEKEK(x,2) -0.0203*ERTEKEK(x,3)-0.0249*ERTEKEK(x,4)+22.8;    
    elseif M==17
        HI7501_T_MOLOS_REGRESSZ(x,1)=0.633*ERTEKEK(x,1) -6.21*ERTEKEK(x,2) + 10.56*ERTEKEK(x,3)+ 0.208*ERTEKEK(x,4)-347.8;
    elseif M==18
        HTA3125_T_MOLOS_REGRESSZ(x,1)=0.169*ERTEKEK(x,1) + 0.316*ERTEKEK(x,2) + 0.187*ERTEKEK(x,3)+ 23.4;   
    elseif M==19
        HI7502_T_MOLOS_REGRESSZ(x,1)=0.00379*ERTEKEK(x,1) + 3.85*ERTEKEK(x,2) - 4.095*ERTEKEK(x,3)+ 1.82;
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
elseif M==6
    R_SAJAT_M=  corrcoef(HO401_WA_TIN_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HO401_WA_TIN_T_MOLOS_REGRESSZ,ERTEKEK(:,N));   
elseif M==10
    R_SAJAT_M=  corrcoef(HTCH4161_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HTCH4161_T_MOLOS_REGRESSZ,ERTEKEK(:,N)); 
elseif M==12
    R_SAJAT_M=  corrcoef(HSTM2RAFK201_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HSTM2RAFK201_T_MOLOS_REGRESSZ,ERTEKEK(:,N));    
elseif M==13
    R_SAJAT_M=  corrcoef(HP2333_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HP2333_T_MOLOS_REGRESSZ,ERTEKEK(:,N));
elseif M==14
    R_SAJAT_M=  corrcoef(HSTM2DSLK201_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HSTM2DSLK201_T_MOLOS_REGRESSZ,ERTEKEK(:,N));    
elseif M==17
    R_SAJAT_M=  corrcoef(HI7501_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HI7501_T_MOLOS_REGRESSZ,ERTEKEK(:,N));    
elseif M==18
    R_SAJAT_M=  corrcoef(HTA3125_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HTA3125_T_MOLOS_REGRESSZ,ERTEKEK(:,N)); 
elseif M==19
    R_SAJAT_M=  corrcoef(HI7502_T_SAJAT_REGRESSZ,ERTEKEK(:,N));
    R_MOLOS_M = corrcoef(HI7502_T_MOLOS_REGRESSZ,ERTEKEK(:,N));
end

R_SAJAT =R_SAJAT_M(1,2);
R_MOLOS =R_MOLOS_M(1,2);

% A korrel�ci�s egy�tthat�t term�szetesen ki lehet sz�molni olyan elemi 
% sz�m�t�sokkal, amelyekkel pap�ron is dolgozn�nk. Ilyen r�szletes
% ellen�rz� sz�m�t�st nem csin�ltam, de a k�t adott mennyis�g
% koverianci�j�t elosztva a k�t mennyis�g sz�r�s�nak szorzat�val, 
% megkaphatjuk a k�t id�sor korrel�ci�s egy�tthat�j�t. Ez elegend� az ellen�rz�shez. 
% Az ellen�rz�s szerint R_SAJAT �s R_MOLOS fenti sz�m�t�sa helyes volt!
% Ellen�rz�s pl. R_SAJAT-ra:
% COV_SAJAT=cov(HDS_FUTOGAZ_T_SAJAT_REGRESSZ,ERTEKEK(:,N))
% D_SAJAT_REGR=std(HDS_FUTOGAZ_T_SAJAT_REGRESSZ)
% D_ADAT=std(ERTEKEK(:,N))
% R_SAJAT=COV_SAJAT(1,2)/(D_SAJAT_REGR*D_ADAT)

% -------------------------------------------------------------------------
% 6. l�p�s:
% Grafikonon �br�zoljuk 
% - a f�gg� v�ltoz� adott �rt�keit,
% - a saj�t modellparam�terek eset�n ad�d� c�l�rt�keket,
% - a MOL-param�terek eset�n ad�d� c�l�rt�keket.
% Ki�ratjuk a korrel�ci�s egy�tthat�kat is.

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
elseif M==6
    ADAT_SAJAT=HO401_WA_TIN_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HO401_WA_TIN_T_MOLOS_REGRESSZ;     
elseif M==10
    ADAT_SAJAT=HTCH4161_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HTCH4161_T_MOLOS_REGRESSZ; 
elseif M==12
    ADAT_SAJAT=HSTM2RAFK201_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HSTM2RAFK201_T_MOLOS_REGRESSZ; 
elseif M==13
    ADAT_SAJAT=HP2333_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HP2333_T_MOLOS_REGRESSZ;
elseif M==14
    ADAT_SAJAT=HSTM2DSLK201_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HSTM2DSLK201_T_MOLOS_REGRESSZ;    
elseif M==17
    ADAT_SAJAT=HI7501_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HI7501_T_MOLOS_REGRESSZ;    
elseif M==18
    ADAT_SAJAT=HTA3125_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HTA3125_T_MOLOS_REGRESSZ; 
elseif M==19
    ADAT_SAJAT=HI7502_T_SAJAT_REGRESSZ;
    ADAT_MOLOS=HI7502_T_MOLOS_REGRESSZ;     
end

t=[1:p];
whitebg('black');
plot(t,ERTEKEK(:,N),'g')
hold on 
plot(t,ADAT_SAJAT(:,1),'r')
hold on 
plot(t,ADAT_MOLOS(:,1),'b')
hold on 
legend('a f�gg� v�ltoz� adott �rt�kei','saj�t modell eredm�nye','molos modell eredm�nye')
xlabel('Id� (t) [h]');
xlim;                                   % Az xlim n�lk�l a diagramon csak az  id�tartom�nynak - a MATLAB �ltal automatikusan v�lasztott hossz�s�g� - utols� szakasza jelenik meg. Az  xlim f�ggv�ny argumentum n�lk�lni be�r�s�val a teljes id�sor l�that�.
if M==1
    ylabel('�zemi szint� f�t�g�zfogyaszt�s [t/h]');
elseif M==2
    ylabel('�zemi szint� g�z(h�)fogyaszt�s [GJ/h]');
elseif M==3
    ylabel('�zemi szint� technol�giai g�z(h�)fogyaszt�s  [GJ/h]');
elseif M==4
    ylabel('�zemi szint� g�z(h�)termel�s   [GJ/h]');    
elseif M==5
    ylabel('�zemi szint� villamos energiafogyaszt�s [kWh]'); 
elseif M==6
    ylabel('O401 s�lyozott bel�p� h�m�rs�klet [�C]');
elseif M==10
    ylabel('O403 kil�p� h�m�rs�klet  [�C]');
elseif M==12
    ylabel('K201 g�z/raffin�t ar�ny ');   
elseif M==13
    ylabel('K201 fejnyom�s c�l�rt�k [barg] ');    
elseif M==14
    ylabel('K202 g�z / g�zolaj ar�ny ');      
elseif M==17
    ylabel('V301 �ramfelv�tel  [A] ');    
elseif M==18
    ylabel('V301 bel�p� h�m�rs�klet  [�C] ');    
elseif M==19
    ylabel('V302-C �ramfelv�tel c�l�rt�k [A] ');
end


{'Saj�t modell szerinti korrel�ci�s e.h.','MOL-modell szerinti korrel�ci�s e.h.';R_SAJAT,R_MOLOS}