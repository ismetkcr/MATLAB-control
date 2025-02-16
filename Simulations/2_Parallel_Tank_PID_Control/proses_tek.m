function dXdt = proses_tek(t,x,T_ambient,rho_tank,rho_fluid,U_tank,U_fluid,Cp_tank,Cp_fluid,r_tank,h_tank,M_pump,Q,r_fluid,h_fluid)
A_surftank = 2*pi*r_tank*h_tank; 
A_surfceket = A_surftank*0.75;
V_tank = pi*r_tank^2*h_tank;
M_tank = V_tank*rho_tank;
V_fluid = pi*r_fluid*h_fluid;
M_fluid = V_fluid*rho_fluid;

Tc = x(1) - (x(1)-x(2))*(exp(-U_tank*A_surfceket/(M_pump*Cp_fluid)));
dXdt(1,1) = (-(U_tank*A_surftank*(x(1)-T_ambient)) + M_pump*Cp_fluid*(x(2)-Tc))/(M_tank*Cp_tank);
dXdt(2,1) = (Q - U_fluid*A_surfceket*(x(2)-x(1)) - U_fluid*A_surfceket*(x(2)-T_ambient))/(M_fluid*Cp_fluid);


end

