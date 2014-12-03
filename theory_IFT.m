function [Ift]=theory_IFT(par,tp)

Rs = par(1);
Rp = par(2);
C = par(3);

Emax = 10; %Maximum voltage (volts)
Emin = 0; %Minumum voltage (volts)
nu = 1; %Voltage sweep (volts/second)
lambda = (Emax-Emin)/nu;  %period of min to max voltage
cyc = 6; %total number of cycles
n = (1:1:cyc); %Current cycle number
a=  Rp+Rs; %simplification factor- adding resistance
b=  Rs*Rp*C; %simplification factor- multiplying impedences 

Ift = nu/a*(tp - (Rp*C-(b/a)).*((2*exp(a*(Emax-nu*tp)/(nu*b)))/(1+exp(a*Emax/(nu*b)))-1));


end
