clear;

A = load('-ascii', 'matriz.dat');

[m, n] = size(A);

row2 = A(2,:);
row4 = A(4,:);
column2 = A(:,2);

vect_zeros = zeros(n, m);
vect_ones = ones(n, m);

save 'ejercicio3p1.mat';

figure;
hold on
% una en rojo con dashes y linea un poco mas ancha
plot(A(:,4), column2, 'r--','LineWidth',2)
% otra en azul continua con marker (verde tanto por letra como por rgb)
plot(A(:,3), A(:,1), '-bo','MarkerEdgeColor','g','MarkerFaceColor',[0 1 0],'MarkerSize',2);
hold off
title('Practico1 - Ejercicio 3');
ylabel('Columnas 1 y 2');
xlabel('Columnas 3 y 4');
legend('Columna 4', 'Columna 3', 'Location', 'northwest');

print('grafica3p1.jpg', '-djpeg');
