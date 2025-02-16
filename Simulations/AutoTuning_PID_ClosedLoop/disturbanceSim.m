function [d] = disturbanceSim( t )
    if t<1700
        d = 0;
    end
    if t>=1700 && t<1750
        d = 20;
    end
    if t>=1750
        d = 0;
    end
end
    