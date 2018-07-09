file = 'Data2/3FA0741F-E9DA-416B-8931-5746A76D95D5.txt';
%file = 'Data2/2F8322ED-AF25-4EDC-9570-A9D9F3753FA4.txt';
%file = 'Data2/CAE3A8DC-EC38-4A75-B779-9C5BC03E7497.txt';
reload = false;
plotrawseries = true;
calculateBearing = false;
calculateGreeks = true;
braaien = false;
T = 10;
alpha = 1e-8; tau = 3;

%% Read data
if(reload)
    [cdate, cspeed, cawa, craw_aws, caws, cknots, clat, clong, ccourse,  cmaws, cmawa, cmknots, ts] = ImportData(file, T);
end
if(plotrawseries)
    figure;
    subplot(2,3,1);
    plot(clong);
    subplot(2,3,2);
    plot(clat);
    subplot(2,3,3);
    plot(ccourse);
    subplot(2,3,4);
    plot(cspeed);
    subplot(2,3,5);
    plot(cawa);
    subplot(2,3,6);
    plot(caws);
    %plot(cknots);
    
%     figure;
%     plot(mawsvals); 
%     figure;
%     plot(mknotsvals);
%     figure;
%     plot(cmawa); 
end

if(calculateBearing)
    bearing = [];
    for i = 2:length(clat.data)
        direction = getDirection(clat.data(i-1),clong.data(i-1),clat.data(i),clong.data(i));
        bearing = [bearing; direction];
    end
end

if(calculateGreeks)
    ctws = calculateTrueWindSpeed(caws, cspeed, cawa, ccourse);
    ctwa = calculateTrueWindAngle(caws, cspeed, cawa);
    cawd = calculateApparentWindDirection(ccourse, cawa);
    [ctws2, ctwd] = calculateTrueWindDirection(cawd, caws, ccourse, cspeed);
    [ctws3, ctwd2] = calculateTrueWindDirection2(cawa, caws, ccourse, cspeed);

    [ctws3,ctwa3,ctwd3] = calculateProperties(caws, cspeed, cawa, ccourse);
    
    
    figure;
    hold on;
    plot(ctws);
    plot(ctws2);
    plot(caws);
    
    figure;
    hold on;
    plot(ctwa);
    plot(cawa);   
    
    figure;
    hold on;
    plot(ctwd);
    plot(cawd);
end


% https://en.wikipedia.org/wiki/Apparent_wind#Calculating_apparent_velocity_and_angle
% https://en.wikipedia.org/wiki/High-performance_sailing
% https://support.garmin.com/faqSearch/en-US/faq/content/lQFTLBSlv73TYGsOpDB7P6
% Kalman filter
% 
%peaks = clat.data(1:end-1).*(1-clat.data(2:end));
%troughs = (1-clat.data(1:end-1)).*clat.data(2:end);

if(braaien)
    %% Plot latitude
    figure;
    alpha = 0; tau = 10; nDivisions = 5;
    [longPeaks, longTroughs] = letsbbq(clat.data, alpha, tau,nDivisions);

    subplot(3,1,1);
    %plot(clat);
    plot(clat.data);
    hold on;
    %plot(timeseries(nonzeros(troughs.*level), ts(find(troughs),:)),'o');
    plot(find(longTroughs), nonzeros(longTroughs.*clat.data),'o');

    hold on;
    %plot(timeseries(nonzeros(peaks.*level), ts(find(peaks),:)),'o');
    plot(find(longPeaks), nonzeros(longPeaks.*clat.data),'o');

    %% Plot longitude
    [longPeaks, longTroughs] = letsbbq(clong.data, alpha, tau, 1);
    subplot(3,1,2);
    plot(clong.data);
    hold on;
    %plot(timeseries(nonzeros(troughs.*level), ts(find(troughs),:)),'o');
    plot(find(longTroughs), nonzeros(longTroughs.*clong.data),'o');

    hold on;
    %plot(timeseries(nonzeros(peaks.*level), ts(find(peaks),:)),'o');
    plot(find(longPeaks), nonzeros(longPeaks.*clong.data),'o');

    %% Plot wind angle
    subplot(3,1,3);
    alpha = 0.1; tau = 10; nDivisions = 5;
    [awaPeaks, awaTroughs] = letsbbq(cmawa.data, alpha, tau,nDivisions);

    subplot(3,1,3);
    %plot(clat);
    plot(cmawa.data);
    hold on;
    %plot(timeseries(nonzeros(troughs.*level), ts(find(troughs),:)),'o');
    plot(find(awaTroughs), nonzeros(awaTroughs.*cmawa.data),'o');

    hold on;
    %plot(timeseries(nonzeros(peaks.*level), ts(find(peaks),:)),'o');
    plot(find(awaPeaks), nonzeros(awaPeaks.*cmawa.data),'o');
end


