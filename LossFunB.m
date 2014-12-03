function mseb = LossFunB(Ib,tpp,par)

Ibt=theory_IBT(par,tpp);
mseb = sqrt(sum(sum((Ibt - Ib).^2)));

end