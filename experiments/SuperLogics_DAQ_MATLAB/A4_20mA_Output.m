function [sys,x0,str,ts] = A4_20mA_Output(t,x,u,flag, OC1, OC2, OC3, OC4)
%Serial_Init S-function whose output is the handle to serial COM Port.
%  This M-file sets the analog output channels from the SL 8024 with 8520
%  The first input is the Com_port number from Serial Port Block.
%
%   See sfuntmpl.m for a general S-function template.
%
%   See also SFUNTMPL.
    
%   Copyright 1990-2002 The MathWorks, Inc.
%   $Revision: 1.7 $

global s;
global mport;
global num_CHN;
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
    [sys,x0,str,ts]=mdlInitializeSizes(OC1, OC2, OC3, OC4);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  % Return the outputs of the S-function block.
  case 3
    sys=mdlOutputs(t,x,u, OC1, OC2, OC3, OC4);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u, OC1, OC2, OC3, OC4);
  
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
function [sys,x0,str,ts] = mdlInitializeSizes(OC1, OC2, OC3, OC4)
global s;
global mport;
global num_CHN;

s = 0;
mport = 0;
num_CHN = 4 ;%OC1 + OC2 + OC3 + OC4; 

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;
sizes.NumInputs      = 1 + num_CHN;
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
function sys = mdlOutputs(t,x,u, OC1, OC2, OC3, OC4)
global s;
global mport;
global num_CHN;

y = -1000.0 * ones(num_CHN,1);

if t==0
    if s==0
        mport = u(1);
        port_name = ['COM' num2str(mport)];
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
    if OC1==1
        if u(2)>20.0
            u(2) = 20.0;
        end
        cmd = sprintf('%s%+07.3f','#020',u(2));
        fprintf(s,'%s\r',cmd);
        fscanf(s);
    end    
    if OC2==1    
        if u(3)>20.0
            u(3) = 20.0;
        end
        cmd = sprintf('%s%+07.3f','#021',u(3));
        fprintf(s,'%s\r',cmd);
        fscanf(s);
    end    
    if OC3==1    
        if u(4)>20.0
            u(4) = 20.0;
        end
        cmd = sprintf('%s%+07.3f','#022',u(4));
        fprintf(s,'%s\r',cmd);
        fscanf(s);
    end    
    if OC4==1    
        if u(5)>20.0
            u(5) = 20.0;
        end
        cmd = sprintf('%s%+07.3f','#023',u(5));
        fprintf(s,'%s\r',cmd);
        fscanf(s);
    end    
end

%disp(['Reading ' num2str(i) ' channels']);
%disp(y);

sys = [];
  
% end mdlOutputs

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u, OC1, OC2, OC3, OC4)
global s;
global mport;

if isempty(s) 
            error(['Comm Port is not a valid open port !' port_name])
else
    i = 0;
    if OC1==1
        cmd = sprintf('%s%+07.3f','#020',0);
        fprintf(s,'%s\r',cmd);
        fscanf(s);
    end    
    if OC2==1
        cmd = sprintf('%s%+07.3f','#021',0);
        fprintf(s,'%s\r',cmd);
        fscanf(s);
    end    
    if OC3==1
        cmd = sprintf('%s%+07.3f','#022',0);
        fprintf(s,'%s\r',cmd);
        fscanf(s);
    end    
    if OC4==1
        cmd = sprintf('%s%+07.3f','#023',0);
        fprintf(s,'%s\r',cmd);
        fscanf(s);
    end    
end

sys = [];

% end mdlTerminate
