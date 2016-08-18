

close all
%a=rand(4,2)
a=[];
a=[a; 
   0 0;
   0 1;
   1 0;
   1 1;
   0.5 0.5];
tri=delaunay(a(:,1),a(:,2))
ntri=size(tri,1);

par=[0 0 0 0 1];

figure(1)
hold on
tRIsurf(tri,a(:,1),a(:,2),par',par');

colormap([1 1 1])
xlabel('z_2')
ylabel('z_1')
zlabel('A_i(z)')
hold off

grid on

figure(2) %plot the triangules
hold on
node=a;
for i=1:ntri
   plot([node(tri(i,1),1) node(tri(i,2),1)], [node(tri(i,1),2) node(tri(i,2),2)])
   plot([node(tri(i,1),1) node(tri(i,3),1)], [node(tri(i,1),2) node(tri(i,3),2)])
   plot([node(tri(i,2),1) node(tri(i,3),1)], [node(tri(i,2),2) node(tri(i,3),2)])
end
xlabel('z_1')
ylabel('z_2')

a1=[0 0;
   0.5 0.5
   0 1];
inv([a1 ones(3,1)])

