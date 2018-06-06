function area = compute_area( image_path )
	[ ~, file_name ] = fileparts(image_path);
		
	if isempty(file_name)
		error(strcat({'Invalid file '}, image_path));
	end

	% cargo imagen
	img = imread(image_path);

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
		map = load(strcat('Ozono14/Años/', format, '.mat'));
		colormap(map.(format));
	else
		error(strcat('Unknown format: ', format));
	end

	% Seleccionamos la region a la cual se le quiere calcular el area
	% Utilizamos imfreehand que da mejor presición que finput
	h = imfreehand;
	pos = getPosition(h);
	%close all;
	
	area = polyarea(pos(:,1), pos(:,2));
	
	% Area antartida medida en la imagen del 2002 8.0966e+03
	% Area real de la antartida 14 million km²
	area_antartida = 14e6;
	escala = area_antartida / 8.0966e03;
	area = (area * escala);
end
