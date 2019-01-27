function pDnch = GMAPI(dnch,nSamp)
    pDnch = zeros(1,nSamp);
    for j=1:nSamp
        n = dnch(j);
        if rem(n,2) == 1  %negative
            pDnch(j) = -(n+1)/2;
        else
             pDnch(j) = n/2;
        end
    end
end