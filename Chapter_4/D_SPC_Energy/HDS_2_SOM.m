%  A HDS_2.xlsx-BEN (JELENLEG) MINDEN KEI ESET�N 79 KOMPONENS LESZ:
%  78 F�GGETLEN V�LTOZ�, PLUSZ A KEI.
%  79 T�RK�PET EGY �BRACSOPORTRA FELTENNI �RTELMETLEN: NEM L�THAT�AK AZ
%  EGYES T�RK�PEK...
%  K�L�N figure-OKRA RAKOK 8-8 T�RK�PET, PLUSZ MINDEN FIGURE-ON RAJTA LESZ
%  (AZ �SSZE KOMPONENSRE K�SZ�TETT) u-m�TRIX IS.
%  ATT�L F�GGETLEN�L, HOGY EGY �BR�N H�NY T�RK�P SZEREPEL, A PROGRAM OLAN
%  ALAK� �S M�RET� T�RK�PET K�SZ�T, MINTHA MINDEN T�RK�P EGY �BR�RA LENNE
%  FELZS�FOLVA. EZ�RT A T�RK�P M�RET�T IS DEFINI�LNI KELL.

clc
clear all
format long
global ERTEKEK N

[szam, szoveg, szamESszoveg] = xlsread('HDS_2.xlsx',1);
[a,b]=size(szam);
[c,d]=size(szoveg);         % c=a+3  d=b+1
[c,d]=size(szamESszoveg);   % SO �s SASO m�retei val�ban egyeznek
SA=szam;
SO=szoveg;
SASO=szamESszoveg;

M=2;

% M=1           KEI: HDS �zem fogyasztott f�t�g�z           az Excelben a 2.oszlop, SA-nban az 1., azaz az M. !
% M=2           KEI: HDS �zem fogyasztott g�z               az Excelben a 3.oszlop, SA-nban az 2., azaz az M. !
% M=3           KEI: HDS �zem technol�giai g�zfogyaszt�s    az Excelben a 4.oszlop, SA-nban az 3., azaz az M. !       
% M=4           KEI: HDS �zem termelt g�z                   az Excelben a 5.oszlop, SA-nban az 4., azaz az M. !
% M=5           KEI: HDS �zem villamos energia fogyaszt�s   az Excelben a 6.oszlop, SA-nban az 5., azaz az M. !     

% a sz�retlen �rt�kek m�trixa: SE

SE=[SA(:,M) SA(:,6:end)];         % a sz�mokat tartalmaz� m�trix 6. oszlop�ban kezd�dnek a potenci�lisan relev�ns f�ggetlen v�ltoz�k

% Kisz�rj�k azokat a sorokat, amelyekben sz�madat helyett az Excelben "No Good Data..." szerepelt.
% Ezeken a helyeken az SA-ban NaN szerepel, ez lesz a sz�r�s alapelve.
% A sz�rt, m�r csak sz�madatokat tartalmaz� m�trix: E.

E=SE;
i=1;
vege=0;
while vege==0
    if nnz(isnan(E(i,:))) ~=0      % ha az adott sorban van NaN, akkor az isnan vaktorban lesz 0-t�l k�l�nb�z� elem, �s �gy erre a vektorra az nnz f�ggv�ny 0-t�l k�l�nb�z� eredm�nyt ad ---- ha ez t�rt�nik, t�r�lj�k az aktu�lis sort!
        E(i,:)=[];
    else
        i=i+1;          % ha t�r�ltem egy sort, nem n�velem i-t, mert a k�vetkez� ciklusban azt a sort vizsg�lom, ami ebben a ciklusban m�g i+1. volt, de a t�rl�s miatt i. lett
    end
    if i+1>length(E(:,1))   % ha a k�vetkez� vizsg�land� sor m�r nem is l�tezik, mert a m�trix alj�ra �rt�nk, akkor le�ll a sz�r�s
        vege=1;
    end
end

% Ellen�rz�s:  numel(E) egyenl� numel(isnan(E)) -vel? 
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
