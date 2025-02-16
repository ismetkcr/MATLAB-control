clear all;
clc;


tspan = [0:1:25000];
x0 = [10 10 10];



[t,X] = ode45(@ostim_proses,tspan,x0);
T1 = X(:,1);
T2 = X(:,2);
Th = X(:,3);
%t = t/3600;
figure(1)
plot(t,T1,'LineWidth',2);
hold on
plot(t,T2,'LineWidth',2);
xlabel('time-hour')
ylabel('T,C')
title('Tank1-Tank2')
legend('T1','T2')


figure(2)
plot(t,Th,'LineWidth',2);
hold on
title('Rezervuar')
xlabel('time-hour')
ylabel('T,C')


