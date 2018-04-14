function D = practica1b(numSamples, histSize)
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
	% El archivos de datos es el unico parametro que recibe esta funcion
	D = load(strcat('datos', num2str(numSamples), '.txt'));
	
	% Chequeo de input
	if numSamples ~= length(D)
		error('Numero de samples en el archivo no concuerda con el ingresado');
	end
    
	% Obtengo un histograma a partir de los datos en D
	% N tiene los valores y C los centros
    [counts, centers] = hist(D, histSize);
    
	% Calculo parametros de la distribucion nomral
    [muhat, sigmahat] = normfit(D);
    
    % Genero lista de valores equi-espaciados entre el minimo y el maximo
	% Esto me permite dibujar una grafica gaussiana con curva suave
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
	xlabel('Valor medidos');
	ylabel('Ocurrencias');
	title('Gaussiana sobre histograma');
    hold off;
	print(strcat('superpuestas', num2str(numSamples),'.jpg'), '-djpeg');
end
