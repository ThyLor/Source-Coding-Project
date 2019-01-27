function enc = GENC1(n, m)
%Ho to esimate the p?
%Just taking into account the sign
q = floor(n/m);                  
r = rem(n,m);
%unary code of quotient q
qenc = [ones(1,q) 0];                    
[F,E] = log2(m);                    

if (E == 1  && F==0.5)               %m=1
    enc = qenc;
else if (F == 0.5)                   %m power of 2
        renc = de2bi(r,log2(m),'left-msb'); %log2(m)-bit binary code of r
    else
        a = floor(log2(m)) + 1;
        if (r < (2^a - m))                
            renc = de2bi(r,a-1,'left-msb'); 
        else
            renc = de2bi(r+(2^a - m),a,'left-msb'); 
        end        
    end
        enc = [qenc renc];               %golomb code of the input 
end