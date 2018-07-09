function [xnew, Vnew, loglik, VVnew] = kalman_update(F, H, Q, R, y, x, V, initial)
% KALMAN_UPDATE Do a one step update of the Kalman filter
% [xnew, Vnew, loglik] = kalman_update(F, H, Q, R, y, x, V, initial)
%
% Given
%  x(:) =   E[ X | Y(1:t-1) ] and
%  V(:,:) = Var[ X(t-1) | Y(1:t-1) ],
% compute 
%  xnew(:) =   E[ X | Y(1:t-1) ] and
%  Vnew(:,:) = Var[ X(t) | Y(1:t) ],
%  VVnew(:,:) = Cov[ X(t), X(t-1) | Y(1:t) ],
% using
%  y(:)   - the observation at time t
%  A(:,:) - the system matrix
%  C(:,:) - the observation matrix
%  Q(:,:) - the system covariance
%  R(:,:) - the observation covariance
%
% If initial=true, x and V are taken as the initial conditions (and F and Q are ignored).
% If there is no observation vector, set K = zeros(ss).

if nargin < 8, initial = 0; end

if initial
  xpred = x;
  Vpred = V;
else
  xpred = F*x;
  Vpred = F*V*F' + Q;
end
e = y - H*xpred; % error (innovation)
n = length(e);
ss = length(F);
S = H*Vpred*H' + R;
Sinv = inv(S);
ss = length(V);
loglik = gaussian_prob(e, zeros(1,length(e)), S, 1);
K = Vpred*H'*Sinv; % Kalman gain matrix
xnew = xpred + K*e;
Vnew = (eye(ss) - K*H)*Vpred;
VVnew = (eye(ss) - K*H)*F*V;

