function [top_int, bot_int,X] = regression_line_ci2(alpha,y,yhat,varargin)

n = length(y);

ym = mean(y);



s = sqrt(sum((y-yhat).^2)/(n-2));


y_min = min(y);
y_max = max(y);
n_pts = 100;



yl = y_min:(y_max-y_min)/n_pts:y_max;



syh = s*sqrt(1/n + (yl-ym).^2/sum((y-ym).^2));


top_int = yl + 10*syh;
bot_int = yl - 10*syh;

scatter(y,yhat,'.');
hold on

% plot(Yl,Yh,'red','LineWidth',2);
plot(yl,top_int,'green--','LineWidth',2);
plot(yl,bot_int,'green--','LineWidth',2);
hold





