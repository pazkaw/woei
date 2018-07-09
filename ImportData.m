%% Importdata
% Output:
% - cdate, cspeed, cawa, etc: Resulting time series with associated time stamp
% - mawsvals, mknotsvals, mawavals: Moving average (no. of lags defined by T) of original time series 

function [cdate, cspeed, cawa, craw_aws, caws, cknots, clat, clong, ccourse, cmaws, cmawa, cmknots, ts] = ImportData(filename, T)
%% Import raw data
RawData = importfile(filename);
n = length(RawData);
fknots = @(xaws) 1.8532+0.0357.*xaws;

%% Initialise variables
speed = [];
lat = [];
long = [];
course = [];
ts = [];
awa = [];
raw_aws = [];
knots = [];
time_reference = datenum('1970', 'yyyy'); 
lcourseval = 180;
lawaval = 180;
lawsval = 200;
lknotsval = -50+28*lawsval;
mawsvals = [];
mknotsvals = [];
mawavals = [];

%% Start data processing (line by line readings)
for i = 1:n
    currentline = char(RawData{i});
    
    %% Time stamps
    try
        matchWord = 'ts';
        [a,b]  = regexp(currentline,'\d+(\.\d+)?');
        strPos = find(a > strfind(currentline,matchWord),1,'first');
        nValue = str2double(currentline(a(strPos):b(strPos)));
        time_matlab = time_reference + nValue / 8.64e7;
        nValue = datestr(time_matlab, 'yyyy-mm-dd HH:MM:SS.FFF');
        if(~isnan(nValue))
            ts = [ts; nValue];
        else
            continue;
        end
    catch
        continue;
    end
    
    %% Speed readings (m/s)
    try
        matchWord = 'speed';
        [a,b]  = regexp(currentline,'\d+(\.\d+)?');
        strPos = find(a > strfind(currentline,matchWord),1,'first');
        nValue = str2double(currentline(a(strPos):b(strPos)));
        speed = [speed; nValue];
    catch
        speed = [speed; NaN];
    end
    
    %% Latitude
    try
        matchWord = 'lat';
        [a,b]  = regexp(currentline,'\d+(\.\d+)?');
        strPos = find(a > strfind(currentline,matchWord),1,'first');
        nValue = str2double(currentline(a(strPos):b(strPos)));
        lat = [lat; nValue];
    catch
        lat = [lat; NaN];
    end

    %% Longitude
    try
        matchWord = 'long';
        [a,b]  = regexp(currentline,'\d+(\.\d+)?');
        strPos = find(a > strfind(currentline,matchWord),1,'first');
        nValue = str2double(currentline(a(strPos):b(strPos)));
        long = [long; nValue];
    catch
        long = [long; NaN];
    end

    %% Course
    try
        matchWord = 'course';
        [a,b]  = regexp(currentline,'\d+(\.\d+)?');
        strPos = find(a > strfind(currentline,matchWord),1,'first');
        nValue = str2double(currentline(a(strPos):b(strPos)));
        if(lcourseval>300 && nValue < 60)
            nValue = nValue+360;
        elseif(nValue > 300 && lcourseval < 60)
            nValue = nValue-360;
        end
        course = [course; nValue];
        if(~isnan(nValue))
            lcourseval = nValue;
        end
    catch
        course = [course; NaN];
    end

    %% Apparent wind angle
    try
        matchWord = 'awa';
        [a,b]  = regexp(currentline,'\d+(\.\d+)?');
        strPos = find(a > strfind(currentline,matchWord),1,'first');
        nValue = str2double(currentline(a(strPos):b(strPos)));
        nValue = mod(nValue / 4096*360-130,360);
        
%         if(lawaval(end) >300 && nValue < 60)
%             nValue = nValue+360;
%         elseif(nValue > 300 && lawaval(end) < 60)
%             nValue = nValue-360;
%         end
        
        awa = [awa; nValue];
        if(~isnan(nValue))
            if(length(lawaval)>T)
                mawa = mean(lawaval(end-T+1:end));
                mawavals = [mawavals; mawa];
            end
            lawaval = [lawaval; nValue];
        end
    catch
        awa = [awa; NaN];
    end

    %% Apparent wind speed
    try
        matchWord = 'aws';
        [a,b]  = regexp(currentline,'\d+(\.\d+)?');
        strPos = find(a > strfind(currentline,matchWord),1,'first');
        nValue = str2double(currentline(a(strPos):b(strPos)));
        raw_aws   = [raw_aws; nValue];
        knots = [knots; fknots(nValue)];
        if(~isnan(nValue))
            if(length(lawsval)>T)
                maws = mean(lawsval(end-T+1:end));
                mknots = mean(lknotsval(end-T+1:end));
                mawsvals = [mawsvals; maws];
                mknotsvals = [mknotsvals; mknots];
            end
            lawsval = [lawsval; nValue];
            lknotsval = [lknotsval; fknots(nValue)];
        end
    catch
        raw_aws = [raw_aws; NaN];
        knots = [knots; NaN];
    end
end

%% Construct time series
cdate = datestr(ts,'dd-mm-yyyy HH:MM:SS');
cspeed = timeseries(speed(~isnan(speed)),ts(~isnan(speed),:));
cspeed.name = 'speed (m/s)';
cawa = timeseries(awa(~isnan(awa)),ts(~isnan(awa),:));
cawa.name = 'apparent wind angle';
craw_aws = timeseries(raw_aws(~isnan(raw_aws)),ts(~isnan(raw_aws),:));
craw_aws.name = 'apparent wind speed (raw readings)';
cknots = timeseries(knots(~isnan(knots)),ts(~isnan(knots),:));
cknots.name = 'apparent wind speed (knots)';
caws = timeseries(knots(~isnan(knots)).*463/900,ts(~isnan(knots),:)); % Conversion factor knots to m/s
caws.name = 'apparent wind speed (m/s)';
clat = timeseries(lat(~isnan(lat)),ts(~isnan(lat),:));
clat.name = 'latitude';
clong = timeseries(long(~isnan(long)),ts(~isnan(long),:));
clong.name = 'longitude';
ccourse = timeseries(course(~isnan(course)),ts(~isnan(course),:));
ccourse.name = 'course';

mawsts = ts(~isnan(raw_aws),:);
mawsts = mawsts(T+1:end,:);
cmaws = timeseries(mawsvals, mawsts);

mawats = ts(~isnan(awa),:);
mawats = mawats(T+1:end,:);
cmawa = timeseries(mawavals, mawats);

mknotsts = ts(~isnan(knots),:);
mknotsts = mknotsts(T+1:end,:);
cmknots = timeseries(mknotsvals, mknotsts);


