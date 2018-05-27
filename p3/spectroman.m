%
function [data, lambda, luma, peak_values, peak_locations] = spectroman(element)
% spectroman Procesa los datos del archivo data_file (acorder a la letra de la practica 3)
	% data tiene tutti, hay que extraer las columnas que interesan
	if nargin < 1
		element = 'Hidrogeno';
	end
	
	% nice blue color
	nice_blue = hex2rgb('507DBC');
	
	% Mas o menos sabemos como viene la mano
	% asi que vamo' a cargar alguna data custom propia del experimento
	num_peaks = 0;
	min_peak_x = 0;
	%lineas_ref = [ 3000 4000 5000 ];
	if strcmp(element, 'Hidrogeno')
		line_references = load('./line_references/Hidrogeno.txt');
		num_peaks = length(line_references);
		min_peak_x = 3000;
	elseif strcmp(element, 'Desconocido1')
		% Luego de estudiar la info disponible concluimos que Desconocido1 es Helio
		line_references = load('./line_references/Helio.txt');
		num_peaks = length(line_references);
		min_peak_x = 4000;
	elseif strcmp(element, 'Desconocido2')
		% Luego de estudiar la info disponible concluimos que Desconocido1 es Neon
		line_references = load('./line_references/Neon.txt');
		num_peaks = length(line_references);
		min_peak_x = 2000;
	else
		error(strcat({'Unknown element '}, element));
	end
	
	% Cargo datos del archivo
	data = load(strcat('./data/', element, '.txt'));
	
	% Cargo lambda, ya convertido a angstroms (1A = 0.1nm)
	lambda = data(:,2) .* 10;
	
	% Cargo el valor de luminosidad luma
	luma = data(:,4);
	
	figure('units','normalized','outerposition',[0 0 1 1])
	hax = axes;
	
	hold on
	grid on;
	
	% Busco picos, pero ignoro el principio del vector
	% Nota: MinPeakProminence = 20 parece funcionar ok con todos los sets de datos
	start_pos = find(lambda > min_peak_x, 1);
	[peak_values, peak_locations] = findpeaks(luma(start_pos:end), lambda(start_pos:end),'NPeaks',num_peaks, 'MinPeakProminence', 20);
	
	% Los picos se guardan en un archivo <element>-peaks.txt
	save_peaks(element, peak_locations, peak_values);
	
	% Empiezo a dibujar las graficas, son varias
	% 1. La principal
	% 2. Los picos (solo el triangulo)
	% 3. Las lineas de referencia
	
	% Dibujo la gráfica (debería ser muy parecida a la generada por Tracker)
	plot(lambda, smooth(luma, 2), 'Color',nice_blue);
	
	% Dibujo los picos primero (para poder aplicar la legend y el texto)
	plot(peak_locations, peak_values, 'vr', 'MarkerFaceColor',nice_blue, 'MarkerEdgeColor',nice_blue, 'DisplayName','Pepe');
	
	% Dibujo area ignorada (update: no dibujo nada)
	% area([0 1200], [300 300], 'FaceColor',hex2rgb('580C1F'),'FaceAlpha',0.3,'EdgeAlpha',0);
	
	% Dibujo las lineas de referencia
	draw_reference_lines(line_references, hax);
	
	% Agrego leyendas para todos. Cada linea de referencia es considerada 
	% como un plot -aunque use line()-, pero no importa, porque son del mismo color
	legend('Luminosidad', 'Maximos locales', 'Lineas de referencia');
	
	draw_peak_text(peak_locations, peak_values);
	
	% Con esto hago que muestra los numeros arriba y a la derecha
	axes('xlim', get(hax, 'XLim'), 'ylim', get(hax, 'YLim'), 'color', 'none', 'YTick',[], 'XAxisLocation', 'top');
	axes('xlim', get(hax, 'XLim'), 'ylim', get(hax, 'YLim'), 'color', 'none', 'XTick',[], 'YAxisLocation', 'right');
	
	% Creo variables para cftool
	% Nota: Crear variables de esta manera es MUY mala practica. Lo hago porque 
	% cftool no soporta indexar matrices
	for i=1:length(peak_locations)
		[x_region, y_region] = make_peak_region(peak_locations(i), lambda, luma);
		assignin('base', strcat('peak_zone_x', num2str(i)), x_region);
		assignin('base', strcat('peak_zone_y', num2str(i)), y_region);
	end
	
	hold off;
	
	% Guardo la grafica en un archivo <element>-graph1.png
	%fig = gcf;
	%fig.PaperUnits = 'inches';
	%fig.PaperPosition = [0 0 6 3];
	print(strcat(element, '-graph1.png'), '-dpng');
end

function draw_reference_lines(references, hax)
	tableposy = 280;
	tableposx = 2100;
	nice_orange = hex2rgb('D95D39');
	text(tableposx, tableposy, 'Lineas de referencia:', 'Color',[.3 .3 .3], 'FontSize', 9);
	for i=1:length(references)
		line([references(i), references(i)], get(hax, 'YLim'), 'Color',nice_orange, 'LineWidth',1);
		textstr = strcat({' |- '}, num2str(references(i)));
		text(tableposx, tableposy-(i*10), textstr, 'Color',[.3 .3 .3], 'FontSize', 9);
		%plot(ones(100,1)*references(i), linspace(1,300), 'Color',nice_orange,'LineWidth',1);
	end
end

function save_peaks(element, peak_locations, peak_values)
% save_peaks Guarda los maximos locales en un archivo
%	columan 1 es x
%	columna 2 es y
	A = [ peak_locations peak_values ]; %#ok
	save(strcat(element, '-peaks.txt'), 'A', '-ascii');
end

function draw_peak_text(peak_locations, peak_values)
% draw_peak_text Dibuja los valores de los maximos locales, pero solo si no
% son muchos
	tableposy = 280;
	tableposx = 1100; % aprox
	text(tableposx, tableposy, 'Maximos', 'Color',[.3 .3 .3], 'FontSize', 9);
	for i=1:length(peak_locations)
		textstr = strcat({' |- ('}, num2str(peak_locations(i)), {', '}, num2str(round(peak_values(i))), ')');
		text(tableposx, tableposy-(i*10), textstr, 'Color',[.3 .3 .3], 'FontSize',9);
	end
	
	%last_peak_val = 0;
	%last_peak_loc = 0;
	%for i=1:length(peak_locations)
	%	text(1000, 250-(i*10), textstr, 'Color',[.3 .3 .3], 'FontSize',9, 'HorizontalAlignment','left', 'VerticalAlignment','bottom' );
	%	if peak_locations(i) - last_peak_loc > 200 || abs(peak_values(i) - last_peak_val) > 50 || (peak_locations(i) - last_peak_loc > 25 && abs(peak_values(i) - last_peak_val) > 20) % totalmente arbitrario
	%		text(peak_locations(i), peak_values(i), textstr, 'Color',[.3 .3 .3], 'FontSize',9, 'HorizontalAlignment','left', 'VerticalAlignment','bottom' );
	%		c = 0.9 - 1/log(peak_values(i));
	%		area([peak_locations(i)-100 peak_locations(i)+100], [300 300], 'FaceColor',[c c+.1 c],'FaceAlpha',0.3,'EdgeAlpha',0);
	%	end
	%	last_peak_loc = peak_locations(i);
	%	last_peak_val = peak_values(i);
	%end
end

function [x_region, y_region] = make_peak_region(peak_location, xdata, ydata)
% make_peak_zones Particiona los vectores alrededor de la region del pico
% para poder utilizar la gaussiana
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

