function s  = trapzoidat(x,y)
n = length(x); s = 0;
for k = 1:n-1
    s = s +(y(k) + y(k+1))*(x(k+1) - x(k))/2;
end