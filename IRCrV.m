function [I]=IRCrV(x,v,s)
%Requires well-ordered v increasing 1st during anodic cycle then decreasing
%produces the scaled total current from the scaled voltage, capacitance,
%and resistance. x vector can be 2 (R C) or 3 (R C r) members long.
%if no s is provided, program will assume it is included in C (s=1)

%if nargin==2, s=1; end                             %asuming C=s*C (or s=1)

R=x(1)*scaleres;
C=x(2)*scalecap;
r=x(3)*scaleres; 	%consider scales
%if v is empty, offset V by midpoint. else, offset v by V 
if length(x)>3, v=(v+x(4))*scalevol;end

v=v(:);V1=min(v);V2=max(v);
                               
xi=(R+r)/(C*R*r*s);ci=exp(xi*(V1-V2));
Ia=v/(R+r)+ C*s*r^2/(R+r)^2-(2*C*s*r^2*exp(xi*(V1-v)))/(R+r)^2/(ci+1);
Ic=v/(R+r)- C*r^2*s/(R+r)^2+2*C*r^2*s*exp(xi*(v-V2))/((R+r)^2*(ci+1));

I=vertcat(Ia(1:end/2),Ic(end/2+1:end))/scalecur; 	%consider scales
end