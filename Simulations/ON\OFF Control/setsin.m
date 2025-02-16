function [y] = setsin(t)
if t<= 1000
    y = 7;

elseif 1000<t && t<=2000
    y=9;

elseif t>2000
    y=5;
end

