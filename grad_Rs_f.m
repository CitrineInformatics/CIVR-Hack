function [gradRs]=grad_Rs_f(par,tp);
Rs = par(1); %series resistance
Rp = par(2); %Parallel resistance
C = par(3); %Capacitance

Emax = 10; %Maximum voltage (volts)
Emin = 0; %Minumum voltage (volts)
nu = 1; %Voltage sweep (volts/second)
lambda = (Emax-Emin)/nu;  %period of min to max voltage
cyc = 6; %total number of cycles
n = (1:1:cyc); %Current cycle number
a=  Rp+Rs; %simplification factor- adding resistance
b=  Rs*Rp*C; %simplification factor- multiplying impedences 

terma= 2*(exp(a*(Emax-tp*nu)/(b*nu)));
termb= exp(Emax*a/(b*nu))+1;
termc= -(C*Rp-(b/a));

term1= (1/a)*nu*((b/a^2)-C*Rp/a)*(-(terma/termb-1));
term2= (terma/termb.*(((Emax-tp*nu)/(b*nu))-a*(Emax-tp*nu)/(b*Rs*nu)));
term3= 2*(Emax/(b*nu)-Emax*a/(b*Rs*nu))*exp((a*(Emax-tp*nu)/(b*nu))+(Emax*a/(b*nu)))/(termb^2);
term4= nu*(tp- (C*Rp - b/a)).*((terma/termb)-1)/(a^2) ;

gradRs = term1+termc.*(term2-term3) - term4;
end