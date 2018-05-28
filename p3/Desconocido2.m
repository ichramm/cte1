function [relaerror, abserror] = Desconocido2(peak_locations, reference_lines, lambda, luma, peak_values)
 	len = length(peak_locations);
 	abserror = zeros(len, 1);
 	relaerror = zeros(len, 1);
	
	start_pos = find(lambda > 4000, 1);
	
	fig = figure('units','normalized','outerposition',[0 0 1 1]);
	set(groot, 'CurrentFigure', fig);
	hax = axes;
	hold on;
	nice_blue = hex2rgb('507DBC');
	nice_orange = hex2rgb('D95D39');
	plot(lambda(start_pos:end), luma(start_pos:end), 'Color',nice_blue);
	plot(peak_locations, peak_values, 'vr', 'MarkerFaceColor',nice_blue, 'MarkerEdgeColor',nice_blue, 'DisplayName','Pepe');
	for i=1:length(reference_lines)
		plot(ones(100,1)*reference_lines(i), linspace(1, subindex(get(hax, 'YLim'), 2)), 'Color',nice_orange,'LineWidth',1);
	end
	% Agrego leyendas para todos. Cada linea de referencia es considerada 
	% como un plot -aunque use line()-, pero no importa, porque son del mismo color
	legend('Luminosidad', 'Maximos locales', 'Lineas de referencia');
	% Con esto hago que muestra los numeros arriba y a la derecha
	xlabel('\lambda (Å)');
	ylabel('Intesidad (luma)');
	axes('xlim', get(hax, 'XLim'), 'ylim', get(hax, 'YLim'), 'color', 'none', 'YTick',[], 'XAxisLocation', 'top');
	axes('xlim', get(hax, 'XLim'), 'ylim', get(hax, 'YLim'), 'color', 'none', 'XTick',[], 'YAxisLocation', 'right');
	
	hold off;
	print('Desconocido2-graph3_zoom.png', '-dpng');
	
 	for i=1:len
 		abserror(i) = peak_locations(i)-reference_lines(i);
 		relaerror(i) =  abserror(i) / reference_lines(i);
 	end
end
