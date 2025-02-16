function  set_point = setSimFuncRLS(t)
if t<1000
    set_point = 5;
end
if t>=1000 && t<2000
    set_point = 8;
end
if t>=2000 && t<3000 
    set_point = 5;
end


if t>=3000 && t<4000 
    set_point = 8;
end
if t>=4000 && t<5000 
    set_point = 5;
else
if t>=5000 && t<=6000 
    set_point = 30;
end
end