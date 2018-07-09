% falling.m
x0 = 0.0;
v0 = 0.0;
TMAX = 200;
x = zeros(1,TMAX);
V = zeros(1,TMAX);
g=9.8;
m=1.0;
k=10.0;
x(1) = x0;
v(1) = v0;
dt=0.01;
for t=2:TMAX,
    x(t) = x(t-1)+(v(t-1))*dt;
    v(t) = v(t-1)+(-(k/m)*(v(t-1))-g)*dt;
end
figure();
plot(x,'b'); hold on;
title(['Falling object k/m = ' num2str(k/m)]);
plot(v,'r')
legend('x','v'); hold off