% falling_matrix.m: model of object 
falling in air, w/ matrix notation
x0 = 0.0; v0 = 0.0;
TMAX = 200;
x = zeros(2,TMAX);
g=9.8;
m=1.0;
k=10.0;
x(1,1) = x0; x(2,1) = v0;
dt=0.01;
u=[0 1]';
for t=2:TMAX,
A=[[1      dt        ]; ... 
[0 (1.0-(k/m)*dt) ]];
B=[[1    0   ]; ... 
[0  -g*dt ]];
x(:,t) = A*x(:,t-1) + B*u;    
end
% plotting