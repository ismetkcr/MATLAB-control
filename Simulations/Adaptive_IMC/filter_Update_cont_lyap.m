
function [sys,x0,str,ts] = filter_Update_cont_lyap(t,x,u,flag,ksi0, n0, K, threshold, I_inc, I_dec)
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
    [sys,x0,str,ts]=mdlInitializeSizes(ksi0, n0);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u,K, threshold, I_inc, I_dec);

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
function [sys,x0,str,ts]=mdlInitializeSizes(ksi0, n0)

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
sizes.NumDiscStates  = 9;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
%gamma = 1000;
J_k_1 = 0;

x0  = [ksi0, n0, J_k_1 0 0 0 0 0 0];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

sys = [];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u,K, threshold, I_inc, I_dec)

r_k = u(1);
y_k = u(2);
y_m_k = u(3);
a1 = u(4);
a2 = u(5);
b1 = u(6);
ksi_n_1 = x(1);
n_k_1 = x(2);
J_k_1 = x(3);
v_k_1 = x(4);
v_k_2 = x(5);
u_k_1 = x(6);
u_k_2 = x(7);
lambda_n_1 = x(8);
cikis_n_1 = x(9);
v_k = r_k + y_m_k - y_k;



filter_param = 1/(1 + exp(-ksi_n_1));
lambda_n = filter_param;


multi1 = (filter_param * cikis_n_1);
multi2 = (1-filter_param)/b1;
multi3 = (v_k - a1*v_k_1 - a2*v_k_2);



cikis_n = multi1 + (multi2*multi3);
u_k = cikis_n;
if cikis_n>100
    cikis_n = 100;
elseif cikis_n<0
    cikis_n = 0;
end




er_k = r_k - y_m_k;


multip1 = b1;
multip2 = u_k_1 - (1/b1)*(v_k - a1*v_k_1 - a2*v_k_2);
multip3 = filter_param*(1-filter_param);
multip4 = n_k_1;



tol = 10e-5;
J_k = er_k;
diff_J = (J_k - J_k_1);
if abs(diff_J)<tol
    diff_J = 0;
end
diff_J

;
%n_k = n_k_1;
 
if diff_J > threshold
    ksi_n = ksi_n_1;
    n_k = I_dec*n_k_1;
elseif abs(diff_J) <= threshold
    ksi_n = ksi_n_1 +   ((multip4/multip1) * (er_k/multip3) * (multip2)^-1);
    n_k = n_k_1;
else
    ksi_n = ksi_n_1 + (multip4/multip1) * (er_k/multip3) * (multip2)^-1;
    n_k = I_inc * n_k_1;
   
end



 if n_k>=2
     n_k = 2;
 end
 if n_k<0
     n_k = 0;
 end
 
 if abs(er_k)<0.1
     ksi_n = ksi_n_1;
 end
 
 if ksi_n > 2
     ksi_n = 2;
 elseif ksi_n<-2
     ksi_n = -2;
 end
 


state(1) = ksi_n;
state(2) = n_k;
state(3) = J_k;
state(4) = v_k;
state(5) = v_k_1;
state(6) = u_k;
state(7) = u_k_1;
state(8) = lambda_n;
state(9) = cikis_n;
sys = [state];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
output(1) = x(8);
output(2) = x(2);
output(3) = x(3);
output(4) = x(1);
output(5) = x(9);


sys = [output];

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
