function setFigSize(mode)

jFrame = get(handle(gcf),'JavaFrame');

switch mode
	case 'maximized'
		jFrame.setMaximized(true);
	case 'minimized'
		jFrame.setMaximized(false);
end
