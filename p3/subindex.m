function output = subindex(input, index)
%SUBINDEX Helper para indexar resultados de llamadas a funciones
%   MATLAB no soporta hacer algo del estilo get(a, 'b)(1) pero 
%   esta funcion sirve de workaround: subindex(get(a, 'b), 1)
	output = input(index);
end

