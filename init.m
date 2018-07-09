x0 = 0.0; v0 = 0.0;
TMAX = 200;
g=9.8;
m=1.0; k=10.0;
dt=0.01;
clear s % Dynamics modeled by A
s.A = [[1      dt       ]; ... 
[0 (1.0-(k/m)*dt)]];

% Measurement noise variance
MNstd = 0.4;
MNV = MNstd*MNstd;
% Process noise variance
PNstd = 0.02;
PNV = PNstd*PNstd;
% Process noise covariance matrix
s.Q = eye(2)*PNV;
% Define measurement function 
to return the state
s.H = eye(2);
% Define a measurement error
s.R = eye(2)*MNV; % variance

% Use control to include gravity
s.B = eye(2); % Control matrix
s.u = [0 -g*m*dt]'; 
% Gravitational acceleration
% Initial state:
s.x = [x0 v0]';
s.P = eye(2)*MNV;
s.detP = det(s.P); % Let's keep 
track of the noise by 
keeping detP
s.z = zeros(2,1);

% Simulate falling in air, a
nd watch the filter track it
tru=zeros(TMAX,2); % true dynamics
tru(1,:)=[x0 v0];
detP(1,:)=s.detP;
for t=2:TMAX
tru(t,:)=s(t-1).A*tru(t-1,:)'+ s(t-1).B*s(t-1).u+PNstd *randn(2,1);
s(t-1).z = s(t-1).H * tru(t,:)' + MNstd*randn(2,1); % create a meas.
s(t)=kalmanf(s(t-1)); % perform a Kalman filter iteration
detP(t)=s(t).detP; % keep track of "net" uncertainty
end
