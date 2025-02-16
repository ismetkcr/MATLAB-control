function [sys,x0,str,ts] = contAPID_RLS_du(t,x,u,flag)
%SFUNTMPL General M-file S-function template
%   With M-file S-functions, you can define you own ordinary differential
%   equations (ODEs), discrete system equations, and/or just about
%   any type of algorithm to be used within a Simulink block diagram.
%
%   The general form of an M-File S-function syntax is:
%       [SYS,X0,STR,TS] = SFUNC(T,X,U,FLAG,P1,...,Pn)
%
%   What is returned by SFUNC at a given point in time, T, depends on the
%   value of the FLAG, the current state vector, X, and the current
%   input vector, U.
%
%   FLAG   RESULT             DESCRIPTION
%   -----  ------             --------------------------------------------
%   0      [SIZES,X0,STR,TS]  Initialization, return system sizes in SYS,
%                             initial state in X0, state ordering strings
%                             in STR, and sample times in TS.
%   1      DX                 Return continuous state derivatives in SYS.
%   2      DS                 Update discrete states SYS = X(n+1)
%   3      Y                  Return outputs in SYS.
%   4      TNEXT              Return next time hit for variable step sample
%                             time in SYS.
%   5                         Reserved for future (root finding).
%   9      []                 Termination, perform any cleanup SYS=[].
%
%
%   The state vectors, X and X0 consists of continuous states followed
%   by discrete states.
%
%   Optional parameters, P1,...,Pn can be provided to the S-function and
%   used during any FLAG operation.
%
%   When SFUNC is called with FLAG = 0, the following information
%   should be returned:
%
%      SYS(1) = Number of continuous states.
%      SYS(2) = Number of discrete states.
%      SYS(3) = Number of outputs.
%      SYS(4) = Number of inputs.
%               Any of the first four elements in SYS can be specified
%               as -1 indicating that they are dynamically sized. The
%               actual length for all other flags will be equal to the
%               length of the input, U.
%      SYS(5) = Reserved for root finding. Must be zero.
%      SYS(6) = Direct feedthrough flag (1=yes, 0=no). The s-function
%               has direct feedthrough if U is used during the FLAG=3
%               call. Setting this to 0 is akin to making a promise that
%               U will not be used during FLAG=3. If you break the promise
%               then unpredictable results will occur.
%      SYS(7) = Number of sample times. This is the number of rows in TS.
%
%
%      X0     = Initial state conditions or [] if no states.
%
%      STR    = State ordering strings which is generally specified as [].
%
%      TS     = An m-by-2 matrix containing the sample time
%               (period, offset) information. Where m = number of sample
%               times. The ordering of the sample times must be:
%
%               TS = [0      0,      : Continuous sample time.
%                     0      1,      : Continuous, but fixed in minor step
%                                      sample time.
%                     PERIOD OFFSET, : Discrete sample time where
%                                      PERIOD > 0 & OFFSET < PERIOD.
%                     -2     0];     : Variable step discrete sample time
%                                      where FLAG=4 is used to get time of
%                                      next hit.
%
%               There can be more than one sample time providing
%               they are ordered such that they are monotonically
%               increasing. Only the needed sample times should be
%               specified in TS. When specifying more than one
%               sample time, you must check for sample hits explicitly by
%               seeing if
%                  abs(round((T-OFFSET)/PERIOD) - (T-OFFSET)/PERIOD)
%               is within a specified tolerance, generally 1e-8. This
%               tolerance is dependent upon your model's sampling times
%               and simulation time.
%
%               You can also specify that the sample time of the S-function
%               is inherited from the driving block. For functions which
%               change during minor steps, this is done by
%               specifying SYS(7) = 1 and TS = [-1 0]. For functions which
%               are held during minor steps, this is done by specifying
%               SYS(7) = 1 and TS = [-1 1].

%   Copyright 1990-2002 The MathWorks, Inc.
%   $Revision: 1.18.2.1 $

%
% The following outlines the general structure of an S-function.
%

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 25;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions

%
x0  = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 ];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [-1 0];

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)
%t present time, x:present time values of states u:present time  input
%x(1) = first state  x(2) = second state x(3) = third state




