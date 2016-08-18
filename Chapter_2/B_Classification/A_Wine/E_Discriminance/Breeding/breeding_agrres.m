function [correct] = breeding_agrres(fss1,fss2,X,DistM)
%Calculates linear parameters and error values

% disp(['Agr1: ' fss1])
% disp(['Agr2: ' fss2])

global Type cv %TypeI TypeN

Y = [eval(fss1) eval(fss2)];
% temp = agrpoints;
% pause
tree=C45(Y,Type);

[Mt,Mc] = trustcont(10, X, Y, DistM, L2_distance(Y',Y'));

lambda = [1 0];

pred_c45 = zeros(size(Type));
for i = 1:cv.NumTestSets
	c45_Mod = C45(Y(cv.training(i),:),Type(cv.training(i)));
	pred_c45(cv.test(i)) = c45test(Y(cv.test(i),:),c45_Mod);
end

correct = (lambda(1)*(sum((pred_c45-Type==0))/size(Y,1)) + lambda(2)*Mt*Mc)*100;


% 
% 
% 
% 
% 
% px = eval(fss1);
% py = eval(fss2);
% 
% px(abs(px) == Inf) = 1;
% px(isnan(px)) = 0;
% py(abs(py) == Inf) = 1;
% py(isnan(py)) = 0;
% 
% 
% px = px + (rand(numel(px),1)-0.5)*eps;
% py = py + (rand(numel(py),1)-0.5)*eps;
% % plot(px,py,'.')
% % pause
% 
% % Y(:,1) = (Y(:,1)-min(Y(:,1)))/(max(Y(:,1))-min(Y(:,1)));
% 
% % S(TypeN).P(1).x = 0;
% % S(TypeN).P(1).y = 0;
% % S(TypeN).P(1).hole = 0;
% 
% for i = 1:TypeN
% 	ti = TypeI{i};
% 	convi = convhull(px(ti), py(ti));
% 	
% 	S(i).P(1).x = px(ti(convi));
% 	S(i).P(1).y = py(ti(convi));
% 	S(i).P(1).hole = 0;
% end
% 
% 
% [separation, dr] = PolyInterSect(px,py,TypeI,0);
% if isnan(separation)
% 	separation = 0;
% end
% 
% % disp(fitness)
% 
% % fitness = 1 - (carea/polyarea(px(convi), py(convi)));
% 
% lambda = [0.45 0.1 0.45];
% 
% Y = [px py];
% [Mt,Mc] = trustcont(10, X, Y, DistM, L2_distance(Y',Y'));
% separation = lambda(1)*separation + lambda(2)*Mt*Mc + lambda(3)*dr;

