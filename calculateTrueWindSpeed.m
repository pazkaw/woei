function ctws = calculateTrueWindSpeed(caws, cspeed, cawa, ccourse)
% https://en.wikipedia.org/wiki/Apparent_wind#Calculating_apparent_velocity_and_angle
% https://www.starpath.com/freeware/truewind.pdf, p. 11
%% Taking the intersect of all timeseries data to synchronise data series
% caws
[sharedVals,idxsIntoCaws] = intersect(caws.time,intersect(cspeed.time,intersect(ccourse.time,cawa.time)));

% cspeed
[sharedVals,idxsIntoCspeed] = intersect(cspeed.time,intersect(caws.time,intersect(ccourse.time,cawa.time)));

% cawa
[sharedVals,idxsIntoCawa] = intersect(cawa.time,intersect(cspeed.time, intersect(ccourse.time,caws.time)));

% ccourse
[sharedVals,idxsIntoCcourse] = intersect(ccourse.time,intersect(cspeed.time, intersect(cawa.time,caws.time)));


%% Extract common data series
AWS = caws.data(idxsIntoCaws);
STW = cspeed.data(idxsIntoCspeed);  % Speed through water
AWA = cawa.data(idxsIntoCawa);
H = ccourse.data(idxsIntoCcourse);
ts = datestr(datetime(caws.TimeInfo.StartDate)+days(caws.time),'yyyy-mm-dd HH:MM:SS.FFF');
ts = ts(idxsIntoCaws,:);
Lwy = 0;                    % Leeway ("drift")

%% Calculate true wind speed
TWS_sensor = sqrt((AWS.*sind(AWA)+tand(Lwy).*STW).^2 + ...
                    (AWS.*cosd(AWA)-STW).^2);
TWS_actual = TWS_sensor.*(1/(0.9+0.01*H));

ctws = timeseries(TWS_actual,ts);


