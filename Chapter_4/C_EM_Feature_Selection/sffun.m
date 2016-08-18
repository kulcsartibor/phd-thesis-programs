function criterion = sffun(XT,YT,Xt,Yt)

theta = XT\YT;

Yhat = Xt*theta;

criterion = sum((Yhat - Yt).^2); 






