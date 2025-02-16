function [values] = tuningfunc3(t,y,switchMode,y_set,u_relay)
global y_array
global u_array
global t_array
global y_max_array
global KC;
global KI ;
global KD;
global update
deltat = 0.2;

if t == 0
    KC = 7.431;
    KI = 3.2728;
    KD = -37.75;
    y_array = [];
    u_array = [];
    t_array = [];
    y_max_array = [];
end

if switchMode == 1 %controller devrede
     
    
    values(1) = KC;
    values(2) = KI;
    values(3) = KD;
    values(4) = -1;
    y_array = [];
    u_array =[];
    t_array = [];
    y_max_array = [];
    
    %disp(y_array)
    %formatSpec = 'y_Array = %d\n';
    %fprintf(formatSpec,y_array)
 
    
    
elseif switchMode == 2 %autotun devrede verileri topla
   
   y_array = [y_array y];
   u_array = [u_array u_relay];
   t_array = [t_array t];

    values(1) = KC;
    values(2) = KI;
    values(3) = KD;
    values(4) = 1;
    update = 1;
   
    


    


elseif switchMode == 3 && update ==1 %verileri aktar.
     
    
   
    
    dydt = trapzoidat(t_array,y_array);
    dudt = trapzoidat(t_array,u_array);
    kp = dydt/dudt;
    
    
    
    y_smooth = smooth(y_array);
    P = allpeaks(y_smooth);
    period = (mean(diff(P(:,1))))*deltat;
    uamp = 50;
    
    Pu = period;
    m = find_size(y_array);
    index = floor(period/deltat);
    
    i = 1;
    idx = index;
 while index<m(2)
    ymax = max(y_array(i:index));
    i = i+idx;
    index = index+idx;
    y_max_array = [y_max_array; ymax];
 end
n = find_size(y_max_array);
yamp = sum(y_max_array)/n(1)-y_set;
    a = yamp;
    h = uamp;

    tau_num = Pu/2;
    tau_denum = (kp*h+a)/(kp*h-a);
    tau = tau_num/(log(tau_denum));
    theta_num1 = Pu/2;
    theta_num2 = (kp*h+1)/(kp*h);
    theta_num = theta_num1*log(theta_num2);
    theta_denum = tau_denum;
    theta = theta_num/log(theta_denum);

    AC = tau/(kp*theta);
    BC = (16 + (3*theta/tau))/12;
    KC_CC = AC*BC;
    CC = theta*(32 + (6*theta/tau));
    DC = 13 + (8*theta/tau);
    TI_CC = CC/DC;
    EC = 4*theta;
    FC = 11 + (2*theta)/tau;
    TD_CC = EC/FC;




    KC = KC_CC;
    KI = TI_CC;
    KD = TD_CC;
    formatSpec = 'kp : %4.3f, tau : %4.3f, theta : %4.3f, Pu: %4.3f , yamp: %4.3f hesaplandi\n';
    fprintf(formatSpec,kp,tau,theta,Pu,yamp)
   
    
    values(1) = KC;
    values(2) = KI;
    values(3) = KD;
    values(4) = -1;
    
    update = 0;
elseif switchMode == 3 && update == 0
    values(1) = KC;
    values(2) = KI;
    values(3) = KD;
    values(4) = -1;


    
end

end

    
 
