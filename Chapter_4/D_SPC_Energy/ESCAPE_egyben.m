clear all
close all

load('ESCAPE.mat')
load('komponensek.mat')

addpath .\somtoolbox

M=4;

Y=Red.y(:,M);
X=Red.x;
data=[Y X];
comps=[komponensek(M) komponensek(5:end)]

%%
sD=som_data_struct(data,'comp_names', comps)
sM=som_make(sD,'msize',[4 4]) % 'lattice','rect',
figure(1)
som_show(sM)
%%
Index=cell(36,1);
for i=1:size(data,1)
    s=data(i,:);
    BMU = som_bmus(sM, s);
	Index{BMU} = [Index{BMU} i]; 	
end

theta=cell(36,1);
for i=1:numel(Index)
	if numel(Index{i})>=15
		theta{i}=data(Index{i},2:end)\data(Index{i},1);
	elseif numel(Index{i})==0
		theta{i}=NaN;
	elseif numel(Index{i})<15
		theta{i}=0;
	end		
end
%%
y_val_mert=Val.y(:,M);
data_val=[y_val_mert Val.x];
for i=1:size(data_val,1)
    s=data_val(i,:);
    BMU_val = som_bmus(sM, s);
    if isnan(theta{BMU_val})==0
		if theta{BMU_val}~=0
			y_val_becs(i,1)=theta{BMU_val}'*Val.x(i,:)';
		else
			yyy=data([Index{BMU_val}]);
			y_val_becs(i,1)=mean(yyy(:,1));
			mean(Index{BMU_val})
		end
    else
        y_val_becs(i,1)=NaN;
    end
