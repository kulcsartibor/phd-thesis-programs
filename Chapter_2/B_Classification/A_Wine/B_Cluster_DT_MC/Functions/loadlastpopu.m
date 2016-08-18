function popuret = loadlastpopu(folder)

content = dir(['.\' folder]);
lastfile = [0 0];

if numel(content) < 3
    error('No file in directory')
end

for i = 1:numel(content)
   if((content(i).isdir == 0) && content(i).datenum > lastfile(2))
       lastfile(1) = i;
       lastfile(2) = content(i).datenum;
   end
end

if(lastfile(1) ~= 0)
   load(['.\' folder '\' content(lastfile(1)).name]) 
end

popuret = popu;
