clear all
close all
% szegmentalasi mesterseges pelda generalasa
rand('seed',10) %mindig ugyanazt a (veletlen) adathalmazt fogja generalni

inter=[1000 500 2000 3000 1000] %szegmensek hossza
segborder=[0 cumsum(inter)]; %szegmens hatarok
N=segborder(end); %adatpontok szama
c=length(inter) %a csoportok/szegmensek szama
n=5 %a fuggetlen valtozok szama



%veletlenszeruen generaljuk a modelleket 
P=[];
for i=1:c
   P{i}=rand(n+1,1); %(parameter vektorok oszlopvektok)
   P{i}=P{i}./sum(P{i}); %Trukk, hogy a kimeneten ne terjenek el annyira a modellek, ne latszodajank tulzottan a szegmensek
end    

sigma=1e-5; %"meresi" hiba szorasa, kimenethez adott normal eloszlasu 

X=rand(N,n); %fuggetlen valtozok, most csak veletlenszeruek
X=[X ones(N,1)]; %egyszeruseg miatt a bias tagnak megfelelo 1-eket az utoso oszlopba tesszuk
e=randn(N,1)*sigma;

Y=[];

for i=1:c
   Y=[Y; [X([segborder(i)+1:segborder(i+1)],:)*P{i}+e([segborder(i)+1:segborder(i+1)]) ]];
end    
    
plot(Y)

%Kesz a pelda, 
%X, Y amit atadunk (X-bol tudjuk n-t)
%segborder, c ezt csak ellenorzesre

num_segments=c;
forceplot=1;
segment =regseg(Y,X,num_segments,forceplot)
