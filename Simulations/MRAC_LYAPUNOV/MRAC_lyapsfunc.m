function [sys, x0, str, ts] = MRAC_lyapsfunc(t,x,u,flag,gamma,am)


switch flag

    case 0 % initialization stage
        [sys, x0, str, ts] = Initialization;

    case 2 % State calculation stage
        sys = UpdatesCalculation(t,x,u,gamma,am);
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
sizes.NumDiscStates = length(A); %disc states number
sizes.NumOutputs = 1; %outputs number
sizes.NumInputs = 1;
sizes.DirFeedthrough = dirF;
sizes.NumSampleTimes = 1; %sampling instants number
sys = simsizes(sizes);

x0 = [K10 K20]
str = [];
ts = [Te 0]; %disc process


%State calculation function
function sys = UpdatesCalculation(x,u,A,B)
sys = A*x + B*u;

%Output calculation function
function sys = OutputCalculation(x,u,C,D)

if D == 0
sys = C*x;
else
    sys = C*x + D*u;
end




deltat = 1;

ym_k = u(1);
y_k = u(2);
u_c = u(3);
gamma1 = u(4);
gamma2 = u(5);

K1_k_1 = x(1);
K2_k_1 = x(2);
u_k_1 = x(3);

err = (y_k - ym_k);
K1 = K1_k_1 + deltat*(-gamma1*u_c*err);
K2 = K2_k_1 + deltat*(gamma2*y_k*err);

u_k = K1*u_c - K2*y_k;

if u_k>50
    u_k = 50;
elseif u_k<0
    u_k = 0;
end


state(1) = K1;
state(2) = K2;
state(3) = u_k;


sys = [state];




% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
output(1) = x(1);
output(2) = x(2);
output(3) = x(3);


sys = output;

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
