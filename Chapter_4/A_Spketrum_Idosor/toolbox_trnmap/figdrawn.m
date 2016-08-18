function figdrawn(X,w,C,title)

[r,c]=size(w);

figure('Name', title);

if r==2 % 2 dim
    for i=1:c
        for j=i+1:c
            if C(i,j)==1
                plot ([w(1,i) w(1,j)], [w(2,i) w(2,j)],'MarkerSize', 20, 'Color', 'k');
                hold on;
            end    
        end
    end
    plot(w(1,:),w(2,:),'.');
    plot(X(1,:),X(2,:),'.');
    
elseif r==3 % 3 dim
    for i=1:c
        for j=i+1:c
            if C(i,j)==1
                plot3 ([w(1,i) w(1,j)], [w(2,i) w(2,j)], [w(3,i) w(3,j)],'MarkerSize', 20, 'Color', 'k');
                hold on;
            end    
        end
    end
    plot3(w(1,:),w(2,:),w(3,:),'.');
    %plot3(X(1,:),X(2,:),X(3,:),'.');
    view([5 10]);
end

  
