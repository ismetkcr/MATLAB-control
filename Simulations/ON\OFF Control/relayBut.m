function [u] = relayBut(y_set,y)
global cikis
    if y<=y_set-0.1
        cikis = 100;
        u = cikis;
    elseif y>=y_set+0.1
        cikis = 0;
        u = cikis;
    else
        u =cikis;
    
    
    end
   
end