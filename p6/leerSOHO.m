function [v,a,m] = leerSOHO(fileName)

% Esta  funcion devuelve tres vectores columna v, a y m con los valores de
% velocidad, aceleracion y masa, respectivamente, que se encuentran en el
% archivo 'fileName'

% NOTA: si el archivo se llama fileName.txt, la sintaxis para aplicar la
% funcion es: [v,a,m]=leerSOHO('fileName.txt')

% Abrimos el archivo 'filename' y extraemos sus datos
fid=fopen(fileName,'r');
C=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %*[^\n]','Delimiter',' ','MultipleDelimsAsOne',1,'Headerlines',4);
fclose(fid);

% Creamos vectores velocidad (v), aceleracion (a) y masa (m) 
v = C{5}; v=str2double(v);
a = C{8}; a=str2double(a);
m = C{9}; m=str2double(m);

