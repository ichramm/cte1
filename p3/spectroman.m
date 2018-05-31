%
function [peak_locations, reference_lines, relaerror, lambda, luma, peak_values] = spectroman(element)
% spectroman Procesa los datos del archivo data_file (acorder a la letra de la practica 3)
	% data tiene tutti, hay que extraer las columnas que interesan
	if nargin < 1
		element = 'Hidrogeno';
	end
	
	% nice blue color
	nice_blue = hex2rgb('507DBC');
	nice_orange = hex2rgb('D95D39');
	
	% Mas o menos sabemos como viene la mano
	% asi que vamo' a cargar alguna data custom propia del experimento
	num_peaks = 0;
	min_peak_x = 0;
	min_peak_prominence = 10;
	%lineas_ref = [ 3000 4000 5000 ];
	if strcmp(element, 'Hidrogeno')
		reference_lines = load('./reference_lines/Hidrogeno.txt');
		num_peaks = length(reference_lines);
		min_peak_x = 3000;
		min_peak_prominence = 20;
	elseif strcmp(element, 'Desconocido1')
		% Luego de estudiar la info disponible concluimos que Desconocido1 es Helio
		reference_lines = load('./reference_lines/Helio.txt');
		num_peaks = length(reference_lines);
		min_peak_x = 4000;
		min_peak_prominence = 10;
	elseif strcmp(element, 'Desconocido2')
		% Luego de estudiar la info disponible concluimos que Desconocido1 es Neon
		reference_lines = load('./reference_lines/Neon.txt');
		num_peaks = length(reference_lines);
		min_peak_x = 4000;
		min_peak_prominence = 10;
	else
		error(strcat({'Unknown element '}, element));
	end
	
	% Cargo datos del archivo
	data = load(strcat('./data/', element, '.txt'));
	
	% Cargo lambda, ya convertido a angstroms (1A = 0.1nm)
	lambda = data(:,2) .* 10;
	
	% Cargo el valor de luminosidad luma
	luma = data(:,4);
	
	% Creo la grafica maximizada, asi queda bien visualmente
	fig = figure('units','normalized','outerposition',[0 0 1 1])
	hax = axes;
	
	hold on
	grid on;
	
	% Busco picos, pero ignoro el principio del vector
	% Nota: MinPeakProminence = 20 parece funcionar ok con todos los sets de datos
	start_pos = find(lambda > min_peak_x, 1);
	
	[peak_values, peak_locations] = findpeaks(luma(start_pos:end), lambda(start_pos:end),...
		'NPeaks',num_peaks, 'MinPeakProminence', min_peak_prominence);
	
	% Empiezo a dibujar las graficas, son varias
	% 1. La principal
	% 2. Los picos (solo el triangulo)
	% 3. Las lineas de referencia
	
	% Dibujo la gr�fica (deber�a ser muy parecida a la generada por Tracker)
	%plot(lambda(start_pos:end), luma(start_pos:end), 'Color',nice_blue);
	plot(lambda, luma, 'Color',nice_blue);
	
	% Dibujo los picos primero (para poder aplicar la legend y el texto)
	plot(peak_locations, peak_values, 'vr', 'MarkerFaceColor',nice_blue, 'MarkerEdgeColor',nice_blue, 'DisplayName','Pepe');
	
	% Dibujo las lineas de referencia
	for i=1:length(reference_lines)
		plot(ones(100,1)*reference_lines(i), linspace(1, subindex(get(hax, 'YLim'), 2)), 'Color',nice_orange,'LineWidth',1);
	end
	
	% Agrego leyendas para todos. Cada linea de referencia es considerada 
	% como un plot -aunque use line()-, pero no importa, porque son del mismo color
	legend('Luminosidad', 'Maximos locales', 'Lineas de referencia');
	
	% Con esto hago que muestra los numeros arriba y a la derecha
	xlabel('\lambda (�)');
	ylabel('Intesidad (luma)');
	axes('xlim', get(hax, 'XLim'), 'ylim', get(hax, 'YLim'), 'color', 'none', 'YTick',[], 'XAxisLocation', 'top');
	axes('xlim', get(hax, 'XLim'), 'ylim', get(hax, 'YLim'), 'color', 'none', 'XTick',[], 'YAxisLocation', 'right');
	
	print(strcat(element, '-graph1.png'), '-dpng');
	
	if length(peak_locations) < length(reference_lines)
		peak_locations = cat(1, peak_locations, NaN*ones(length(reference_lines)-length(peak_locations)));
	end
	
	% Si existe un archivo <element>.m, entonces llamo a una funcion con ese nombre
	relaerror = 0;
	abserror = 0;
	if exist(fullfile(cd, strcat(element, '.m')), 'file')
		clear(element);
		[relaerror, abserror] = feval(element, peak_locations, reference_lines, lambda, luma, peak_values);
		set(groot, 'CurrentFigure', fig);
	end
	
	% Los picos se guardan en un archivo <element>-peaks.txt
	save_peaks(element, peak_locations, reference_lines, relaerror, abserror);
	
	draw_tables(hax, reference_lines, peak_locations, relaerror, abserror)
	%draw_peak_text(peak_locations, peak_values);
	
	% Guardo la grafica en un archivo <element>-graph1.png
	print(strcat(element, '-graph2.png'), '-dpng');
	hold off;
	
	% Creo variables para cftool
	% Nota: Crear variables de esta manera es MUY mala practica. Lo hago porque 
	% cftool no soporta indexar matrices
	for i=1:length(peak_locations)
		if ~isnan(peak_locations(i))
			[x_region, y_region] = make_peak_region(peak_locations(i), lambda, luma);
			assignin('base', strcat('peak_zone_x', num2str(i)), x_region);
			assignin('base', strcat('peak_zone_y', num2str(i)), y_region);
		end
	end
	
	if (nargout > 0)
		close();
	end
