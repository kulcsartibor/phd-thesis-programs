cd(matlabroot);
cd('\help\toolbox\econ\examples');
load Data_PowerConsumption;

figure
plot(rGDP,consumpDiff,'.')
title('Annual Difference in Energy Consumption vs real GDP - Canada')
xlabel('real GDP (year 2000 USD)')
ylabel('Annual Difference in Energy Consumption (kWh)')