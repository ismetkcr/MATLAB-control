T_amb = 10; %K
mh = 3.61; %kg/s
r_tank1 = 0.55; %m
h_tank1 = 0.99+(0.17/2); %m
AT1_surf = 2*pi*r_tank1*h_tank1; %m^2
UT1 = 100; %(J/s*m^2*K)
cp_fluid = 4.18*1000; %(J/kg*K);
cp_tank = cp_fluid; %tank1 ile soğutma sıvısı aynı kabulü ile
mp1 = 2; %kg/s;
m_tank1 = 1000; %kg;
r_tank2 = 0.47; %m
h_tank2 = 0.7; %m
AT2_surf = 2*pi*r_tank2*h_tank2; %m^2
UT2 = 100; %(J/s*m^2*K)
mp2 = mh-mp1; %kg/s
m_tank2 = 468; %kg/2;
URes = 10; %(J/s*m^2*K)
A_res = 0.1; %m^2 bu değer seçildi.. Sorulabilir
Ths = Th(end);
T1s = T1(end);
T2s = T2(end);
Tc1s = Tc1;
Tc2s = Tc2;



%Parameters For Tank 1 % Bu parametreler simulinke aktarılacak..

K1 = (cp_fluid*(Ths-Tc1s))/(m_tank1*cp_tank);
K2 = (mp1*cp_fluid)/(m_tank1*cp_tank);
K3 = (-UT1*AT1_surf)/(m_tank1*cp_tank);
K4 = -K3;


%Parameters for tank 2..
K5 = (cp_fluid*(Ths-Tc2s))/(m_tank2*cp_tank);
K6 = mp2*cp_fluid/(m_tank2*cp_tank);
K7 = (-UT2*AT2_surf)/(m_tank2*cp_tank);
K8 = -K7;

%Parameters for reservuar..
K9 = 1/(mh*cp_fluid);
K10 = ((-URes*A_res)/(mh*cp_fluid)) + ((-UT1*AT1_surf)/(mh*cp_fluid)) + ((-UT2*AT2_surf)/(mh*cp_fluid));
K11 = (-URes*A_res)/(mh*cp_fluid);
K12 = (-UT1*AT1_surf)/(mh*cp_fluid);
K13 = (-UT2*AT2_surf)/(mh*cp_fluid);










