%asit akis Fa 
Fa = (40/1000)/60
% baz akis Fb
Fb = (38/1000)/60

%1.85gr NaoH kullandim yüzde98, Molar Kutle 40g/mol
MolariteNaoh = ((7/5) / 40); %mol/L
kb = MolariteNaoh;
% 1.5 mL HCL kulland?m, yogunluk = 1.2g/mL yüzde %37 Molar kütle 36.45 g/mol
MolariteHCL =  (20/5) * (0.37*1.2) / 36.5; %mol/L
ka = MolariteHCL;

% state-space denklemleri
V = 0.70; %L
A = -(Fa+Fb)/V; % 
Bbase = kb/V;
Bacid = -ka/V;
C = 1;
D = 0;

[numb,denb] = ss2tf(A,Bbase,C,D);
sysBase = tf(numb,denb)

[numa,dena] = ss2tf(A,Bacid,C,D);
sysAcid = tf(numa,dena)








