clear;
close all;

[stereoASoho, stereoBSoho, stereoAstereoB] = read_csv_data('stereocat.txt');

P = procesar_medida(stereoASoho, 'Stereo A - SOHO');
disp([P(1) P(2) P(3)]);

P = procesar_medida(stereoBSoho, 'Stereo B - SOHO');
disp([P(1) P(2) P(3)]);

P = procesar_medida(stereoAstereoB, 'Stereo A - Stereo B');
disp([P(1) P(2) P(3)]);


