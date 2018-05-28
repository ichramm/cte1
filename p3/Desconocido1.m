function [relaerror, abserror] = Desconocido1(peak_locations, reference_lines, ~, ~, ~)
 	len = length(reference_lines);
 	abserror = zeros(len, 1);
 	relaerror = zeros(len, 1);	
	
	peak_locations = cat(1, peak_locations, NaN);
	
	% voy por los primeros 4 hasta entender el resto
 	for i=1:len
		if peak_locations(i) == -1
			abserror(i) = NaN;
			relaerror(i) = NaN;
		else
			abserror(i) = peak_locations(i)-reference_lines(i);
			relaerror(i) =  abserror(i) / reference_lines(i);
		end
 	end
end
