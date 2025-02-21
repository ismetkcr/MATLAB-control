function [sys,x0,str,ts] = ContPID(t,x,u,flag,dperiod)
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
%               specified in TS. When specifying than one
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
%   $Revision: 1.18 $

%
% The following outlines the general structure of an S-function.
%
doffset = 0;
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(dperiod,doffset);

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
    sys=mdlOutputs(t,x,u,dperiod,doffset);

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
function [sys,x0,str,ts]=mdlInitializeSizes(dperiod,doffset)

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
sizes.NumDiscStates  = 4;   %Ayarlanabilir degisken % X state say�s�. Bunlara ait to zaman� ba�lang�� degerlerini x0 vektoru ile ayarla.
sizes.NumOutputs     = 3;   %Ayarlanabilir degisken 
sizes.NumInputs      = 4;   %Ayarlanabilir degisken 
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 2;   

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [0 0 0 0];    %Ayarlanabilir degisken  % sizes.NumDiscStates say�s� kadar deger girilmeli.

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
% ts  = [-2 0]; % Variable sample time
ts  = [0, 0 %sample time
dperiod, doffset]; % Inherited sample time
% ts  = [0 0];  % continuous sample time

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
function sys=mdlUpdate(t,x,u)
%t: o anki zaman
%x: state'lerin son degeri 
%u: t an�ndaki s fonksiyon girisleri (inputs)
error_n = u(1);

% Onceki girisleri ve cikislari al
 cikis_n_1 = x(1);
 error_n_1 = x(2);
 s_n_1 =  x(3);
 cikishesap_n_1 = x(4);
 
deltat = 0.5;
KC = u(2);
KI = u(3);
KD = u(4);

%Output0 = KC * ( e0) = KC * ( yset0 - y0);
%Output1 = KC * ( e1) = KC * ( yset1 - y1);
%Outout1-Output0 = KC * (e1 - e0);

%deltau = KC*(error_n - error_n_1);  % +((KC*deltat/KI)*error_n)-((KC*KD/deltat)*(error_n-(2* error_n_1)+error_n_2));
%cikis = cikis_n + deltau;



%%  CI

s_n = (s_n_1)+((KC/KI)*error_n*deltat);
cikishesap_n = (KC*error_n) + s_n +(KC*KD*(error_n - error_n_1))/deltat;
cikis_n = (cikishesap_n);%/10.667;


if ((cikis_n<100) && (cikis_n>0)) 
    state(3) = s_n;
   
elseif (cikis_n>100); cikis_n = 100;
    state(3) = s_n_1;
elseif (cikis_n<0) ;cikis_n = 0; 
    state(3) = s_n_1;
end
% bunu actarsam assag�dan state(3) silinmeli.
%}

if (cikis_n < 0 )
    cikis_n = 0;
elseif (cikis_n > 100)
    cikis_n = 100;   
end
state(1) = cikis_n;
state(2) = error_n;
state(4) = cikishesap_n;

  
            % x(1) yeni degerini ata   

sys = state;
% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u,dperiod,doffset)

if abs(round((t-doffset)/dperiod)-(t-doffset)/dperiod) < 1e-8

    output(1)= x(1);
    output(2) = x(3);
    output(3) = x(4);
    sys = [output];
else 
     sys = [];
end




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
