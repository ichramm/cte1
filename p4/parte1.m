
colors = [ hex2rgb('507DBC'); hex2rgb('D95D39') ];

years = [2000 2005];
levels = zeros(2, 12);

for i=1:length(years)
	year = years(i);
	data = load(strcat('PS', num2str(year), '.txt'));
	
	meses = datenum(year, 1:12, 1);
	levels(i,:) = data(:,2);
	
	%figure('units','normalized','outerposition',[0 0 1 1]);
	figure;
	hold on;
	grid on;
	
	bar(meses, levels(i,:), 'FaceColor', colors(i,:),'EdgeColor',[0 .9 .9],'LineWidth',1);
	datetick('x','mmm');
	legend(strcat({'Niveles de ozono para el año '}, num2str(year)));
	xlabel('Mes');
	ylabel('Dobson units');
	xlim([datenum(year-1, 12, 15) datenum(year, 12, 20)]);
	print(strcat('PS', num2str(year), '.png'), '-dpng');
	
	close();
end

%figure('units','normalized','outerposition',[0 0 1 1]);
figure;
hold on;
grid on;
meses = datenum(2000, 1:12, 1);
w = 1;
for i=1:length(years)
	bar(meses, levels(i,:), w, 'FaceColor', colors(i,:),'EdgeColor',[0 .9 .9],'LineWidth',1, 'FaceAlpha', w);
	w = 0.8;
	datetick('x','mmm');
end

legend('Niveles de ozono para año 2000', 'Niveles de ozono para año 2005');
xlabel('Mes');
ylabel('Dobson units');
xlim([datenum(1999, 12, 15) datenum(2000, 12, 20)]);
hold off
print(strcat('PS2000vs2005.png'), '-dpng');

% Set 2000: 2.7731e+07
% Oct 2000: 2.4119e+07
% Set 2005: 2.6139e+07
% Oct 2005: 2.4483e+07

