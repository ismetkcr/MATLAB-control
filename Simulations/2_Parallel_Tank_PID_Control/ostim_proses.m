function [dXdt] = ostim_proses(t,x)
%persistent Tc1_mat tc1 matris olarak kaydetmek istenirse
%OSTIM_PROSES 
%   2 tank proses diferansiyel denklemleri içerir..
%x(1) = T1; x(2) = T2; x(3) = Th;
T_amb = 10; %C
mh = 3.61; %kg/s
% tank1 enerji denkliği ile elde edilen dt1/dt denklemi için hesaplar
r_tank1 = 0.55; %m
h_tank1 = 0.99+(0.17/2); %m
AT1_surf = 2*pi*r_tank1*h_tank1; %m^2
UT1 = 100; %(J/s*m^2*K)
cp_fluid = 4.18*1000; %(J/kg*K);
cp_tank = cp_fluid; %tank1,2 ile soğutma sıvısı aynı kabulü ile
mp1 = 2; %kg/s;
m_tank1 = 1000; %kg;
Tc1 = x(1) - ((x(1)-x(3))*exp((-UT1*AT1_surf)/(mp1*cp_fluid)));
%Tc1_mat = [Tc1_mat Tc1]; tc1 matris olarak kaydetmek istenirse
assignin("base","Tc1",Tc1) %tc1 matris olarak kaydetmek istenirse
dXdt(1,1) = (mp1*cp_fluid)/(cp_tank*m_tank1)*(x(3)-Tc1) - (UT1*AT1_surf*(x(1)-T_amb))/(m_tank1*cp_tank);
% tank 2 enerji denkliği ile elde edilen dt2/dt denklemi için hesaplar..
r_tank2 = 0.47; %m
h_tank2 = 0.7; %m
AT2_surf = 2*pi*r_tank2*h_tank2; %m^2
UT2 = 200; %(J/s*m^2*K)
mp2 = mh-mp1; %kg/s
m_tank2 = 468; %kg;
Tc2 = x(2) - ((x(2)-x(3))*exp((-UT2*AT2_surf)/(mp2*cp_fluid)));
assignin('base',"Tc2",Tc2)
dXdt(2,1) = (mp2*cp_fluid)/(cp_tank*m_tank2)*(x(3)-Tc2) - (UT2*AT2_surf*(x(2)-T_amb))/(m_tank2*cp_tank);
% reservuar enerji denkliği ile elde edilen dth/dt denklemi için hesaplar..

Q = 10000; %J/s
assignin('base',"Q",Q)
URes = 10; %(J/s*m^2*K)
A_res = 0.1; %m^2 bu değer seçildi.. Sorulabilir
V1 = Q/(mh*cp_fluid);
V2 = -(URes*A_res)/(mh*cp_fluid);
V3 = -(UT1*AT1_surf)/(mh*cp_fluid);
V4 = -(UT2*AT2_surf)/(mh*cp_fluid);
dXdt(3,1) = V1 + V2*(x(3)-T_amb) + V3*(x(3)-x(1)) + V4*(x(3)-x(2));



end

