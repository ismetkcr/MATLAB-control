function dCdt = phfunc(t,C,k,V,FA,FB,FT,CA0,CB0)
%C1 = CA, C2 = CB
rA = -k*C(1)*C(2);
dCdt = [(1/V)*(FA*CA0-FT*C(1) + rA*V);
        (1/V)*(FB*CB0-FT*C(2) + rA*V)];
end

