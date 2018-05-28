function [relaerror, abserror] = Hidrogeno(peak_locations, reference_lines, ~, ~, ~)
	len = length(peak_locations);
	abserror = zeros(len, 1);
	relaerror = zeros(len, 1);
	for i=1:len
		abserror(i) = peak_locations(i)-reference_lines(i);
		relaerror(i) =  abserror(i) / reference_lines(i);
	end
end

