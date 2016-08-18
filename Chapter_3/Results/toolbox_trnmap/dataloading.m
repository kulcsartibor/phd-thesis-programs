function [X,C] = dataloading(dsource)

%rand('seed',1);
C=[];
% if drand == 1,      dname = 'rand';      end
% if dmoto == 1,      dname = 'moto';      end
% if dscurve == 1,    dname = 'scurve';    end
% if dswissroll == 1, dname = 'swissroll'; end
% if dsin == 1,       dname = 'sin';       end
% if dspiral == 1,    dname = 'spiral';    end
% if doil == 1,       dname = 'oil';       end

%1:rand
%2:moto
%3:scurve
%4:swissroll
%5:dsin
%6:spiral
%7:oil
%8:iris
%9:wine
%10:wisconsin
%11:trefoil knot
%12:noisy swiss 


if dsource == 1
  X = nDexample(3, round(N/3), 2, 16);
end

if dsource == 2
  load motorcycle.txt
  X = motorcycle(:,[1 2]);
  X=X';
end

if dsource == 3
  N=2000; %number of the input data
  angle = pi*(1.5*rand(1,N/2)-1); height = 5*rand(1,N);
  X = [[cos(angle), -cos(angle)]; height;[ sin(angle), 2-sin(angle)]];
end

if dsource == 4
  N=2000; %number of the input data
  tt = (3*pi/2)*(1+2*rand(1,N));  height = 21*rand(1,N);
  X = [tt.*cos(tt)+10; height; tt.*sin(tt)+15];
  C=repmat(1,1,N);
end

if dsource == 5
    tmp = [0:.05:4*pi]';
    X = sin(tmp) + rand(length(tmp),1)*0.6;
    X = [tmp X];
    X=X';
end
    
if dsource == 6
    theta = [[0.5*pi : 0.03 : 6.5*pi]' [-0.5*pi : 0.03 : 5.5*pi]'];

    rinit = repmat([0 0.3], size(theta,1), 1);
    n = repmat([0.1 0.2], size(theta,1), 1);
    ro = repmat([0.13 0.13], size(theta,1), 1);
    
    r = ro .* (theta + 2*pi*n) + rinit;
    
    x = r .* sin(theta);
    y = r .* cos(theta);
    
    X = [x(:) y(:)];
    X = X';
    
    %plot(x(:,1), y(:,1), 'b.', x(:,2), y(:,2), 'r.')
end
    
if dsource == 7
    [x, t, nin, nout, ndata] = datread('oilTrn.dat');
    X = x';    
end

if dsource == 8
  load iris.txt
  X = iris(:,1:4);
  C=iris(:,5)';
  X=X';
end
   
if dsource == 9
  load wine.txt
  X=wine;
  C=X(:,end)';
  X=X(:,1:end-1)';
end

if dsource == 10
  load wisconsin.txt
  X=wisconsin(:,2:10);
  C=(wisconsin(:,11)/2)';
  X=X';
end

if dsource == 11
    t = 2*pi*rand(1000,1);
    x = 41*cos(t) - 18*sin(t) - 83*cos(2*t) - 83*sin(2*t) - 11*cos(3*t) + 27*sin(3*t);
    y = 36*cos(t) + 27*sin(t) - 113*cos(2*t) + 30*sin(2*t) + 11*cos(3*t) - 27*sin(3*t);
    z = 45*sin(t) - 30*cos(2*t) + 113*sin(2*t) - 11*cos(3*t) + 27*sin(3*t);
    X=[x y z]';
    C=ones(1,1000);
end

if dsource == 12
  N=2000; %number of the input data
  tt = (3*pi/2)*(1+2*rand(1,N));  height = 21*rand(1,N);
  X = [tt.*cos(tt)+10; height; tt.*sin(tt)+15];
  for i= 1:N*0.01
      X=[X [rand*25;rand*30;rand*30]];
  end
  C=repmat(1,1,size(X,2));

end
