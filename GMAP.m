function pDnch = GMAP(dnch,nSamp)
    pDnch = zeros(1,nSamp);
    for j=1:nSamp
            if(dnch(j) < 0 )
                pDnch(j) = 2*abs(dnch(j)) - 1;
            else
                pDnch(j) = 2*abs(dnch(j));
            end
    end
end