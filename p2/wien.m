clear;

% Cargo la temperatura T y la longitud de onda L del archivo de datos
if exist(fullfile(cd, 'datos2.mat'), 'file')
	load datos2.mat;
else
	% No tengo datos, pero puedo simular que los tengo
	T = 3800:200:7600;            % Temperatura
	R = 0.95 + 0.1 * rand(1, 20); % Random entre 0.95 y 1.05, distribuidos uniformemente
	L = 0.0028976 * R .* T.^-1;   % Longitud de onda simulada
end

% Me quedo con el inverso de la temperatura
invT = T .^ -1;

% Aproximo por minimos cuadrados
P = polyfit(invT, L, 1);

% Hago dos graficas de lambda en funcion de T^-1 
% 1. A partir de los datos medidos
% 2. Utilizando el coeficiente calculado con polyfit

figure;
grid on;
hold on
title('\lambda en funcion del de T^{-1}');

plot(invT, L);
plot(invT, polyval(P, invT)); % invT.*P(1));
legend('\lambda medido', strcat('\lambda ajustado (coef:{ }', num2str(P(1)), ')'), 'location','northwest');
print('Wien','-dpng')
