clc
clear all
format long
global ERTEKEK N

[szam, szoveg, szamESszoveg] = xlsread('HDS_1.xlsx',1);
[a,b]=size(szam);
[c,d]=size(szoveg);         % c=a+3  d=b+1
[c,d]=size(szamESszoveg);   % SO �s SASO m�retei val�ban egyeznek
SA=szam;
SO=szoveg;
SASO=szamESszoveg;

M=1;

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

%beviszem az id�t is (ez lesz az utols� oszlop):
[x,y]=size(E)
E=[E (linspace(1,x,x))']

% Ellen�rz�s:  numel(E) egyenl� numel(isnan(E)) -vel? 
%%
addpath .\somtoolbox
clear komponensek

komponensek=cell(1,length(E(1,:)));
komponensek(1,1)=SO(2,M+1);
[u,v]=size(SO);
komponensek(1,2:v-5)=SO(2,7:end)
komponensek{1,v-4}='Id�'
%%
sD=som_data_struct(E,'comp_names', komponensek)
sM=som_make(sD)          % sM=som_make(sD,'lattice','rect')

som_show(sM,'comp',[1 12])

bmus=som_bmus(sM,sD);
L=length(bmus);
n=0;
for i=[2:floor(L/20):20*floor(L/20) L]
    n=n+1   % csak az�rt �ratom ki, hogy l�ssam: a 21 �jrarajzol�s sor�n �ppen h�nyadikn�l tartunk
    som_show_add('traj',bmus(1:i),'SubPlot','all')
end


