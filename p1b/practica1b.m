%
% Practica1B
%
% Esta funcion carga los archivos de datos asumiendo que su
% nombre tiene el formato datos<numSamples>.txt. Luego, arma 
% histograma, le superpone la gaussiana, y guarda los gráficos 
% en un archivo superpuestas<numSamples>.png.
%
% Parametros:
%   numSamples: Cantidad de samples (20 o 50, default: 20)
%   histSize: Cantidad de bins en el histograma (default: 6)
%
% Autores:
%   Juan Ramirez <jramirez.uy@gmail.com>
%   Andres Flores <andyflores95@gmail.com>
%   Eduardo Chamlian <eduardochamlian@gmail.com>
function practica1b(numSamples, histSize)
	if nargin < 1
		numSamples = 20;
	else
		numSamples = str2double(numSamples);
	end
	if nargin < 2
		histSize = 6;
	else
		histSize = str2double(histSize);
	end

	% Cargo archivo con los datos
	D = load(strcat('datos', num2str(numSamples), '.txt'));

	% Chequeo de input
	if numSamples ~= length(D)
		error('Numero de samples en el archivo no concuerda con el ingresado');
	end

	% Obtengo un histograma a partir de los datos en D
	[counts, centers] = hist(D, histSize);

	% Calculo parametros de la distribucion normal
	[muhat, sigmahat] = normfit(D);

	% Genero lista de valores equi-espaciados entre el minimo y el maximo
	% Esto me permite suavisar la curva de la gaussiana
	X = linspace(centers(1), centers(histSize));

	% deltaX = Tamaño del segmento del histograma
	% deltaX = (max - min) / histSize
	deltaX = centers(2) - centers(1);

	% Calculo deltaN, en 2 pasos para mejor claridad
	exponente = (-(X - muhat).^2) / (2*(sigmahat^2));
	deltaN = ( numSamples / ( sigmahat * sqrt(2*pi) ) ) * exp(exponente) * deltaX;

	% graficas
	figure;
	hold on;
	bar(centers, counts);
	plot(X, deltaN, 'r');
	xlabel('Valores medidos');
	ylabel('Ocurrencias');
	title('Gaussiana sobre histograma');
	hold off;
	print(strcat('superpuestas', num2str(numSamples),'.png'), '-dpng');
end
