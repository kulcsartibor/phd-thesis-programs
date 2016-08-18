clear all

[szam, szoveg, szamESszoveg] = xlsread('HDS_1.xlsx',1);
[a,b]=size(szam);
[c,d]=size(szoveg);         % c=a+3  d=b+1
[c,d]=size(szamESszoveg);   % SO és SASO méretei valóban egyeznek
SA=szam;
SO=szoveg;
SASO=szamESszoveg;

% Kiszûrjük azokat a sorokat, amelyekben számadat helyett az Excelben "No Good Data..." szerepelt.
% Ezeken a helyeken az SA-ban NaN szerepel, ez lesz a szûrés alapelve.
% A szûrt, már csak számadatokat tartalmazó mátrix: E.

E=SA;
TT=SO(4:end,1);

i=1;
vege=0;
n=1;
while vege==0
    if nnz(isnan(E(i,:))) ~=0      % ha az adott sorban van NaN, akkor az isnan vaktorban lesz 0-tól különbözõ elem, és így erre a vektorra az nnz függvény 0-tól különbözõ eredményt ad ---- ha ez történik, töröljük az aktuális sort!
        E(i,:)=[];
        TT(i,:)=[];	
    else
        i=i+1;          % ha töröltem egy sort, nem növelem i-t, mert a következõ ciklusban azt a sort vizsgálom, ami ebben a ciklusban még i+1. volt, de a törlés miatt i. lett
    end
    if i+1>length(E(:,1))   % ha a következõ vizsgálandó sor már nem is létezik, mert a mátrix aljára értünk, akkor leáll a szûrés
        vege=1;
    end
end

for i = 1:size(TT,1)
	try
		T(i,1)=datenum(TT(i),'yyyy.mm.dd. HH:MM:SS');
	catch
		try
			T(i,1)=datenum(TT(i),'yyyy.mm.dd. H:MM:SS');
		catch
			T(i,1)=datenum(TT(i),'yyyy.mm.dd.');
		end
	end
	
end

Full.T=T;
Full.y=E(:,1:4);
Full.x=E(:,5:end);
%% Validáláshoz adatszelektálás
% Minden 5.hét adataira lesz valid.

% 5*7*24=840
% 1*7*24=168
% 4*7*24=672
N=floor(length(Full.T)/840);
for i=1:N
    Val.x((i-1)*168+1:i*168,:)  =  Full.x((i*840-167):(i*840),:);  %% a kivett adatok (minden 5. hét)
    Val.y((i-1)*168+1:i*168,:)  =  Full.y((i*840-167):(i*840),:);
	Val.T((i-1)*168+1:i*168,:)  =  Full.T((i*840-167):(i*840),:);
end

for i=1:N
    Red.x((i-1)*672+1:i*672,:)  =  Full.x((i-1)*840+1:(i-1)*840+672,:); 
    Red.y((i-1)*672+1:i*672,:)  =  Full.y((i-1)*840+1:(i-1)*840+672,:);
	Red.T((i-1)*672+1:i*672,:)  =  Full.T((i-1)*840+1:(i-1)*840+672,:);
end
A=length(Red.x(:,1));
B=size(Full.y,1)-N*840;
Red.x(A+1:A+B,:)=Full.x(N*840+1:end,:);
Red.y(A+1:A+B,:)=Full.y(N*840+1:end,:);
Red.T(A+1:A+B,:)=Full.T(N*840+1:end,:);
%%
save('ESCAPE.mat','Full','Red','Val')
%%
komponensek=cell(1,size(SA,2));
komponensek(1,:)=SO(2,2:end)
save('komponensek.mat','komponensek')

%% 
% az idõpontokat (ill. numdate megfelelõiket) tartalmazó Full.T-ben az
% idõpontok nem egyenletes lépésközben követik egymást, a 'No Good Data...'
% sorok törlése miatt

% ez a feladat legvégén, a diagram rajzolásánál lehet gond,
% minden folyamtos szakaszt külön rajzoljunk ki, és az egymást követõ szakaszokat a matlab
% ne kösse össze!

% ehhez tudni kell, hogy melyik adat hányadik szakaszhoz tartozik,
% aztán majd a szakaszokat külön plot-ok rajzolják ki


        





















