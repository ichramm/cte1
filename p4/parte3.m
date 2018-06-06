% febrero: manchita 225 en colonia
% marzo: manchita 275 al norte
% junio: pequeña manchita al norte
% julio: mayoritariamente 275 pero un poco de 300 en mdeo
% agosto: una manchita de 300 al norte
% setiembre: una manchita de 325 al norte
% octubre: mas de 300 que de 325
% noviembre: casi todo 325
% diciembre: 275 con alguna mancha de 300
levels = [ 275 240 285 275 275 295 280 315 340 310 320 280 ];

%figure('units','normalized','outerposition',[0 0 1 1]);
figure;
hax = axes;
hold on;
grid on;
meses = datenum(2005, 1:12, 1);

plot(meses, smooth(levels), 'Color', hex2rgb('304D8C'), 'LineWidth',2);
line(get(hax, 'XLim'), [mean(levels), mean(levels)], 'LineStyle', '--', 'Color', hex2rgb('a33434'));
line(get(hax, 'XLim'), [median(levels), median(levels)], 'LineStyle', '--', 'Color', hex2rgb('34a334'));
%line(meses, ones(length(meses), 1) .* mean(levels), '--');
%line(meses, ones(length(meses), 1) .* median(levels), '--');
%plot(meses, levels, 'Color', hex2rgb('ececec'), 'LineWidth',0.1);
plot(meses, levels, 'o', 'MarkerFaceColor', hex2rgb('D95D39'), 'MarkerEdgeColor', hex2rgb('608DCC'), 'MarkerSize', 7, 'LineWidth', 1.5);
datetick('x','mmm');

legend('Niveles de ozono Uruguay 2005', 'Promedio', 'Mediana');
xlabel('Mes');
ylabel('Dobson units');
xlim([datenum(2004, 12, 15) datenum(2005, 12, 20)]);
ylim([200 350]);
hold off
print(strcat('UY2005.png'), '-dpng');
disp(min(levels));
disp(max(levels));
disp(mean(levels));
disp(median(levels));

