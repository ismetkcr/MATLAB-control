function [u] = relayBut(y_set,y,t)
global cikis
if t==0
    cikis = 0;
end

    if y<=y_set-0.5
        cikis = 100;
        u = cikis;
    elseif y>=y_set+0.5
        cikis = 0;
        u = cikis;
    else
        u =cikis;
    
    
    end
   
end