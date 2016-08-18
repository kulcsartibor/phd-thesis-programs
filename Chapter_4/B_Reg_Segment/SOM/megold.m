function ki=megold(u);
e=roots(u);
ki=0;
for i=1:3
   if e(i)>0 & imag(e(1))==0
      ki=e(i);
   end
end
