clear;
A=[ 3  0 -2;
    1  4  5;
   -1  1  2];
B=[ 1 -1  1; 
    0  6  1;  
    3 -2 -5];
C=[-1 -1  2; 
    5  1  1; 
   -3 -2  3];
parte1_i=A+B-C;
parte1_ii=A*B;
parte1_iii=C^2;
C=C.^2;
parte3=inv(A);
%parte4=det(B); % breaks the file
D=A.*B;
save -ascii 'ejercicio2p1.txt';