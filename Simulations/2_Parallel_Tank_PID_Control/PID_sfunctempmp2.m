function [sys, x0, str, ts] = PID_sfunctempmp2(t,x,u,flag,KC,TI,TD)


switch flag

    case 0 % initialization stage
        [sys, x0, str, ts] = Initialization;

    case 2 % State calculation stage
        sys = UpdatesCalculation(t,x,u,KC,TI,TD);
    case 3 % Output calculation stage
        sys = OutputCalculation(t,x,u);
    case {1,4,9} %unsed stages
        sys = [];

    otherwise
        error(['Unhandled flag = ' ,num2str(flag)]);
end

%Initialization function
function [sys, x0, str, ts] = Initialization

D = 0;
if D == 0
    dirF = 0;
else
    dirF = 1;
end

sizes = simsizes; %simsizes type structure
sizes.NumContStates = 0; %cont states number
sizes.NumDiscStates = 3; %disc states number
sizes.NumOutputs = 1; %outputs number
sizes.NumInputs = 1;
sizes.DirFeedthrough = dirF;
sizes.NumSampleTimes = 1; %sampling instants number
sys = simsizes(sizes);

x0 = [ 0 0 0];
str = [];
ts = [-1 0]; %disc process


%State calculation function
function sys = UpdatesCalculation(t,x,u,KC,TI,TD)
deltat = 1;

error_n  = u(1);
error_n_1 = x(2);
s_n_1 = x(3);

s_n = (s_n_1)+((KC/TI)*error_n*deltat);
cikis_n = (KC*error_n) + s_n +(KC*TD*(error_n - error_n_1))/deltat;




if ((cikis_n<1.61) &&(cikis_n>0)) 
     state(3) = s_n;
 elseif cikis_n>=1.61
     cikis_n = 1.61;
     state(3) = s_n_1;
 elseif cikis_n<=0
     cikis_n = 0;
     state(3) = s_n_1;
 end


state(1) = cikis_n;
state(2) = error_n;


sys = state;



%Output calculation function
function sys = OutputCalculation(t,x,u)

output(1) = x(1) ;



sys = output;




