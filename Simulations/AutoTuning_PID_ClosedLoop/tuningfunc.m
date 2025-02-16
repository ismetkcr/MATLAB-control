function [values] = tuningfunc(t,y,switchMode,y_set)
global y_array
global KC;
global KI ;
global KD;
global update
global y_max_array
deltat = 0.5;

if t == 0;
    KC = 7.431;
    KI = 3.2728;
    KD = -37.75;
    y_array = [];
    y_max_array = [];
   
end

if switchMode == 1; %controller devrede
     
    
    values(1) = KC;
    values(2) = KI;
    values(3) = KD;
    values(4) = -1;
    y_array = [];
    y_max_array =[];
    
    
    %disp(y_array)
    %formatSpec = 'y_Array = %d\n';
    %fprintf(formatSpec,y_array)
 
    
    
elseif switchMode == 2; %autotun devrede verileri topla
   
   y_array = [y_array y];
    values(1) = KC;
    values(2) = KI;
    values(3) = KD;
    values(4) = 1;
    update = 1;
   
   

elseif switchMode == 3 && update ==1 %verileri aktar.
     
    
    
    
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
Kcu = (4*uamp)/(pi*yamp);

    KC = 0.6*Kcu;
    KI = Pu/2;
    KD = Pu/8;
    formatSpec = 'yamp : %4.3f, period : %4.3f hesaplandý\n';
    fprintf(formatSpec,yamp,period)
   
    
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

    
 
