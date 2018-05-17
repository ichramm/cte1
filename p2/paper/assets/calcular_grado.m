function [ grado, coef ] = calcular_grado(x, y)
% calcular_grado Busca el mejor grado para el polinomio de ajuste
%	[grado, coef] = calcular_grado(x, y)
	grado = 0; % El mejor grado encontrado
	coef = 0;  % El mejor coeficiente encontrado
	for i=1:5
		R = corrcoef(x.^i, y);
		if R(1,2) > coef
			grado = i;
			coef = R(1,2);
		end
	end
end
