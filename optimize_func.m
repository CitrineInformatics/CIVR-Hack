[RsRpC2f,errf] = fminunc(@(par) LossFun(If,tp,par),RsRpC1);
[RsRpC2b,errb] = fminunc(@(par) LossFunB(Ib,tpp,par),RsRpC1);
errorf = errf/(length(t)/2);
errorb = errb/(length(t)/2);
