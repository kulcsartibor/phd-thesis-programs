% ESCAPE_02.m után futtatható

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