E= data(:,9);
I = data(:,10);
cn = data(:,11);
t = data(:,7);
index = (cn==1)|(cn==MaxCircle);
E(index)=[];
I(index)=[];
t(index) = [];

for i = 2:MaxCircle-1
   
    ind = (cn==i);
    Es = E(ind);
    Emax(i) = max(Es);
    Emin(i) = min(Es);
    N(i) = sum(ind);
    ind1(i) = find(Es==Emax(i));
    ind2(i) = find(Es==Emin(i));
    
end

Ef=[];
If=[];
tf=[];

TotNum = length(Es);

fid = 1:ind1(1);
bid = ind2(1):TotNum;

lambda = 2.5;

for i = 2:MaxCircle-1
   
    Ef(:,i-1) = E(fid+(i-2)*TotNum);
    If(:,i-1) = I(fid+(i-2)*TotNum);
    tf(:,i-1) = t(fid+(i-2)*TotNum);
    
    Eb(:,i-1) = E(bid+(i-2)*TotNum);
    Ib(:,i-1) = I(bid+(i-2)*TotNum);
    tb(:,i-1) = t(bid+(i-2)*TotNum);
    
    tp(:,i-1) = tf(:,i-1) - 2*lambda*i;
    tpp(:,i-1)=tb(:,i-1) - (2*i+1)*lambda;
    
end