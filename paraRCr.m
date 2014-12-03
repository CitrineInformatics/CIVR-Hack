function paraRCr %parametric study of the RCr function.
scale si;
v=linspace(0,1,1001);v=[v fliplr(v)]';
r=[3 10 30];C=1;R=1;s=.1;I=[];
for i=r,I=[I IRCrV([R,C,i,0],v,s)];end;i=I/s/C;
figure(1);hold on;plot(v,i,'LineWidth',3)
box on;set(gca,'FontSize',18);
xlim(dwin(v));ylim(dwin(i));
xlabel('Potential/V' ,'fontsize',20);ylabel('Reduced Current/I(sC)^{-1}','fontsize',20);
leg={['r=' num2str(r(1))]  ['r=' num2str(r(2))] ['r=' num2str(r(3))]};
legend(leg,'location',[.5 0.5 .1 .1]);legend('boxoff');set(gca,'FontSize',18);
%title(name,'interpreter','none','fontsize',18);
calcCbyQ(v,I,s);
v=linspace(-.5,.5,1001);v=[v fliplr(v)]';
r=[3 10 30];C=1;R=1;s=.1;I=[];
for i=r,I=[I IRCrV([R,C,i,0],v,s)];end;i=I/s/C;
plot(v,i,'LineWidth',3)
box on;set(gca,'FontSize',18);
xlim(plotbox(v));ylim(plotbox(i));
xlabel('Potential/V' ,'fontsize',20);ylabel('Reduced Current:I(sC)^{-1}','fontsize',20);
leg={['r=' num2str(r(1))]  ['r=' num2str(r(2))] ['r=' num2str(r(3))]};
legend(leg,'location',[.5 0.5 .1 .1]);legend('boxoff');set(gca,'FontSize',18);
%title(name,'interpreter','none','fontsize',18);
xlim('auto');ylim('auto');
calcCbyQ(v,I,s);

R=3e-2;C=1;r=[1000 2 1];s=1;I=[];
for i=r,I=[I IRCrV([R,C,i,0],v,s)];end;i=I/s/C;
figure(2);plot(v,i,'LineWidth',3)
box on;set(gca,'FontSize',18);
xlim(dwin(v));ylim(dwin(i));
xlabel('Potential/V' ,'fontsize',20);ylabel('Reduced Current:I(sC)^{-1}','fontsize',20);
leg={['r=' num2str(r(1))]  ['r=' num2str(r(2))] ['r=' num2str(r(3))]};
legend(leg,'location',[.5 0.5 .1 .1]);legend('boxoff');set(gca,'FontSize',18);
%title(name,'interpreter','none','fontsize',18);
calcCbyQ(v,I,s);

R=3e-2;C=[1 3 9];r=1000;s=1;I=[];
for i=C,I=[I IRCrV([R,i,r,0],v,s)];end;
i=[I(:,1)/s/C(1) I(:,2)/s/C(2) I(:,3)/s/C(3)];
figure(3);plot(v,i,'LineWidth',3)
box on;set(gca,'FontSize',18);
xlim(dwin(v));ylim(dwin(i));
xlabel('Potential/V' ,'fontsize',20);ylabel('Reduced Current:I(sC)^{-1}','fontsize',20);
leg={['C=' num2str(C(1))]  ['C=' num2str(C(2))] ['C=' num2str(C(3))]};
legend(leg,'location','Best');legend('boxoff');set(gca,'FontSize',18);
%title(name,'interpreter','none','fontsize',18);
calcCbyQ(v,I,s);

R=3e-2;C=1;r=1000;s=[1 3 9];I=[];
for i=s,I=[I IRCrV([R,C,r,0],v,i)];end;
i=[I(:,1)/s(1)/C I(:,2)/s(2)/C I(:,3)/s(3)/C];
figure(4);plot(v,i,'LineWidth',3)
box on;set(gca,'FontSize',18);
xlim(dwin(v));ylim(dwin(i));
xlabel('Potential/V' ,'fontsize',20);ylabel('Reduced Current:I(sC)^{-1}','fontsize',20);
leg={['s=' num2str(s(1))]  ['s=' num2str(s(2))] ['s=' num2str(s(3))]};
legend(leg,'location','Best');legend('boxoff');set(gca,'FontSize',18);
%title(name,'interpreter','none','fontsize',18);
%calcCbyQ(v,I,s);

end

function W=dwin(X,tol)
if nargin==1,tol=.05;end
Xmax=max(X(:));Xmin=min(X(:));
eW=tol*(Xmax-Xmin);
W=[Xmin-eW Xmax+eW];
end
