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
sumABC=A+B-C;
prodAB=A*B;
sqC=C^2;
sqC2=C.^2;
invA=inv(A);
detB=det(B); % cannot save it to acii file
D=A.*B;
save -ascii 'ejercicio2p1.txt' A B C sumABC prodAB sqC sqC2 invA D;
