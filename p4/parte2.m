
% Directorio donde guardo las regiones obtenidas de la imagen
if ~exist('./regiones', 'dir')
	mkdir('./regiones');
end

% A�os para los cuales voy a leer data
years = 1978:2012;

% Inicializo array con las areas
areas = zeros(length(years), 1);

for i = 1:length(years)
	year = years(i);
	
	% Dado que son muchos y que esto va a llevar tiempo, es mejor ir
	% guardando los datos a medida que vamos trabajando
	region_file = fullfile(cd, strcat('regiones/', num2str(year), '.txt'));

	% Si ya proces� este archivo entonces cargo los datos directamente
	if exist(region_file, 'file')
		data = load(region_file);
		x = data(:,1)';
		y = data(:,2)';
	else
		% Nombre del archivo (extensi�n incluida)
		files = ls(strcat('Ozono14/A�os/*', num2str(year), '1*.png'));
		if isempty(files)
			disp(['No data for ', num2str(year)]);
			continue;
		end

		file_name = files(1,:);
	
		% cargo imagen
		img = imread(strcat('Ozono14/A�os/', file_name));
		% escalo imagen para eliminar distorsion
		imagesc(img);
		% igualo ejes
		axis equal
		% magia recomendada por el teacher
		caxis([0 255]);
		
		% Extraigo formato del nombre del archivo
		format = file_name(10:13);
		% Cargo mapa de colores correspondiente
		if strcmp(format, 'ept_') || ...
				strcmp(format, 'mt3_') || ...
				strcmp(format, 'n7t_') || ...
				strcmp(format, 'omi_') || ...
				strcmp(format, 'toms')
			if format(4) == '_'
				format = format(1:3);
			end
			map = load(strcat('Ozono14/A�os/', format, '.mat'));
			colormap(map.(format));
		else
			error(strcat('Unknown format: ', format));
		end
		
		% Seleccionamos la region a la cual se le quiere calcular el area
		% Utilizamos imfreehand que da mejor presici�n que ginput
		h = imfreehand;
		pos = getPosition(h);
		close all; % ya no necesito la imagen
		
		x = pos(:,1);
		y = pos(:,2);
		
		% Guardo los puntos capturados en el archivo
		data = [ x y ];
		save(region_file, 'data', '-ascii');
	end
    
    areas(i) = polyarea(x, y);
end

% Area antartida medida en la imagen del 2002 8.0966e+03
% Area real de la antartida 14 million km�
area_antartida = 14e6;
escala = area_antartida / 8.0966e03;
otra_escala = 1e6; % Asi hablamos en millones de km
areas = (areas .* escala) ./ otra_escala;
figure('units','normalized','outerposition',[0 0 1 1]);
hax = axes;
hold on;
grid on;
% Grafica linda
plot(years, smooth(areas), 'Color', hex2rgb('507DBC'), 'LineWidth', 1.5);
% Area de la antartida
plot(1978:2012, ones(2012-1978+1,1)*(area_antartida/otra_escala), '--', 'Color',hex2rgb('D95D39'),'LineWidth',1);
% Puntos
plot(years, areas, 'o', 'Color', hex2rgb('3c3c3c'), 'MarkerFaceColor', hex2rgb('3c3c3c'));
xlim([1978 2012]);
legend('Variacion anual del tama�o del agujero de ozono', '�rea de la Ant�rtida');
xlabel('A�o');
ylabel('Area (en millones de Km^2)');
hold off
print(strcat('variacionOzono.png'), '-dpng');
