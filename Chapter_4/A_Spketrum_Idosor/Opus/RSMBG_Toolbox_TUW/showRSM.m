Wavenumber=evalin('base','BCP.Wavenumber');
Reference=evalin('base','BCP.RSM_Matrix');
figure (5)
plot (Wavenumber,Reference);
grid on;
title (['Reference Spectral Matrix:']);
set(gca,'XDir','reverse');
xlabel('Wavenumber (cm-1)');
ylabel('Absorbance');
box('on');
grid('on');