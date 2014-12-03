function [mse, dmse] = LossFun_grad(If,tp,par)

Ift=theory_IFT(par,tp);
mse = sqrt(sum(sum((Ift - If).^2)));

drp = sqrt(sum(sum(grad_Rp_f(par,tp))));
drs = sqrt(sum(sum(grad_Rs_f(par,tp))));
drc = sqrt(sum(sum(grad_C_f(par,tp))));

dmse = [drp; drs; drc];


end