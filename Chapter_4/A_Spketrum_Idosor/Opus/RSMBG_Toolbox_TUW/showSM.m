Wavenumber=evalin('base','BCP.Wavenumber');
LCIR=evalin('base','BCP.LCIR');
figure (6)
plot (Wavenumber,LCIR);
grid on;
title (['Sample LC-IR Matrix']);
set(gca,'XDir','reverse');
xlabel('Wavenumber (cm-1)');
ylabel('Absorbance');
box('on');
grid('on');
