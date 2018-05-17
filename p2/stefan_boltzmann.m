clear;

Tref = 298; % En K
Rref = 0.9; % En ohmios (V/A) podria ser 1.1
alfa = 4.5e-3; % En 1/K
sigma = 5.67e-11; % W/m2K2

% Cargo el voltaje V, la intensidad I, y la radiacion medida Vrad
load datos1.mat

% millivolts to volts
Vrad =  Vrad ./ 1000;

% calculo resistencia utilizando la Ley de Ohm
R = V./I;

% Calculo la temperatura utilizando la formula indicada
% en la documentacion del dispositivo
T = ((R - Rref) / (alfa * Rref)) + Tref;

%
% objetivo teorico: E = sigma * (T.^4);

grado =  calcular_grado(T, Vrad);
if grado ~= 4
	disp(['Warning: El grado calculado (', num2str(grado),') no es el esperado (4)']);
	P = polyfit(log(T), log(Vrad), 1);
	grado = round(P(1));
	if grado == 4
		disp(['Se pudo obtener grado = 4 a partir de polyfit con logaritmos: P(1) = ', num2str(P(1))]);
 	else
          error('Error: Imposible lograr un polinomio de grado 4 con estos datos');
	end
end

figure
grid on;
hold on;
plot(T, Vrad, 'x', 'MarkerEdgeColor','r','MarkerSize',8);
plot(T, smooth(Vrad), 'b-');
xlabel('Temperatura (K)');
ylabel('Potencia (mV)');
hold off;
print('Stefan_Boltzmann1','-dpng');

%
% Tengo que graficar
%% potencia en funcion de T a la n
%% recta de ajuste por minimos cuadrados
% todo en el mismo chart

figure
grid on;

% potencia en funcion de T a la n
ax1_color = [.8 .1 .1];
ax1 = gca; % current axes
ax1.XColor = ax1_color;
ax1.YColor = ax1_color;
ax1.XLabel.String = 'T^4';
ax1.YLabel.String = 'Potencia (mV)';
line(T.^4, Vrad, 'Color', ax1_color);
legend(ax1, 'Potencia en funcion de T^4', 'Location', 'northwest');

% y ahora, con polyfit, pero escalando T porque sino da overflow
% Esto implica que el coeficiente es `escala` veces mas grande
escala = 1e12;
P = polyfit(T.^4/escala, Vrad, 1);
disp(['Pendiente: ',num2str(P(1)/escala)]);

ax2_color = [.25 .25 .25];
ax2 = axes('Position', ax1.Position,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
ax2.XColor = ax2_color;
ax2.YColor = ax2_color;
ax2.XLabel.String = 'T';
ax2.YLabel.String = 'Potencia (mV)';
line(T.^4, polyval(P, T.^4)/escala, 'Parent', ax2, 'Color', ax2_color);
legend(ax2, 'Recta ajustada', 'Location', 'southeast');

print('Stefan_Boltzmann2','-dpng')
