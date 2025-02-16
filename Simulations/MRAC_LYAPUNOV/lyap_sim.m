clear all; clc;

%reference model parameters
am = [2];
bm = [1];


%plant parameters
a = [2];
b = [5];


%reference model

Wm = tf([bm],[am 1]);



tmax = input('tmax giriniz :');
time = 0:0.1:tmax;
t = 0:0.1:tmax;
%step input olustur
ts = input('step input baslangıc süresi giriniz :');
buyukstep = input('input step input büyüklük giriniz :');

urs = buyukstep*heaviside(time-ts) ;

% %square input olustur
% 
% 
% aralik = input('squaresignal aralik giriniz :');
% pulsew = input('pulsew giriniz(araliktan büyük bir deger olmamalı!) :');
% 
% buyukluk = input('buyukluk giriniz :');
% 
% ab = (aralik+pulsew)/pulsew;
% delayop = pulsew/2:ab*pulsew:tmax;
% 
% ursq=2*buyukluk*pulstran(time,delayop,'rectpuls',pulsew)-buyukluk;
% 
% z = input('programa verilecek sinyali giriniz(1 stepinput, 2 squareinput)');
% if z==1
    ur = urs;
% elseif z==2
%     ur = ursq;
% end

figure(1)
plot(time,ur)
title('Input reference signal')

%output reference  model 

yr = lsim(Wm,ur,time);

figure(2)
plot(time,yr,'b')
title('Rerefence Output')
%plot(time,ur2,'k')

x0 = [0 0 0];
gamma1 = 0.01;
gamma2 = 0.0010;

[time1 values] = ode45(@(t,x) lyapunov_func(t, x, ur, yr, time,a,b,gamma1,gamma2), time, x0);

y = values(:,1);
figure(3)
plot(time,yr,'b','LineWidth',1)
hold on
plot(time,y,'g','LineWidth',1)
legend('yr','y')
xlim([0,tmax])
hold off
