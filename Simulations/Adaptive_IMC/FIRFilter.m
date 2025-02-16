
function [sys,x0,str,ts] = FIRFilter(t,x,u,flag)
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
sizes.NumDiscStates  = 2;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
%
% initialize the initial conditions
y_n_1 = 0; i = 1; sample_n_1 = 0; adcSum_cnt_n_1 = 0; cikis_n_1 = 0; adcSum_n_1 = 0;
x0  = [cikis_n_1 i ];
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
function sys=mdlUpdate(t,x,u)

%b = [-0.000153959924563025	3.14569829766914e-19	0.000167227768379195	0.000341615513437200	0.000513334449695803	0.000667493753523138	0.000783901543031582	0.000838293462575982	0.000805143268199254	0.000661865814383533	0.000393913058925875	-7.06459155159238e-19	-0.000503471198655200	-0.00107975588750762	-0.00167172808603978	-0.00220503242539240	-0.00259459767500042	-0.00275419456529687	-0.00260821044185887	-0.00210435281785382	-0.00122565487042049	1.61078417347119e-18	0.00149454804118430	0.00313001278573051	0.00473523837917162	0.00610924274219416	0.00704052700732305	0.00733085046245534	0.00682124716979481	0.00541752181113058	0.00311220216062641	-2.69510942350426e-18	-0.00371573937634527	-0.00772735878239085	-0.0116387131075032	-0.0149920295374778	-0.0173040975634285	-0.0181089372865880	-0.0170031802185685	-0.0136898294779694	-0.00801592876971014	3.56083024732607e-18	0.0101541047926138	0.0220591142813953	0.0351627298073374	0.0487816213883638	0.0621485833455836	0.0744690322800940	0.0849820017237500	0.0930202199911827	0.0980638195762694	0.0997827312684366	0.0980638195762694	0.0930202199911827	0.0849820017237500	0.0744690322800940	0.0621485833455836	0.0487816213883638	0.0351627298073374	0.0220591142813953	0.0101541047926138	3.56083024732607e-18	-0.00801592876971014	-0.0136898294779694	-0.0170031802185685	-0.0181089372865880	-0.0173040975634285	-0.0149920295374778	-0.0116387131075032	-0.00772735878239085	-0.00371573937634527	-2.69510942350426e-18	0.00311220216062641	0.00541752181113058	0.00682124716979481	0.00733085046245534	0.00704052700732305	0.00610924274219416	0.00473523837917162	0.00313001278573051	0.00149454804118430	1.61078417347119e-18	-0.00122565487042049	-0.00210435281785382	-0.00260821044185887	-0.00275419456529687	-0.00259459767500042	-0.00220503242539240	-0.00167172808603978	-0.00107975588750762	-0.000503471198655200	-7.06459155159238e-19	0.000393913058925875	0.000661865814383533	0.000805143268199254	0.000838293462575982	0.000783901543031582	0.000667493753523138	0.000513334449695803	0.000341615513437200	0.000167227768379195	3.14569829766914e-19	-0.000153959924563025];

%b = [0.000508267310493284	0.000518066994786675	0.000526362613265899	0.000530844128819629	0.000527693808944291	0.000511714678263513	0.000476572362589726	0.000415144630758807	0.000319967092168438	0.000183757979003194	-3.26497638816279e-19	-0.000236446854765926	-0.000528730734349299	-0.000877422577664044	-0.00127999147598951	-0.00173037128474625	-0.00221864665036938	-0.00273088287458904	-0.00324911904071172	-0.00375153775035318	-0.00421281789203425	-0.00460466935567751	-0.00489654082218623	-0.00505648401774624	-0.00505215045759860	-0.00485189003572087	-0.00442591514581064	-0.00374748961143853	-0.00279409877912043	-0.00154855585072281	1.32687968828000e-18	0.00185525593865414	0.00401306644601311	0.00646101560287403	0.00917822630188880	0.0121354337879950	0.0152953318201737	0.0186131900840956	0.0220377316340581	0.0255122494831443	0.0289759323705349	0.0323653615750048	0.0356161337424136	0.0386645593355226	0.0414493827223191	0.0439134682528371	0.0460053970189138	0.0476809213532706	0.0489042284319825	0.0496489704497812	0.0498990265220483	0.0496489704497812	0.0489042284319825	0.0476809213532706	0.0460053970189138	0.0439134682528371	0.0414493827223191	0.0386645593355226	0.0356161337424136	0.0323653615750048	0.0289759323705349	0.0255122494831443	0.0220377316340581	0.0186131900840956	0.0152953318201737	0.0121354337879950	0.00917822630188880	0.00646101560287403	0.00401306644601311	0.00185525593865414	1.32687968828000e-18	-0.00154855585072281	-0.00279409877912043	-0.00374748961143853	-0.00442591514581064	-0.00485189003572087	-0.00505215045759860	-0.00505648401774624	-0.00489654082218623	-0.00460466935567751	-0.00421281789203425	-0.00375153775035318	-0.00324911904071172	-0.00273088287458904	-0.00221864665036938	-0.00173037128474625	-0.00127999147598951	-0.000877422577664044	-0.000528730734349299	-0.000236446854765926	-3.26497638816279e-19	0.000183757979003194	0.000319967092168438	0.000415144630758807	0.000476572362589726	0.000511714678263513	0.000527693808944291	0.000530844128819629	0.000526362613265899	0.000518066994786675	0.000508267310493284];

b = 1/20 * ones(1,20);

global x_array

cikis_n_1= x(1);
i = x(2);
if t == 0
x_array = zeros(1,length(b));
end


ft_order = length(b);



sample = u(1);
for i = 1:1:ft_order-1
    x_array(i) = x_array(i+1);
end

x_array(ft_order) = sample;


cikis_n=0;
cikis_n_1=0;

for i = 1:1:ft_order
    cikis_n = cikis_n_1 + x_array(i)*b(ft_order-i +1);
    cikis_n_1 = cikis_n;
end

%disp(cikis_n)
state(1) = cikis_n;
state(2) = i;


sys = [state];


% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)

sys = [x(1)];

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