%this information will be used in the next sampling time 
%in order to calculate next state values, we need to know past values.




sys = [];  %derivatives of states information

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

u_lower=0; u_upper=100; 

mu = u(2);
v = u(3);
deltat = 0.5;


error_n = u(1);
sum_en_n_1 = x(1);
cikis_n_1 = x(2);
en_n_1 = x(3);
en_n_2 = x(4);
en_n_3 = x(5);
epsilon_n_1 = x(6);
epsilon_n_2 = x(7);
theta1_n_1 = x(8);
theta2_n_1 = x(9);
theta3_n_1 = x(10);
theta_n_1 = [theta1_n_1; theta2_n_1; theta3_n_1];
P1_n_1 = x(11);
P2_n_1 = x(12);
P3_n_1 = x(13);
P4_n_1 = x(14);
P5_n_1 = x(15);
P6_n_1 = x(16);
P7_n_1 = x(17);
P8_n_1 = x(18);
P9_n_1 = x(19);
P_n_1 = [P1_n_1 P2_n_1 P3_n_1; P4_n_1 P5_n_1 P6_n_1; P7_n_1 P8_n_1 P9_n_1];
cikis_n_2 = x(20);
cikis_hesap_n_1 = x(21);
en_n_4 = x(22);
en_n_5 = x(23);
cikis_hesap_Fark_n_1 = x(24);
cikis_hesap_Fark_n_2 = x(25);





X = (2*mu/pi) ; Y = pi*v*error_n/(2*mu); en_n = X*atan(Y);

sum_en = sum_en_n_1 + en_n;


if cikis_n_1<u_lower
    epsilon_n = epsilon_n_1 - sign(sum_en)*(u_lower - cikis_n_1);
elseif u_lower<=cikis_n_1 && cikis_n_1<=u_upper
    epsilon_n = epsilon_n_1 + en_n;
elseif cikis_n_1>u_upper
    epsilon_n = epsilon_n_1 - sign(sum_en)*(cikis_n_1 - u_upper);
end


fi_n_11 = en_n_2 - en_n_3;
fi_n_12 = en_n_2;
fi_n_13 = en_n_2 - 2*(en_n_3) + en_n_4;


fi_n_1 = [fi_n_11, fi_n_12, fi_n_13];

fi_n1 = en_n - en_n_1;
fi_n2 = en_n;
fi_n3 = en_n - 2*en_n_1 + en_n_2;
fi_n = [fi_n1, fi_n2 fi_n3];

A = 1 + fi_n_1*P_n_1*(fi_n_1)';
B = P_n_1*(fi_n_1)'*fi_n_1*P_n_1;

P_n = P_n_1 - (1/A*B);

C = en_n - cikis_hesap_Fark_n_2 + (fi_n_1*theta_n_1);
D = P_n*(fi_n_1)';

theta_n = theta_n_1 + (C*D);

cikis_hesap_Fark =  fi_n*theta_n;
cikis_hesap = cikis_hesap_n_1 + cikis_hesap_Fark;
cikis_n = cikis_hesap;



if cikis_n > 100
    cikis_n = 100;
elseif cikis_n<0
    cikis_n = 0;
end



state(1) = sum_en;
state(2) = cikis_n;
state(3) = en_n;
state(4) = en_n_1;
state(5) = en_n_2;
state(6) = epsilon_n;
state(7) = epsilon_n_1;
state(8) = theta_n(1);
state(9) = theta_n(2);
state(10)= theta_n(3);
state(11) = P_n(1);
state(12) = P_n(4);
state(13) = P_n(7);
state(14) = P_n(2);
state(15) = P_n(5);
state(16) = P_n(8);
state(17) = P_n(3);
state(18) = P_n(6);
state(19) = P_n(9);
state(20) = cikis_n_1;
state(21) = cikis_hesap;
state(22) = en_n_3;
state(23) = en_n_4;
state(24) = cikis_hesap_Fark;
state(25) = cikis_hesap_Fark_n_1;






sys = [state];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
output(1) = x(2);
output(2) = x(21);
output(3) = x(8);
output(4) = x(9);
output(5) = x(10);
output(6) = x(6);



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

sampleTime = 5;    %  Example, set the next hit to be one second later.
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
