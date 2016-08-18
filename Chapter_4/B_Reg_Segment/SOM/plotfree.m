figure(3)
subplot(211);
hold on
stairs(0:0.2:250,simout(:,1),'k-')
stairs(0:0.2:250,simout(:,3),'k-.')
hold off
grid on
axis([0 250 6 11])
xlabel('Time [min]')
ylabel('pH')


subplot(212);
stairs(0:0.2:250,simout(:,2),'k')
axis([0 250 512 522])
grid on
xlabel('Time [min]')
ylabel('F_{NaOH} [l/min]')

Err=mean((simout(:,1)-simout(:,3)).^2)