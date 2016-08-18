function CallbackFunction(hProp,eventData)    %#ok - hProp is unused
   hAxes = eventData.AffectedObject;
   tickValues = get(hAxes,'XLim');
   
   xData = linspace(tickValues(1),tickValues(end),12);
% 
set(gca,'XTick',xData);
datetick('x','yyyy.mm.dd. HH:MM','keepticks');
   
%    newLabels = arrayfun(@(value)(sprintf('%.1fV',value)), tickValues, 'UniformOutput',false);
%    set(hAxes, 'YTickLabel', newLabels);
end




% hhAxes = handle(gca);  % hAxes is the Matlab handle of our axes
% hProp = findprop(hhAxes,'XLim');  % a schema.prop object
% hListener = handle.listener(hhAxes, hProp, 'PropertyPostSet', @myCallbackFunction);
% setappdata(hAxes, 'XLimListener', hListener);