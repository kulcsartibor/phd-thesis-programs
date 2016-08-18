%%
% clear all; close all; clc;
% addpath('SOM')
% [numeric, text]=xlsread('BEK4_model.xlsx','Model2');

%%
% Y = numeric(:,1);
% X = numeric(:,2:end);
ment = [Y X];
save('mentdata.txt', 'ment' ,'-ascii', '-tabs')

sD = som_read_data('mentdata.txt');
sD.comp_names{1}='fuel gas consumption'
sD.comp_names{2}='total feed'
sD.comp_names{3}='inlet temperature'
sD.comp_names{4}='ambient temperature'
sD.comp_names{5}='density of fuel gas'


sMap = som_make(sD);
%sMap = som_lininit(sD,'msize',[10 10],'rec');
%sMap = som_autolabel(sMap,sD,'vote');
%colormap(1-gray)
figure(80)
som_show(sMap)
print  -djpeg90 -f80



%% SOM prediction
figure(90)
[V,I]=som_divide(sMap, sD.data);
for i=1:length(V)
   ybmu{i}=mean(V{i}(:,1)); 
   if size(V{i},1)>size(V{i},2)*2
    ybmu{i}= [V{i}(:,2:end) ones(size(V{i},1),1)]\V{i}(:,1)  
   end    
end    

for i=1:length(sD.data);
  dum1=ybmu{som_bmus(sMap, [NaN sD.data(i,2:end) ])};
  if size(dum1,1)==1;
   ymSOM(i)=dum1;
  else 
   ymSOM(i)= [ sD.data(i,2:end) 1]* dum1;
  end 
end
Ym=ymSOM';
Ym(find(isnan(Ym)))=0;


plot(Y,Ym,'+','MarkerSize',1)
hold on
axis([min(Y) max(Y) min(Y) max(Y)])
line([min(Y) max(Y)],[min(Y) max(Y)] ,'Color',[0 0 0],'LineWidth',2)
xlabel('$y$','Interpreter','latex','FontSize',12)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',12)
Residual = Y-Ym;
sigmaR = std(Residual);
muR = mean(Residual);
h = [];
for i = 1:3
	h(i) = line([min(Y) max(Y)],[min(Y)+i*sigmaR max(Y)+i*sigmaR],'LineStyle','--','Color',color(i,:),'LineWidth',2);
 	line([min(Y) max(Y)],[min(Y)-i*sigmaR max(Y)-i*sigmaR],'LineStyle','--','Color',color(i,:),'LineWidth',2)
end
hl = legend(h,'\sigma','2\sigma','3\sigma');
set(hl,'Location','SouthEast')
sigmaR