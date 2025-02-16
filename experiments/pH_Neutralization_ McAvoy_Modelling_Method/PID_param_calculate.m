k =0.004; tau = 1e-5; theta = 0.05;
KU = 7000; %set7;
PU = 23.33;
Ho = 12;
To = 38;
delta_PV = 11;
delta_u = 1/60;
a = 8.5;
L = 150;


%Ziegler-Nicholas Closed Loop

KC_ZN_CL = KU/1.7;
TI_ZN_CL = PU/2;
TD_ZN_CL = PU/8;

%Ziegler-Nicholas Open Loop
KC_ZN_OP = 1.2*a;
TI_ZN_OP = 2*L;
TD_ZN_OP = L/2;



%Tyreus Luyben Closed Loop

KC_TL = KU/2.2;
TI_TL = PU*2.2;
TD_TL = PU/6.3;




%IMC Open Loop
lambda = 0.30*theta;
KC_IMC = (2*tau + theta)/(2*(lambda + theta))/k;
TI_IMC = tau + theta/2;
TD_IMC = tau*theta/(2*tau+theta);

%ITAE-setpoint Open Loop

KC_ITAE_set = 0.965*((theta/tau)^-0.850)/k;
B = 0.796 - 0.1465*(theta/tau);
TI_ITAE_set = tau/B;
C = 0.308*(theta/tau)^0.929;
TD_ITAE_set = C*tau;

%ITAE-disturbance Open Loop

KC_ITAE_dist = (1.357*(theta/tau)^-0.947)/k;
Bd = 0.842*(theta/tau)^-0.738;
TI_ITAE_dist = tau/Bd;
Cd = 0.381*(theta/tau)^0.996;
TD_ITAE_dist = Cd*tau;

%Cohen-Coon Open Loop

AC = tau/(k*theta);
BC = (16 + (3*theta/tau))/12;
KC_CC = AC*BC;
CC = theta*(32 + (6*theta/tau));
DC = 13 + (8*theta/tau);
TI_CC = CC/DC;
EC = 4*theta;
FC = 11 + (2*theta)/tau;
TD_CC = EC/FC;

%MARLİN Open Loop

KC_MAR = 0.65/k;
TI_MAR = 0.65*tau;
TD_MAR = 0.1*tau;

%Ciancone Open Loop

KC_Cian = 1.2/k;
TI_Cian = 0.69*(theta+tau);
TD_Cian = 0.05*(theta+tau);

%Atkinson CLosed Loop

KC_Atkin = KU*2;
TI_Atkin = PU;
TD_Atkin = PU/5;


%Shinskey Closed Loop

KC_Shin = KU*2;
TI_Shin = 0.34*PU;
TD_Shin = 0.08*PU;

%bang-bang oscillation test CLosed Loop
KC_Bang = 2*Ho;
TI_Bang = To;
TD_Bang = To/4;

%Process Reaction Curve Open Loop

Kp = delta_PV/delta_u;
KC_PRC = 80*Kp*theta/tau;
TI_PRC = 2.5*theta;
TD_PRC = 0.4*theta;






fprintf('KC_ZN_CL = %4.2f, TI_ZN_CL = %4.2f TD_ZN_CL = %4.2f hesaplandi\n', KC_ZN_CL,TI_ZN_CL,TD_ZN_CL);
fprintf('KC_ZN_OP = %4.2f, TI_ZN_OP = %4.2f, TD_ZN_OP = %4.2f hesaplandi\n', KC_ZN_OP,TI_ZN_OP,TD_ZN_OP);
fprintf('KC_Tyreus_Luben = %4.2f, TI_Tyreus-Luyben = %4.2f, TD_Tyreus_Luyben = %4.2f hesaplandi\n', KC_TL,TI_TL,TD_TL);
fprintf('KC_IMC = %4.2f , TI_IMC = %4.2f, TD_IMC = %4.2f hesaplandi\n',KC_IMC,TI_IMC,TD_IMC);
fprintf('KC_ITAE_Setpoint = %4.2f, TI_ITAE_Setpoint = %4.2f, TD_ITAE_Setpoint = %4.2f hesaplandi\n', KC_ITAE_set, TI_ITAE_set, TD_ITAE_set);
fprintf('KC_ITAE_Disturbance = %4.2f, TI_ITAE_Disturbance = %4.2f, TD_ITAE_Disturbance = %4.2f hesaplandi\n', KC_ITAE_dist,TI_ITAE_dist,TD_ITAE_dist);
fprintf('KC_Cohen-Coon = %4.2f, TI_Cohen-Coon = %4.2f TD_Cohen-Coon = %4.2f hesaplandi\n', KC_CC,TI_CC,TD_CC);
fprintf('KC_Marlin = %4.2f, TI_Marlin = %4.2f TD_Marlin = %4.2f hesaplandi\n',KC_MAR,TI_MAR,TD_MAR);
fprintf('KC_Cian = %4.2f, TI_Cian = %4.2f TD_Cian = %4.2f hesaplandi\n', KC_Cian,TI_Cian,TD_Cian);
fprintf('KC_Atkinson = %4.2f, TI_Atkinson = %4.2f, TD_Atkinson = %4.2f hesaplandi\n', KC_Atkin, TI_Atkin, TD_Atkin);
fprintf('KC_Shinskey = %4.2f, TI_Shinskey = %4.2f, TD_Shinskey = %4.2f hesaplandi\n', KC_Shin,TI_Shin,TD_Shin);
fprintf('KC_Bang = %4.2f, TI_Bang = %4.2f, TD_Bang = %4.2f hesaplandi \n', KC_Bang, TI_Bang, TD_Bang);
fprintf('KC_PRC = %4.2f, TI_PRC = %4.2f, TD_PRC = %4.2f hesaplandi \n', KC_PRC,TI_PRC,TD_PRC);


















