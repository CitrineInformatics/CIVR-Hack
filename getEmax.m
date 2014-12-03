for i = 2:5
   
    ind = (cn==i);
    Es = E(ind);
    Emax(i) = max(Es);
    Emin(i) = min(Es);
    N(i) = sum(ind);
    ind1(i) = find(Es==Emax(i));
    ind2(i) = find(Es==Emin(i));
    
end