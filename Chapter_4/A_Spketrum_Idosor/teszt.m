%%

c = -pi:.04:pi;
cx = cos(c);
cy = -sin(c);
figure('color','white');
axis off, axis equal
line(cx, cy, 'color', [.4 .4 .8],'LineWidth',3);
title('See Pythagoras run!','Color',[.6 0 0])
hold on
x = [-1 0 1 -1];
y =   [0 0 0 0];
ht = area(x,y,'facecolor',[.6 0 0]);
for j = 1:length(c)
    x(2) = cx(j);
    y(2) = cy(j);
    set(ht,'XData',x)
    set(ht,'YData',y)
    drawnow
end

%%
writerObj = VideoWriter('peaks.avi');
open(writerObj);
% Generate initial data and set axes and figure properties.

Z = peaks; surf(Z); 
axis tight
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');
% Setting the Renderer property to zbuffer or Painters works around limitations of getframe with the OpenGL renderer on some Windows systems.

% Create a set of frames and write each frame to the file.

for k = 1:20 
   surf(sin(2*pi*k/20)*Z,Z)
   frame = getframe;
   writeVideo(writerObj,frame);
end

close(writerObj);