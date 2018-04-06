clear;

A = load('-ascii', 'matriz.dat');

[m, n] = size(A);

row2 = A(2,:);
row4 = A(4,:);
column2 = A(:,2);

Zeroes = zeros(n, m);
Ones = ones(n, m);

save 'ejercicio3p1.mat';

figure;
% una en rojo con dashes y linea un poco mas ancha
% otra en azul continua
plot(A(:,4), column2, 'r--','LineWidth',2, A(:,3), A(:,1), '-bo','MarkerEdgeColor','g','MarkerFaceColor',[0 1 0],'MarkerSize',2);
title('Practico1 - Ejercicio 3');
xlabel('columns 2 and 1');
ylabel('columns 4 and 3');
legend('column 4', 'column 3');

print('grafica3p1.jpg', '-djpeg');
