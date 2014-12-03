function [fig1] = plotting(tp, tpp,t,par, If, Ib, Eb, Ef, E);

%Ift=theory_IFT(par,tp);
%Ibt=theory_IBT(par,tpp);
tp1=tp-tp(1);
tpp1=tpp-tpp(1);
Ift=theory_IFT(par,tp1);
Ibt=theory_IBT(par,tpp1);
Ife = 1/1000*If;
Ibe = 1/1000*Ib;

fig1= figure()
title('Current vs Cycle Time')
xlabel('Cycle time, seconds')
ylabel('Current, amps')
hold on 
plot(tp1,Ift)
plot(tpp1,Ibt)
plot(tp1,Ife)
plot(tpp1,Ibe)


fig2= figure()
title('Voltage vs Time')
xlabel('Timeime, seconds')
ylabel('Voltage, volts')
hold on 
plot(t,E)


fig3= figure()
title('Voltage vs Current')
xlabel('Voltage, (volts)')
ylabel('Current, amps')
hold on 
plot(Ef,Ift)
plot(Eb,Ibt)
plot(Ef,Ife)
plot(Eb,Ibe)
end