function [x, V, VV, loglik] = kalman_filter(y, A, C, Q, R, init_x, init_V, model)
% Kalman filter.
% [x, V, VV, loglik] = kalman_filter(y, A, C, Q, R, init_x, init_V, model)
%
% Inputs:
% y(:,t)   - the observation at time t
% A(:,:,m) - the system matrix for model m
% C(:,:,m) - the observation matrix for model m
% Q(:,:,m) - the system covariance for model m
% R(:,:,m) - the observation covariance for model m
% init_x(:,m) - the initial state for model m
% init_V(:,:,m) - the initial covariance for model m
% model(t) - which model to use at time t (defaults to model 1 if not specified)
%
% Outputs:
% x(:,t) = E[X_t | t]
% V(:,:,t) = Cov[X_t | t]
% VV(:,:,t) = Cov[X_t, X_t-1 | t] t >= 2
% loglik = sum_t log P(Y_t)

[os T] = size(y);
ss = size(A,1);

if nargin<8, model = ones(1, T); end

x = zeros(ss, T);
V = zeros(ss, ss, T);
VV = zeros(ss, ss, T);

loglik = 0;
for t=1:T
  m = model(t);
  if t==1
    prevx = init_x(:,m);
    prevV = init_V(:,:,m);
    initial = 1;
  else
    prevx = x(:,t-1);
    prevV = V(:,:,t-1);
    initial = 0;
  end
  [x(:,t), V(:,:,t), LL, VV(:,:,t)] = ...
      kalman_update(A(:,:,m), C(:,:,m), Q(:,:,m), R(:,:,m), y(:,t), prevx, prevV, initial);
  loglik = loglik + LL;
end