end
%%
KM=corrcoef(y_val_becs(isnan(y_val_becs)==0),y_val_mert(isnan(y_val_becs)==0));
KORR.SOM=KM(1,2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if M==1
    ma=find(ismember(similarity_descent(:,1),'ALAPANYAG'))-1;
    mb=find(ismember(similarity_descent(:,1),'1.KAMRA HOFOKSZABALYZAS'))-1;
    mc=find(ismember(similarity_descent(:,1),'O401 Kemence Belépõ hõfok'))-1;
    md=find(ismember(similarity_descent(:,1),'2.KAMRA HOFOKSZABALYZAS'))-1;
    me=find(ismember(similarity_descent(:,1),'KÜLSÕ HÕMÉRSÉKLET'))-1;
    mf=find(ismember(similarity_descent(:,1),'FG4 ATLAG_SURUSEG_NM3'))-1;
    y_val_molbecs=0.000143*Valx_sor(:,ma).^1.5 +0.019763*((Valx_sor(:,mb)-Valx_sor(:,mc))+(Valx_sor(:,md)-Valx_sor(:,mc)))/2 -0.00146 * Valx_sor(:,me)+0.619604*Valx_sor(:,mf)-0.32028;
elseif M==2
    ma=find(ismember(similarity_descent(:,1),'ALAPANYAG'))-1;
    mb=find(ismember(similarity_descent(:,1),'W804/1-3 REG.MEA BELEPO'))-1;
    mc=find(ismember(similarity_descent(:,1),'W804/4-6 REG.MEA BELEPO'))-1;
    md=find(ismember(similarity_descent(:,1),'SAVANYUVIZ SZTRIPELESE'))-1;
    me=find(ismember(similarity_descent(:,1),'KÜLSÕ HÕMÉRSÉKLET'))-1; 
    y_val_molbecs=0.0323*Valx_sor(:,ma).^0.782   +0.316*(Valx_sor(:,mb)+Valx_sor(:,mc))+1.254*Valx_sor(:,md)- 0.3735 * Valx_sor(:,me) + 10.84;
elseif M==3
    ma=find(ismember(similarity_descent(:,1),'ALAPANYAG'))-1;
    mb=find(ismember(similarity_descent(:,1),'W804/1-3 REG.MEA BELEPO'))-1;
    mc=find(ismember(similarity_descent(:,1),'W804/4-6 REG.MEA BELEPO'))-1;
    md=find(ismember(similarity_descent(:,1),'SAVANYUVIZ SZTRIPELESE'))-1;
    me=find(ismember(similarity_descent(:,1),'KÜLSÕ HÕMÉRSÉKLET'))-1; 
    y_val_molbecs=0.07827 * Valx_sor(:,ma).^0.6984   +0.138*(Valx_sor(:,mb)+Valx_sor(:,mc))+0.276*Valx_sor(:,md)- 0.02 * Valx_sor(:,me) -0.79;    
elseif M==4
    ma=find(ismember(similarity_descent(:,1),'ALAPANYAG'))-1;
    mb=find(ismember(similarity_descent(:,1),'W804/1-3 REG.MEA BELEPO'))-1;
    mc=find(ismember(similarity_descent(:,1),'W804/4-6 REG.MEA BELEPO'))-1;
    md=find(ismember(similarity_descent(:,1),'SAVANYUVIZ SZTRIPELESE'))-1;
    me=find(ismember(similarity_descent(:,1),'KÜLSÕ HÕMÉRSÉKLET'))-1; 
    y_val_molbecs=0.12827 * Valx_sor(:,ma)-0.00233211*(Valx_sor(:,mb)+Valx_sor(:,mc))-0.5428579*Valx_sor(:,md)- 0.0110716 * Valx_sor(:,me) + 9.04967795-7; % biast átírtuk   
end


Mk=corrcoef(y_val_molbecs,Val.y(:,M));
KORR.MOL=Mk(1,2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if M==1
    y_full_molbecs=0.000143*Fullx_sor(:,ma).^1.5 +0.019763*((Fullx_sor(:,mb)-Fullx_sor(:,mc))+(Fullx_sor(:,md)-Fullx_sor(:,mc)))/2 -0.00146 * Fullx_sor(:,me)+0.619604*Fullx_sor(:,mf)-0.32028;
elseif M==2
    y_full_molbecs=0.0323*Fullx_sor(:,ma).^0.782   +0.316*(Fullx_sor(:,mb)+Fullx_sor(:,mc))+1.254*Fullx_sor(:,md)- 0.3735 * Fullx_sor(:,me) + 10.84;
elseif M==3
    y_full_molbecs=0.07827 * Fullx_sor(:,ma).^0.6984   +0.138*(Fullx_sor(:,mb)+Fullx_sor(:,mc))+0.276*Fullx_sor(:,md)- 0.02 * Fullx_sor(:,me) -0.79;    
elseif M==4
	% a biast átírtam
    y_full_molbecs=0.12827 * Fullx_sor(:,ma)-0.00233211*(Fullx_sor(:,mb)+Fullx_sor(:,mc))-0.5428579*Fullx_sor(:,md)- 0.0110716 * Fullx_sor(:,me) + 9.04967795-7;    
end

%%
y_full_plsbecs = [ones(size(Fullx_sor(:,1:nn),1),1) Fullx_sor(:,1:nn)]*BETA;

%%
y_full_mert=Full.y(:,M);
data_full=[y_full_mert Full.x];
for i=1:size(data_full,1)
    s=data_full(i,:);
    BMU_full = som_bmus(sM, s);
    if isnan(theta{BMU_val})==0
		if theta{BMU_val}~=0
			y_full_sombecs(i,1)=theta{BMU_val}'*Full.x(i,:)';
		else
			yyy=data([Index{BMU_val}]);
			y_full_sombecs(i,1)=mean(yyy(:,1));
			mean(Index{BMU_val})
		end
    else
        y_full_sombecs(i,1)=NaN;
    end
end



%%
figure(3)
whitebg('w')
hold on
plot(Full.T,Full.y(:,M),'g')
plot(Full.T,y_full_molbecs,'b') 
plot(Full.T,y_full_plsbecs,'m')
plot(Full.T,y_full_sombecs,'r')   %'Color',[190/255,190/255,190/255])
legend('a mért kimenet','a MOL-modell eredménye','a PLS-modell eredménye','a SOM-modell eredménye')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
figure('Color',[1 1 1])

subplot(1,3,1)
hold on
plot(Full.y(:,M),y_full_molbecs,'k+','MarkerSize',2)
% plot([0 sqrt(35^2*2)], [0 sqrt(35^2*2)],'r')
line([min(Full.y(:,M)) max(Full.y(:,M))], [min(Full.y(:,M)) max(Full.y(:,M))])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
xlabel('$y$','Interpreter','LaTeX','FontSize',18)
ylabel('$\hat{y}$','Interpreter','LaTeX','FontSize',18)
axis([min(Full.y(:,M)) max(Full.y(:,M)) min(Full.y(:,M)) max(Full.y(:,M))])
axis square
grid on
title('Heating~Steam $(MOL~model)$','Interpreter','LaTeX','FontSize',18)
box on

subplot(1,3,2)
hold on
plot(Full.y(:,M),y_full_plsbecs,'k+','MarkerSize',2)
% plot([0 sqrt(35^2*2)], [0 sqrt(35^2*2)],'r')
line([min(Full.y(:,M)) max(Full.y(:,M))], [min(Full.y(:,M)) max(Full.y(:,M))])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
xlabel('$y$','Interpreter','LaTeX','FontSize',18)
ylabel('$\hat{y}$','Interpreter','LaTeX','FontSize',18)
axis([min(Full.y(:,M)) max(Full.y(:,M)) min(Full.y(:,M)) max(Full.y(:,M))])
axis square
grid on
title('Heating~Steam $(PLS~model)$','Interpreter','LaTeX','FontSize',18)
box on

subplot(1,3,3)
hold on
plot(Full.y(:,M),y_full_sombecs,'k+','MarkerSize',2)
% plot([0 sqrt(35^2*2)], [0 sqrt(35^2*2)],'r')
line([min(Full.y(:,M)) max(Full.y(:,M))], [min(Full.y(:,M)) max(Full.y(:,M))])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
xlabel('$y$','Interpreter','LaTeX','FontSize',18)
ylabel('$\hat{y}$','Interpreter','LaTeX','FontSize',18)
axis([min(Full.y(:,M)) max(Full.y(:,M)) min(Full.y(:,M)) max(Full.y(:,M))])
axis square
grid on
title('Heating~Steam $(SOM~model)$','Interpreter','LaTeX','FontSize',18)
box on

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
felirat={'KEI','Process Variable 1','Process Variable 2','Process Variable 3','Process Variable 4','Process Variable 5','Process Variable 6','Process Variable 7','Process Variable 8','Process Variable 9'}
sD=som_data_struct(data,'comp_names', felirat )
sM=som_make(sD); % ,'msize',[10 10]) % 'lattice','rect',
figure('Color',[1 1 1])
% som_show(sM,'colormap',gray(200))
som_show(sM)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(987654)
whitebg('w')
hold on
for n=2:length(comps)-1
    for i=2:n
        plot(n,KORR.PLS_all(i-1,n-1),'b.','MarkerSize',24)
    end
