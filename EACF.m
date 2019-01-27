function cv = EACF(x,wts,M,N,mu,var)
%don't forget to normalize the matrix    
    A1(1,:) = x-mu;
    for i = 2:N+1 
        A1(i,:) = [x(i:M)-mu zeros(1,i-1)];
    end
    cv = (diag(wts)*(A1*(x-mu)'))/var;
end
