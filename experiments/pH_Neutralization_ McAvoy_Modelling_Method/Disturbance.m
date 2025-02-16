function [d] = Disturbance(t)
    if t<1500
        d = 40/60;
    end
    if t>=1500 && t<1510
        d = 50/60;
    end
    if t>=1510
        d = 40/60;
    end
end

    