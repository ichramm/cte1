function [P, A] = procesar_medida(medida, name)
	% Nota: 1 radio solar = 695700 km
	
	timestamps = medida(:,1); % en el formato date de MATLAB
	deltaX = medida(:,2) * 695700; % en km
	
	% El tiempo hay que manejarlo en segundos siempre
	% Solo para graficar se usa en formato fecha
	deltaT = (timestamps - timestamps(1)) * 86400;
	
	% Aproximo deltaX con polinomio de grado 2
	P = polyfit(deltaT, deltaX, 2);
	
	% Creo una figura con el nombre especificado
	figure('NumberTitle', 'off', 'Name', name);
	
	
	% Primer plot, altura respecto al tiempo
	% Se muestra grande arriba
	
	subplot('Position', [0.05, 0.57, 0.9, 0.4]);
	grid on;
	hold on;
	plot(timestamps, deltaX, 'o');
	plot(timestamps, polyval(P, deltaT), 'LineWidth', 1);
	% TODO: Solucionar tema de espacio vacio al principio del plot
	datetick('x','HH:MM', 'keepticks');
	xlim([timestamps(1)-1/288 timestamps(end)+1/288]); % 5 minutos +/-
	legend('Altura de la CME', 'Curva de ajuste', 'Location','NorthWest');
	ylabel('Kilómetros');
	
	% Derivo ecuacion cinematica
	PV(1) = 2 * P(1);
	PV(2) = P(2);
	
	% Velocidad media e instantanea
	
	V = zeros(length(deltaT), 1);
	V(1) = P(2); 
	for i=2:length(deltaT)
		V(i) = (deltaX(i) - deltaX(i-1)) / (deltaT(i)-deltaT(i-1));
	end
	
	% Segundo plot, velocidad media a instantanea
	% Se muestra abajo a la izquierda
	
	subplot('Position', [0.05, 0.07, 0.4, 0.4]);
	grid on;
	hold on;
	plot(timestamps, V, 'LineWidth', 1);
	plot(timestamps, polyval(PV, deltaT), 'LineWidth', 1);
	datetick('x','HH:MM', 'keepticks');
	xlim([timestamps(1)-1/288 timestamps(end)+1/288]); % 5 minutos +/-
	legend('Velocidad media', 'Velocidad instantanea (dx/dt)', 'Location','NorthWest');
	ylabel('km/s');
	
	% Aceleracion (constante) en metros/segundo^2
	A = PV(1)*1000;
	disp(strcat({'Aceleracion (m/s^2): '}, num2str(A)));
	
	% Tercer plot, aceleracion (medio al dope pero queda lindo)
	% Se muestra abajo a la derecha
		
	subplot('Position', [0.55, 0.07, 0.4, 0.4]);
	grid on;
	hold on;
	plot(timestamps, A*ones(length(timestamps), 1), 'LineWidth', 1);
	datetick('x','HH:MM', 'keepticks');
	xlim([timestamps(1)-1/288 timestamps(end)+1/288]); % 5 minutos +/-
	legend('Aceleración (supuesta constante)', 'Location','NorthWest');
	ylabel('m/s^2');
end
