function  set_point = setSimA(t)
if t<700
    set_point = 7.5;
end
if t>=700 && t<1300
    set_point = 8.5;
end
if t>=1300
    set_point = 8;
end
end