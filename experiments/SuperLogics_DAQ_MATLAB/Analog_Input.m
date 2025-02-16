function [sys,x0,str,ts] = Analog_Input(t,x,u,flag, AC1, AC2, AC3, AC4, AC5, AC6, AC7, AC8)
%Serial_Init S-function whose output is the handle to serial COM Port.
%  This M-file reads the analog input channels from the SL 8018 with 8520
%  The first input is the Com_port number from Serial Port Block.
%
%   See sfuntmpl.m for a general S-function template.
%
%   See also SFUNTMPL.
    
%   Copyright 1990-2002 The MathWorks, Inc.
%   $Revision: 1.7 $

global s;
global mport;
global num_analCHN;
%
% Dispatch the flag. The switch function controls the calls to 
% S-function routines at each simulation stage of the S-function.
%
switch flag,
  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  % Initialize the states, sample times, and state ordering strings.
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes(AC1, AC2, AC3, AC4, AC5, AC6, AC7, AC8);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  % Return the outputs of the S-function block.
  case 3
    sys=mdlOutputs(t,x,u, AC1, AC2, AC3, AC4, AC5, AC6, AC7, AC8);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u, AC1, AC2, AC3, AC4, AC5, AC6, AC7, AC8);
  
  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  % There are no termination tasks (flag=9) to be handled.
  % Also, there are no continuous or discrete states,
  % so flags 1,2, and 4 are not used, so return an emptyu
  % matrix 
  case { 1, 2, 4}
    sys=[];

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Unexpected flags (error handling)%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Return an error message for unhandled flag values.
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end


% end timestwo

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts] = mdlInitializeSizes(AC1, AC2, AC3, AC4, AC5, AC6, AC7, AC8)
global s;
global mport;
global num_analCHN;

s = 0;
mport = 0;
num_analCHN = AC1 + AC2 + AC3 + AC4 + AC5 + AC6 + AC7 + AC8; 

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = num_analCHN;
sizes.NumInputs      = 1;  
sizes.DirFeedthrough = 1;  % has direct feedthrough
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
str = [];
x0  = [];
ts  = [-1 0];   % inherited sample time

% end mdlInitializeSizes

%
%=============================================================================
% mdlOutputs
% Return the output vector for the S-function
%=============================================================================
%
function sys = mdlOutputs(t,x,u, AC1, AC2, AC3, AC4, AC5, AC6, AC7, AC8)
global s;
global mport;
global num_analCHN;

y = -1000.0 * ones(num_analCHN,1);

if t==0
    if s==0
        mport = u(1);
        port_name = ['COM' num2str(import)];
        s = instrfind('Type','serial','Port',port_name);
        if isempty(s) 
            error(['Comm Port is not a valid open port !' port_name])
        end
    end
end

if isempty(s) 
            error(['Comm Port is not a valid open port !' port_name])
else
    i = 0;
    
    if AC1==1
        fprintf(s,'%s\r','#000');
        i = i + 1;
        y(i) = fscanf(s,'>%f\r');
    end    
    if AC2==1
        fprintf(s,'%s\r','#001');
        i = i + 1;
        y(i) = fscanf(s,'>%f\r');
    end    
    if AC3==1
        fprintf(s,'%s\r','#002');
        i = i + 1;
        y(i) = fscanf(s,'>%f\r');
    end    
    if AC4==1
        fprintf(s,'%s\r','#003');
        i = i + 1;
        y(i) = fscanf(s,'>%f\r');
    end    
    if AC5==1
        fprintf(s,'%s\r','#004');
        i = i + 1;
        y(i) = fscanf(s,'>%f\r');
    end    
    if AC6==1
        fprintf(s,'%s\r','#005');
        i = i + 1;
        y(i) = fscanf(s,'>%f\r');
    end    
    if AC7==1
        fprintf(s,'%s\r','#006');
        i = i + 1;
        y(i) = fscanf(s,'>%f\r');
    end    
    if AC8==1
        fprintf(s,'%s\r','#007');
        i = i + 1;
        y(i) = fscanf(s,'>%f\r');
    end    
end

%disp(['Reading ' num2str(i) ' channels']);
%disp(y);

sys = y;
  
% end mdlOutputs

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u, AC1, AC2, AC3, AC4, AC5, AC6, AC7, AC8)
global s;
global mport;

sys = [];

% end mdlTerminate
