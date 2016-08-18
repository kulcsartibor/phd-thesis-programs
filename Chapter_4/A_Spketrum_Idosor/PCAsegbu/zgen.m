clear all
close all
global inter

inter=[10000 5000 20000 3000]

sim('z_gen')

size(simout)
for i=1:3
   subplot(3,1,i)
   plot(simout(:,i))
end

