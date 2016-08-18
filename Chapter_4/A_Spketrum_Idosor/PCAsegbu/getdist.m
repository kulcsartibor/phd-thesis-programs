% GETDIST Get squared distance matrix
%         GETDIST obtains the matrix of squared distances given the 
%         coordinates of a set of points in a matrix M. The output is
%         matrix D.
%
%         Re-written from a minitab macro by Eryl Bassett. 

disp('******************************************************')
disp('******************************************************')
disp('****                                              ****')
disp('****                GETDIST.M                     ****')
disp('****                                              ****')
disp('****        By Paul Terrill, July 1996            ****')
disp('****                                              ****')
disp('******************************************************')

k1=size(M,1);
M1=M*M';
c1=diag(M1); c1=c1';
M3=c1(ones(1,k1),:);
M3=M3+M3';
M2=2*M1;
D=M3-M2;

disp(' ')
disp('Matrix of squared distance (D)')
disp(' ')
%disp(D)
clear M1 M2 M3 c1 k1
