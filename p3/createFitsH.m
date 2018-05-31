function [fitresult, gof] = createFits(peak_zone_x1, peak_zone_y1, peak_zone_x2, peak_zone_y2, peak_zone_x3, peak_zone_y3)
%CREATEFITS(PEAK_ZONE_X1,PEAK_ZONE_Y1,PEAK_ZONE_X2,PEAK_ZONE_Y2,PEAK_ZONE_X3,PEAK_ZONE_Y3)
%  Create fits.
%
%  Data for 'Hidrogeno 1' fit:
%      X Input : peak_zone_x1
%      Y Output: peak_zone_y1
%  Data for 'Hidrogeno 2' fit:
%      X Input : peak_zone_x2
%      Y Output: peak_zone_y2
%  Data for 'Hidrogeno 3' fit:
%      X Input : peak_zone_x3
%      Y Output: peak_zone_y3
%  Output:
%      fitresult : a cell-array of fit objects representing the fits.
%      gof : structure array with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 30-May-2018 19:56:21

%% Initialization.

% Initialize arrays to store fits and goodness-of-fit.
fitresult = cell( 3, 1 );
gof = struct( 'sse', cell( 3, 1 ), ...
	'rsquare', [], 'dfe', [], 'adjrsquare', [], 'rmse', [] );

%% Fit: 'Hidrogeno 1'.
[xData, yData] = prepareCurveData( peak_zone_x1, peak_zone_y1 );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [59.68 3798.4307 14.0561689365087 27.3319999982467 3867.6504 59.8249394487336];

% Fit model to data.
[fitresult{1}, gof(1)] = fit( xData, yData, ft, opts );

% Juan
figure( 'Name', 'Hidrogeno' );
hold on

% Plot fit with data.
%figure( 'Name', 'Hidrogeno 1' );
h = plot( fitresult{1}, xData, yData );
legend( h, 'peak_zone_y1 vs. peak_zone_x1', 'Hidrogeno 1', 'Location', 'NorthEast' );
% Label axes
xlabel peak_zone_x1
ylabel peak_zone_y1
grid on

%% Fit: 'Hidrogeno 2'.
[xData, yData] = prepareCurveData( peak_zone_x2, peak_zone_y2 );

% Set up fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0];
opts.StartPoint = [208.057 4313.2522 25.6851923406078];

% Fit model to data.
[fitresult{2}, gof(2)] = fit( xData, yData, ft, opts );

% Plot fit with data.
%figure( 'Name', 'Hidrogeno 2' );
h = plot( fitresult{2}, xData, yData );
legend( h, 'peak_zone_y2 vs. peak_zone_x2', 'Hidrogeno 2', 'Location', 'NorthEast' );
% Label axes
xlabel peak_zone_x2
ylabel peak_zone_y2
grid on

%% Fit: 'Hidrogeno 3'.
[xData, yData] = prepareCurveData( peak_zone_x3, peak_zone_y3 );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [234.979 6087.0069 10.5399990567281 81.7902801386591 6061.0495 27.6762162338584];

% Fit model to data.
[fitresult{3}, gof(3)] = fit( xData, yData, ft, opts );

% Plot fit with data.
%figure( 'Name', 'Hidrogeno 3' );
h = plot( fitresult{3}, xData, yData );
legend( h, 'peak_zone_y3 vs. peak_zone_x3', 'Hidrogeno 3', 'Location', 'NorthEast' );
% Label axes
xlabel peak_zone_x3
ylabel peak_zone_y3
grid on