end
xlabel('Number of process variables applied for PLS','Interpreter','LaTeX','FontSize',18)
ylabel('Correlation coeffitient','Interpreter','LaTeX','FontSize',18)
ylim([0.825 0.85])
grid on
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minT = min(Full.T);
maxT = max(Full.T);
xData = linspace(minT,maxT,6);

figure('Color',[1 1 1])
subplot(3,1,1)
hold on
plot(Full.T,Full.y(:,M)-y_full_molbecs,'k.','MarkerSize',4)
set(gca,'XTick',xData);
datetick('x','mm.dd. HH:MM','keepticks');
ylabel('Error $(MOL~model)$','Interpreter','LaTeX','FontSize',14)
ylim([-20 20])
hline(0,'k--')
hline(0+3*std(Full.y(:,M)-y_full_molbecs),'k-.')
hline(0-3*std(Full.y(:,M)-y_full_molbecs),'k-.')
box on

subplot(3,1,2)
hold on
plot(Full.T,Full.y(:,M)-y_full_plsbecs,'k.','MarkerSize',4)
set(gca,'XTick',xData);
datetick('x','mm.dd. HH:MM','keepticks');
ylabel('Error $(PLS~model)$','Interpreter','LaTeX','FontSize',14)
ylim([-20 20])
hline(0,'k--')
hline(0+3*std(Full.y(:,M)-y_full_plsbecs),'k-.')
hline(0-3*std(Full.y(:,M)-y_full_plsbecs),'k-.')
box on

subplot(3,1,3)
hold on
plot(Full.T,Full.y(:,M)-y_full_sombecs,'k.','MarkerSize',4)
set(gca,'XTick',xData);
datetick('x','mm.dd. HH:MM','keepticks');
ylabel('Error $(SOM~model)$','Interpreter','LaTeX','FontSize',14)
ylim([-20 20])
hline(0,'k--')
hline(0+3*std(Full.y(:,M)-y_full_sombecs),'k-.')
hline(0-3*std(Full.y(:,M)-y_full_sombecs),'k-.')
box on

xlabel('Time','Interpreter','LaTeX','FontSize',14)
%%
figure(0691888)
hold on
plot(cumsum(Full.y(:,M)-y_full_plsbecs))
plot(cumsum(Full.y(:,M)-y_full_sombecs),'r')












