
% escala s
s = 0.453; % en km/px

area_en_pixeles = 1093950;
area_en_km = 1093950 * (s^2); % px^2 * km^2/px^2

D = load('diametros.txt');
D = D .* s;
D = sort(D, 'descend');

% Distribuci�n cumulativa
N = 1:length(D); 
% TODO: Mejorar la grafica y discutir (para el informe)
figure;
plot(D, N, 'LineWidth',1);
title('Distribuci�n cumulativa del tama�o de cr�teres');
legend('Distribucion');
ylabel('Cantidad');
xlabel('Tama�o en km');

%Estimacion de frecuencias cumulativas de inpacto en al tierra
% TODO: Explicar por que se puede asumir que la tasa 
% de impacto es la misma entre Tierra y Luna

radio_tierra = 6378; % en km
area_tierra = 4 * pi * radio_tierra^2;
% Tasa de impactos por k^2 y millon de a�os
millones_de_anios = 3000;
tasa_impacto = N / (area_en_km * millones_de_anios);
% Ahora si, frecuencia de impacto en la tierra:
F = tasa_impacto * area_tierra; % Notar que queda en impactos por millones de a�os
% Periodo es el inverso de la frecuencia
P = F .^ -1;

v = 17; % en km/s, porque crater2proy lo espera asi 
rhop = 3000; % en kg/m^3
theta = 45; % pi/4, crater2proy lo espera en grados
rhot = 2500; % en kg/m^3
g = 1.67; % m/s^2
tipo = 2; % tipo de suelo arenoso
% diametro del proyectil
d = crater2proy(D, rhop, v, theta, rhot, g, tipo);

%
% Frecuencia y Per�odo de los impactos en funci�n del di�metro del asteroide
figure;
subplot('Position', [0.07, 0.1, 0.42, 0.84])
plot(d/1000, F, 'LineWidth',1);
title('Frecuencia vs Diametro');
legend(['Frecuencia de los impactos' char(10) 'en funci�n del di�metro' char(10) ' del asteroide'], 'Location','NorthEast');
ylabel('Frecuencia (impactos/millones de a�os)');
xlabel('Di�metro del asteroide (km)');
subplot('Position', [0.57, 0.1, 0.42, 0.84]);
plot(d/1000, P, 'LineWidth',1);
title('Per�odo vs Diametro');
legend(['Per�odo de los impactos' char(10) 'en funci�n del di�metro' char(10) ' del asteroide'], 'Location','NorthEast');
ylabel('Per�odo (millones de a�os por impacto)');
xlabel('Di�metro del asteroide (km)');

disp(['Frecuencia mas alta: ', num2str(F(1)), ', periodo: ', num2str(P(1))]);
disp(['Frecuencia mas baja: ', num2str(F(end)), ', periodo: ', num2str(P(end))]);


masas = rhop * 4/3 * pi * ((d/2) .^3); % rhop * 1/6 * pi * d .^ 3

% Energia en Joules
E = (masas / 2) * (v * 1000)^2;

% Energia en kilot�n de TNT
E = E / 4.3e12;

%close all;
figure;

subplot('Position', [0.07, 0.1, 0.42, 0.84])
loglog(E, F, 'LineWidth',1);
title('Energ�a vs Frecuencia');
legend(['Frecuencia de los impactos' char(10) 'en funci�n de la energ�a' char(10) 'producida por los mismos'], 'Location','NorthEast');
ylabel('Frecuencia (impactos/millones de a�os)');
xlabel('Energ�a (en kilotones de TNT)');

subplot('Position', [0.57, 0.1, 0.42, 0.84]);
loglog(E, P, 'r', 'LineWidth',1);
title('Energ�a vs Per�odo');
legend(['Per�odo de los impactos' char(10) 'en funci�n de la energ�a' char(10) 'producida por los mismos'], 'Location','NorthWest');
ylabel('Per�odo (en millones de a�os)');
xlabel('Energ�a (en kilotones de TNT)');

% Calculo de la tasa promedio de muerte por colision

poblacion_mundial = 7.3*10^9;
% Convertinos a tons de TNT (estaba en kilotons)
E_t = E*1e3; 
% ultimo elemento con energia superior a los 11 megatons
pos = find(E_t>1e11, 1, 'last');
tau = (poblacion_mundial*0.25*F(pos))*1e-6;
disp(['Tasa promedio de muerte por colision: ', num2str(tau)]);

