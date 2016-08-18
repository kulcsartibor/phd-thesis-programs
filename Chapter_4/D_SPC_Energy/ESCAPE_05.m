% CSAK az ESCAPE_01.m, _02.m és _03.m futtatása UTÁN lehet használni

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
%%
figure(4)
whitebg([190/255,190/255,190/255])
hold on
plot(Full.T,Full.y(:,M),'black')
plot(Full.T,y_full_molbecs,'Color',[105/255,105/255,105/255]) 
plot(Full.T,y_full_plsbecs,'Color',[211/255,211/255,211/255])
% plot(T_full_sombecs,y_full_sombecs,'w')
legend('a mért kimenet','a MOL-modell eredménye','a PLS-modell eredménye')   % ,'a SOM-modell eredménye')

