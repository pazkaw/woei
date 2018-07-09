%% BBQ algorithm
% Alpha: Vertical axis sensitivity (absolute difference in y-value)
% Tau: Horizontal (time) sensitivity (search area around current time step)
function [peaks, troughs] = letsbbq(timeseries, alpha, tau, nDivisions)
    diffm = [];
    diffp = [];
    peaks = ones(size(timeseries)); 
    troughs = ones(size(timeseries));
    
    nDivisions = nDivisions+1;
    divisions = linspace(1,tau,nDivisions);
    
    for currenttau = divisions
        rtau = round(currenttau);
        curdiffm = [(timeseries(1:end-rtau)-timeseries(rtau+1:end)); NaN(rtau,1)];
        diffm = [diffm, curdiffm];
        peaks = peaks.*(curdiffm < -alpha);
        troughs = troughs.*(curdiffm > alpha);
        
        curdiffp = [NaN(rtau,1); (timeseries(rtau+1:end)-timeseries(1:end-rtau))];
        diffp = [diffp, curdiffp];
        peaks = peaks.*(curdiffp < -alpha);
        troughs = troughs.*(curdiffp > alpha);
    end
    
end