end

function draw_tables(hax, reference_lines, peak_locations, relaerror, abserror)
	tableposx = subindex(get(hax, 'XLim'), 1) + 10; %startx + 10; % + 1100;
	tableposy = subindex(get(hax, 'YLim'), 2) - 10; %280;		
	text(tableposx, tableposy, 'Maximos locales y error relativo:', 'Color', 'k', 'FontSize', 9);
	for i=1:length(peak_locations)
		if ~isempty(relaerror) && i <= length(relaerror) && ~isnan(relaerror(i))
			textstr = sprintf('  |- \\lambda = %.2f, ref = %.2f, rel error: %.3f%%, abs error: %.1f', ...
                peak_locations(i), reference_lines(i), relaerror(i), abserror(i));
		else
			textstr = sprintf('  |- \\lambda = %.2f, ref = %.2f', peak_locations(i), reference_lines(i));
		end
		text(tableposx, tableposy-(i*10), textstr, 'Color', 'k', 'FontSize', 9);
	end
	A = [ reference_lines(1:length(peak_locations)) peak_locations relaerror abserror ];
end

%
% Guarda los maximos locales en un archivo
function save_peaks(element, peak_locations, reference_lines, relaerror, abserror)
	A = [ reference_lines peak_locations relaerror abserror ]; %#ok
	save(strcat(element, '-peaks.txt'), 'A', '-ascii');
end

%
% Particiona los vectores alrededor de la region del pico para poder utilizar la gaussiana
function [x_region, y_region] = make_peak_region(peak_location, xdata, ydata)
	count = 50;
		
	% Posicion del elemento actual en lambda
	pos = find(xdata == peak_location);
		
	if pos > count
		startpos = pos - count; 
	else
		startpos = 1; 
	end

	if pos + count < length(xdata) 
		endpos = pos + count; 
	else
		endpos = length(lambda); 
	end
	
	x_region = xdata(startpos:endpos);
	y_region = ydata(startpos:endpos);
end


% cargar 7 x 7 -> A
% sacar vectores re3sultantes -> I, lambda
% graficar I = I(A) (poner tit, ejes, etc)
% detectar picos (findpeaks)
% comparar con tablas
% calc E_r
% ajustar perfil de linea gaussiana (cftool)
% 
