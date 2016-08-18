function [ varargout ] = plotT(mark, format, varargin)

[varargout{1:nargout}] = plot( varargin{:} );

% xData = linspace(min(varargin{1}),max(varargin{1}),12);
% 
set(gca,'XTick',linspace(min(varargin{1}),max(varargin{1}),mark));
datetick('x',format,'keepticks');
% 'yyyy.mm.dd. HH:MM'
hhAxes = handle(gca);  % hAxes is the Matlab handle of our axes
hProp = findprop(hhAxes,'XLim');  % a schema.prop object
hListener = handle.listener(hhAxes, hProp, 'PropertyPostSet', @zoomCallbackFunction);
setappdata(hhAxes, 'XLimListener', hListener);

end

