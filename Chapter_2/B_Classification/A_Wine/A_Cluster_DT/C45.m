function tree=C45(input,output)
%
%
%tree=C45(input,output)
%All the input variables are considered continuous.
%The output is one column with integer values (the classes).
%
%This functions creates some temp. files


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%go the c4.5 directory
% disp(cd)
orgdir=cd;
c45dir=which('c45');

try
   
   cd(c45dir(1:end-6));

   output=output-min(output)+1;
   data=[input,output ];
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %data file
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   rowstring='%d';
   for i=2:size(data,2)
      rowstring=[rowstring ', %d'];
   end
   rowstring=[rowstring ' .\n'];
   
   fid = fopen('tempc45.data','w');
   for j=1:size(data,1)
      row=sprintf(rowstring,data(j,:));
      temp=findstr(row,'NaN');
      row(temp)='?';
      row(temp+1)=' ';
      row(temp+2)=' ';
      fprintf(fid,row);
   end
   fclose(fid);
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %names file
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   fid = fopen('tempc45.names','w');
   
   %classes
   temp=[];
   temp(output)=1;
   temp=find(temp);
   
   row=[num2str(temp(1))];
   for j=2:length(temp)
      row=[row ', '  num2str(temp(j))];
   end
   row=[row '    | classes\n\n'];
   fprintf(fid,row);
   
   for j=1:size(input,2)
      row=['feature_' num2str(j) ': continuous. \n' ];
      fprintf(fid,row);
   end
   fclose(fid);
   
   
%  !c4.5 -f tempc45 -c 100
    !c4.5 -f tempc45 

   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Load the tree
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   id=fopen('tempc45.tr2');
   dataIn=fscanf(id,'%c');
   fclose(id);
   
   enterpos=findstr(dataIn,char(13));
   vertline=findstr(dataIn,'|');
   featurepos=findstr(dataIn,'feature_')+8;
   spacepos=findstr(dataIn,' ');
   
   tree=[];
   for i=3:length(enterpos)-1
      tree.depth(i-2)=sum((vertline>enterpos(i-1) ).*(vertline<enterpos(i))); %the depth of the tree
      temp=spacepos(min(find(spacepos>featurepos(i-2))));
      tree.feature(i-2)=str2num(dataIn(featurepos(i-2):temp)); %test on which feature
      if strcmp(dataIn(temp+1),'>')
         temp=temp+2;
         tree.larger(i-2)=1;
      else
         temp=temp+3;
         tree.larger(i-2)=0; %the test direction
      end
      temp2=spacepos(min(find(spacepos>temp+1)));
      tree.cut(i-2)=str2num(dataIn(temp:temp2)); %the position of the cut
      if length(findstr(dataIn(temp2+1:enterpos(i)),'('))
         tree.isleaf(i-2)=1; %this is an leaf 1, not a leaf 0
         temp=spacepos(min(find(spacepos>temp2+2)));
         tree.leafchoice(i-2)=str2num(dataIn(temp2+2:temp)); %the chosen class
      else
         tree.isleaf(i-2)=0;
         tree.leafchoice(i-2)=0;
      end
   end
   
   %No tree available, this is a tree with a constant output!!!
   if isempty(tree)
      tree.isleaf(1:2)=1;    tree.cut(1:2)=inf;
      tree.larger(1:2)=0;    tree.feature(1:2)=1;
      tree.depth(1:2)=0;
      temp=spacepos(min(find(spacepos>enterpos(1)+2)));
      tree.leafchoice(1:2)=str2num(dataIn(enterpos(1)+2:temp));
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
catch
	
   cd(orgdir);
end


cd(orgdir);











