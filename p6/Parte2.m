close all
clear 
clc

myblue = hex2rgb('507DBC');
myorange = hex2rgb('D95D39');
myyellow = hex2rgb('DCB600');
mygreen = hex2rgb('00D23F');

%Creamos un histograma con las velocidades en cada mes

%L es una es un vector con las cotas de velocidad con las que se clasifican
%los eventos de CME 

S1 = 'univ2012_';
S3 = '.txt';

v=cell(12,1);
a=cell(12,1);
m=cell(12,1);

for i = 1:12
	S4 = sprintf('%02d', i);
	[v{i}, a{i}, m{i}] = leerSOHO(strcat(S1, S4, S3));
end


v_all = cell2mat(v);
a_all = cell2mat(v);
m_all = cell2mat(v);

%
% Disribucion cumulativa, solo para darle color
figure;
hax = axes;
hold on;
v_sorted = sort(v_all, 'descend');
plot(v_sorted, 1:length(v_sorted), 'LineWidth', 1);
x_line = linspace(subindex(get(hax, 'XLim'), 1), subindex(get(hax, 'XLim'), 2));
y_line = ones(100,1);
plot(x_line,500*y_line, 'Color', myorange);
plot(x_line,1000*y_line, 'Color', myorange);
plot(x_line,2000*y_line, 'Color', myorange);
%plot(x_line,3000*y_line, 'Color', nice_orange);
%plot(x_line,4000*y_line, 'Color', nice_orange);
title('Distribución cumulativa de la velocidad de las CME en el año 2012');
legend(['Distribución cumulativa de CMEs en ' char(10) 'base a su velocidad']);
ylabel('Cantidad');
xlabel('Velocidad (Km/h)');

% Cambio un poco el tema del histograma, para que se vea mejor

figure;
grid on;
L = [0 500 1000 2000 3000 4000];
[count, centers] = hist(v_all, L);
bar(1:length(L), count, 'FaceColor', myblue, 'EdgeColor', myyellow);
text(1:length(L),count,num2str(count'),'vert','bottom','horiz','center');
set(gca,'xticklabel', { 'S-type'; 'C-type'; 'O-type'; 'R-type'; 'ER-type' });
title('');

%histogram (v_all, L, 'xticklabel',labels);

for i = 1:12
%	figure
%	histogram (v{i}, L);
	N(i,:) = histcounts (v{i}, L);
end

S = sum (N(:,1));
C = sum (N(:,2));
O = sum (N(:,3));
R = sum (N(:,4));
ER = sum (N(:,5));


CME = [S C O R ER];

%En la parte anterior tambien podemos hacer un plot de cada mes para ver en
%que mes se dio un oulier, y asi identificar el evento de 2012
