clear;

a = input('a: '); if isempty(a) a = 0; end
b = input('b: '); if isempty(b) b = 0; end
c = input('c: '); if isempty(c) c = 0; end

disp(['> Resolviendo ', num2str(a), 'x^2 + ', num2str(b), 'x + ', num2str(c), ' = 0']);
	
if a ~= 0
	tosqrt = (b^2) - 4*a*c;
	if tosqrt >= 0
		x1 = (-b - sqrt(tosqrt)) / (2*a);
		x2 = (-b + sqrt(tosqrt)) / (2*a);
		disp(['> Soluciones: {', num2str(x1), ', ', num2str(x2), '}']);
	else
		disp('> La ecuacion no tiene soluciones reales');
	end
elseif b ~= 0
		disp('> a = 0, resolviendo como ecuacion lineal (raiz = -c/b)');
		x = (-c) / b;
		disp(['> Solucion: {', num2str(x), '}']);
else
	disp('> Imposible resolver dado que ambos a y b son nulos');
end
