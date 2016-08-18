function class=c45test(orginput,tree)   
%class=c45test(orginput,tree)

%Classify the data
for i=1:size(orginput,1)
  input=orginput(i,:);
  counter=1;
  test=(input(tree.feature(counter))>tree.cut(counter))==tree.larger(counter);
  while ~tree.isleaf(counter) | ~test 
    if test==0
      counter=counter+min(find(tree.depth(counter+1:end)==tree.depth(counter)));
    elseif ~tree.isleaf(counter)
      counter=counter+1;
    end
    test=(input(tree.feature(counter))>tree.cut(counter))== ...
	 tree.larger(counter);
  end
  class(i)=tree.leafchoice(counter);
end
class=class';
