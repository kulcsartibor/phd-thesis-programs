function cmprsm = pls2DComp(pls_mod)

	X = pls_mod.Data.X;
	y = pls_mod.Data.Y;
	W = pls_mod.W;

	a = inv(W'*X'*X*W)*W'*X'*y;
	w1 = W(:,1);
	w2tilde = W(:,2:end)*a(2:end)/norm(W(:,2:end)*a(2:end));
	t1 = X*w1;
	tm2tilde = X*w2tilde;

	%%Ortogonális Transformáció
	d=-t1'*tm2tilde/(tm2tilde'*tm2tilde);
	f=sqrt(1+d^2);
	cmprsm.p2=(-d*w1+w2tilde)/f;
	cmprsm.tw1=t1+d*tm2tilde;
	cmprsm.tw2=f*tm2tilde;

end