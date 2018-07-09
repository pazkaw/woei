function [xsmooth, Vsmooth, VVsmooth_future] = smooth_update(xsmooth_future, Vsmooth_future, ...
    xfilt, Vfilt,  Vfilt_future, VVfilt_future, F, Q)
% One step of the backwards RTS smoothing equations.
% [xnew, Vnew, VVnew] = smooth_update(xsmooth, Vsmooth, xfilt, Vfilt, VVfil, F, Q)
%
% Inputs:
% xsmooth_future = E[X_t+1|T]
% Vsmooth_future = Cov[X_t+1|T]
% xfilt = E[X_t|t]
% Vfilt = Cov[X_t|t]
% Vfilt_future = Cov[X_t+1|t+1]
% VVfilt_future = Cov[X_t+1,X_t|t+1]
% F = F(:,:,t+1)
% Q = Q(:,:,t+1)
%
% Outputs:
% xsmooth = E[X_t|T]
% Vsmooth = Cov[X_t|T]
% VVsmooth_future = Cov[X_t+1,X_t|T]
%
% xpred = E[X_t+1 | t]
% Vpred = Cov[X_t+1 | t]

xpred = F*xfilt;
Vpred = F*Vfilt*F' + Q;
J = Vfilt * F' * inv(Vpred); % smoother gain matrix
xsmooth = xfilt + J*(xsmooth_future - xpred);
Vsmooth = Vfilt + J*(Vsmooth_future - Vpred)*J';
VVsmooth_future = VVfilt_future + (Vsmooth_future - Vfilt_future)*inv(Vfilt_future)*VVfilt_future;


