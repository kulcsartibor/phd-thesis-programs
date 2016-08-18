%% Poly Eredmények

PolyInterSect(SmMap(:,1),SmMap(:,2),TypeI,1)
PolyInterSect(PCAPoints(:,1),PCAPoints(:,2),TypeI,1)

%%
% lx = 0.5*(((1.5*((X(:,10)).*(X(:,12))))+((1*(X(:,7)))-(1.5*(X(:,10)))))+(2.5*(((X(:,13)).*(X(:,7))).*((X(:,3))+(X(:,1)))))); 
% ly = 0.5*(((1*(X(:,8)))-(1*((X(:,9)).*(X(:,9)))))-(1.5*(((X(:,1))-(X(:,4))).*(X(:,9)))));

lx = 0.5*((((1*(X(:,9)))+(1*(X(:,5))))+(1*(X(:,4))))-((2*(X(:,4)))-((7*(X(:,7)))+(1*(X(:,9))))));
ly = 0.5*(1*((X(:,13)).*(X(:,10))));


PolyInterSect2(lx,ly,TypeI,1)
PolyInterSect(lx,ly,TypeI,1)

%%
figure
hToolbar = findall(gcf,'tag','FigureToolBar');
hUndo=uisplittool('parent',hToolbar);       % uisplittool
hRedo=uitogglesplittool('parent',hToolbar); % uitogglesplittool

% Load the Redo icon
icon = fullfile(matlabroot,'/toolbox/matlab/icons/greenarrowicon.gif');
[cdata,map] = imread(icon);
 
% Convert white pixels into a transparent background
map(find(map(:,1)+map(:,2)+map(:,3)==3)) = NaN;
 
% Convert into 3D RGB-space
cdataRedo = ind2rgb(cdata,map);
cdataUndo = cdataRedo(:,[16:-1:1],:);
 
% Add the icon (and its mirror image = undo) to latest toolbar
set(hUndo, 'cdata',cdataUndo, 'tooltip','undo','Separator','on', ...
           'ClickedCallback','uiundo(gcbf,''execUndo'')');
set(hRedo, 'cdata',cdataRedo, 'tooltip','redo', ...
           'ClickedCallback','uiundo(gcbf,''execRedo'')');
	   
jToolbar = get(get(hToolbar,'JavaContainer'),'ComponentPeer');
jButtons = jToolbar.getComponents;
for buttonId = length(jButtons)-3 : -1 : 7  % end-to-front
   jToolbar.setComponentZOrder(jButtons(buttonId), buttonId+1);
end
jToolbar.setComponentZOrder(jButtons(end-2), 5);   % Separator
jToolbar.setComponentZOrder(jButtons(end-1), 6);   % Undo
jToolbar.setComponentZOrder(jButtons(end), 7);     % Redo
jToolbar.revalidate;

%%
sysTray = java.awt.SystemTray.getSystemTray;
if (sysTray.isSupported)
   myIcon = fullfile(matlabroot,'/toolbox/matlab/icons/matlabicon.gif');
   iconImage = java.awt.Toolkit.getDefaultToolkit.createImage(myIcon);
   trayIcon = java.awt.TrayIcon(iconImage, 'initial tooltip');
   trayIcon.setToolTip('click this icon for applicative context menu');
end

% Prepare the context menu
menuItem1 = java.awt.MenuItem('action #1');
menuItem2 = java.awt.MenuItem('action #2');
menuItem3 = java.awt.MenuItem('action #3');

% Set the menu items' callbacks
set(menuItem1,'ActionPerformedCallback',@myFunc1);
set(menuItem2,'ActionPerformedCallback',{@myfunc2,data1,data2});
set(menuItem3,'ActionPerformedCallback','disp(''action #3...'')');

% Disable one of the menu items
menuItem2.setEnabled(0);        % or: set(menuItem2,'Enabled','off');

% Add all menu items to the context menu (with internal separator)
jmenu = java.awt.PopupMenu;
jmenu.add(menuItem1);
jmenu.add(menuItem2);
jmenu.addSeparator;
jmenu.add(menuItem3);

% Finally, attach the context menu to the icon
trayIcon.setPopupMenu(jmenu);    % or: set(trayIcon,'PopupMenu',jmenu);