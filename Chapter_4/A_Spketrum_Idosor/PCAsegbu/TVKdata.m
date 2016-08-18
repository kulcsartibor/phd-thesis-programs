clear all
close all
%load dataFS340FA381 %5
%load dataFB472FS471 nem megy
%load dataPS380FS340 %3
load dataFA381

sprintf('%s\t %d','gyartasok szama:',size(APC,2))
for i=1:size(APC,2);
gyart=i

%KAT fogyasztas normalasa
katossz=([betap{gyart}{:,end}])';
%katossz min    max
%       0       322.333
katmin=0;
katminv=zeros(length(katossz),1);
katmax=322+1/3;
katmaxv=[ones(length(katossz),1)*katmax];
katosszj=min(katossz,katmaxv);
katosszj=max(katosszj,katminv); %itt volt hiba a Csabi programjaban
katosszn=(katosszj-katminv)./(katmaxv-katminv);

%APC normalasa

minimumok=[0         0         0    0.4284   86.2998         0         0    0    0.2488    3.3489];
maximumok=[14.2006    4.5    0.4838    0.5540  107.5   19.3304  887.8925   14.8036    7.1334   13.8451];
%2  13AI01AX szamitott etilen konc suly%    2.1 5.5  
%3  13AI01CX szamitott C6 konc s%           0.075 4.5
%4  13AI02F H2 a flashgazban mol%           0   0.3
%5  apc.DI1301_PV  zagysuruseg (g/cm3)      
%6  apc.TC1305_PV  reaktor homerseklet      88.3    107.5
%7  apc.13FY04     PE elvetel(t/h)
%8  FC1319_PV	Hexén betáp kg/h
%9  FC1320_PV	C2 betáp t/h
%10 FC1321_PV	H2 betáp kg/h
%11 13FC17TL   osszes Ib betap

    X=[];
    for j=2:size(APC{gyart},2) %ITT TUL SZAMITAS IGENYES VOLT
        X=[X [APC{gyart}{:,j}]'];
    end
    maxft=repmat(maximumok,length(X),1);
    minft=repmat(minimumok,length(X),1);
    Xj=min(X,maxft);
    Xj=max(Xj,minft); %ITT HIBAS VOLT
    Xn=(Xj-minft)./(maxft-minft);


datax=[Xn katosszn];


%idok
APCkezd=[datenum(str2num(char(APC{gyart}{1,1}(1:4))),str2num(char(APC{gyart}{1,1}(6:7))),str2num(char(APC{gyart}{1,1}(9:10))),str2num(char(APC{gyart}{1,1}(12:13))),str2num(char(APC{gyart}{1,1}(15:16))),str2num(char(APC{gyart}{1,1}(18:19))))];
APCveg=[datenum(str2num(char(APC{gyart}{end,1}(1:4))),str2num(char(APC{gyart}{end,1}(6:7))),str2num(char(APC{gyart}{end,1}(9:10))),str2num(char(APC{gyart}{end,1}(12:13))),str2num(char(APC{gyart}{end,1}(15:16))),str2num(char(APC{gyart}{end,1}(18:19))))];
interval=(APCveg-APCkezd)*24;


%ABRAZOLAS, AZ IDO NE CSAK 0-BA KEZDODJON

t=[0:1/240:round(interval)];
t=t';

data=[t datax];
%data(1:10*240,:)=[];

%save data data
nev=['data' num2str(i)];
save(nev,'data')
Tvkdataplot
pause
end