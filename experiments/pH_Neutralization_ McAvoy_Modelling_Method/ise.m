function [output] = ise(error,t)
global ise_array
global iae_array
global itae_array
global itse_array

deltat = 0.5;

 if t == 0;
    ise_array = []; A1 = 0;
    iae_array = []; B = 0;
    itae_array = []; C = 0;
    itse_array = []; D = 0;
    
    deltat= 0.5;
    output(1) = 0;
    output(2) = 0;
    output(3) = 0;
    output(4) = 0;
    
 
 elseif t>0
     deltat = 0.5;
    A1 = error^2*deltat;
    B1 = abs(error)*deltat;
    C1 = abs(error)*t*deltat;
    D1 = abs(error^2)*t*deltat;
   
    ise_array = [ise_array A1];
    iae_array = [iae_array B1];
    itae_array = [itae_array C1];
    itse_array = [itse_array D1];
    
    
    
    A = sum(ise_array);
    B = sum(iae_array);
    C = sum(itae_array);
    D = sum(itse_array);
    
    output(1) = A;
    output(2) = B;
    output(3) = C;
    output(4) = D;
    
    end
end
    
    
    
