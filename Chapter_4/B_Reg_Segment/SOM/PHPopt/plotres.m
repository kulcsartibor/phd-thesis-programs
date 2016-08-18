figure(5)
%load simout
subplot(211);
hold on
stairs(0:0.2:250,simout(:,1),'k-.')
stairs(0:0.2:250,simout(:,2),'k-')
hold off
grid on
axis([0 250 6 11])
xlabel('Time [min]')
ylabel('pH')


subplot(212);
stairs(0:0.2:250,simout(:,3),'k')
axis([0 250 512 522])
grid on
xlabel('Time [min]')
ylabel('F_{NaOH} [l/min]')
Errc=sum((simout(:,1)-simout(:,2)).^2)*0.2