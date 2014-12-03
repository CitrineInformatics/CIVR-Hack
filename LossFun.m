function mse = LossFun(If,tp,par)

Ift=theory_IFT(par,tp);
mse = sqrt(sum(sum((Ift - If).^2)));

end