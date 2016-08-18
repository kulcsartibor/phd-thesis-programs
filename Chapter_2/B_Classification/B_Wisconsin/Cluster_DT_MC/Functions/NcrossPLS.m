function PLSmod = NcrossPLS(X,Y,lv,Fakt)

N = size(X,1);
EstY = zeros(N,1);
Ln = ceil(N/Fakt);

if Fakt==1
    Pm = pls(X, Y,lv);
    pls_predi = plspred(X,Pm,Y);
    EstY = pls_predi.Yp;
else
    for i=0:Fakt-1
        OutI = intersect(1:N, (i*Ln+1):(i+1)*Ln);
        ModI = setdiff(1:N, OutI)	;
        Pm = pls(X(ModI,:), Y(ModI, :),lv);
        pls_predi = plspred(X(OutI,:),Pm,Y(OutI, :));
        EstY(OutI) = pls_predi.Yp;
    end
end

% 
% Pm = pls(X, Y,lv);	
%  pls_pred = plspred(X,Pm,Y);
%  	EstY = pls_pred.Yp;
	
PLSmod.X = X;
PLSmod.EstY = EstY;

end