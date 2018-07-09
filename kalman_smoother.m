function [xsmooth, Vsmooth, VVsmooth, loglik] = kalman_smoother(y, A, C, Q, R, init_x, init_V)
% Kalman smoother.
% [xsmooth, Vsmooth, VVsmooth, loglik] = kalman_smoother(y, A, C, Q, R, init_x, init_V)
%
% We compute the smoothed state estimates based on all the observations, Y_1, ..., Y_T:
%   xsmooth(:,t)    = E[x(t) | T]
%   Vsmooth(:,:,t)  = Cov[x(t) | T]
%   VVsmooth(:,:,t) = Cov[x(t), x(t-1) | T] for t>=2

[os T] = size(y);
ss = length(A);

xsmooth = zeros(ss, T);
Vsmooth = zeros(ss, ss, T);
VVsmooth = zeros(ss, ss, T);

% Forward pass
[xfilt, Vfilt, VVfilt, loglik] = kalman_filter(y, A, C, Q, R, init_x, init_V);

% Backward pass
xsmooth(:,T) = xfilt(:,T);
Vsmooth(:,:,T) = Vfilt(:,:,T);
%VVsmooth(:,:,T) = VVfilt(:,:,T);

for t=T-1:-1:1
  [xsmooth(:,t), Vsmooth(:,:,t), VVsmooth(:,:,t+1)] = ...
      smooth_update(xsmooth(:,t+1), Vsmooth(:,:,t+1), xfilt(:,t), Vfilt(:,:,t), ...
      Vfilt(:,:,t+1), VVfilt(:,:,t+1), A, Q);
end

VVsmooth(:,:,1) = zeros(ss,ss);

