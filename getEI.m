Ef=[];
If=[];
tf=[];
lambda = 2.4987;
for i = 2:5
   
    Ef(:,i-1) = E(fid+(i-2)*2089);
    If(:,i-1) = I(fid+(i-2)*2089);
    tf(:,i-1) = t(fid+(i-2)*2089);
    
    Eb(:,i-1) = E(bid+(i-2)*2089);
    Ib(:,i-1) = I(bid+(i-2)*2089);
    tb(:,i-1) = t(bid+(i-2)*2089);
    
    tp(:,i-1) = tf(:,i-1) - 2*lambda*i;
    tpp(:,i-1)=tb(:,i-1) - (2*i+1)*lambda;
    
end
