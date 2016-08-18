global kr ti error w;
x0=[2.53 0.3407];
options(14)=1000;
x=constr('apid_hf1',x0, options)
[f,g]=apid_hf1(x);
	
