function dxdt = lyapunov_func(t,x,ur,ym,time_um,a,b,gamma1,gamma2)


ur = interp1(time_um,ur,t);
ym = interp1(time_um,ym,t);

u = x(2)*ur - (x(3)*x(1));
e = x(1) - ym;
 
dxdt(1,1) = a*x(1) + b*u; %plant
dxdt(2,1) = -gamma1*ur*e;%Kr
dxdt(3,1) = gamma2*x(1)*e; %Kx

end

