function  set_point = setSimFunc(t)
if t<200
    set_point = 7.5;
end
if t>=200 && t<400
    set_point = 8.5;
end
if t>=400
    set_point = 8;
end
end