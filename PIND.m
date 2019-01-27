function [D,R,H,SNR] = PIND(x,xch,probaV,nSamp,l_encSeq)
    D = nansum((x - xch).^2)/nSamp; 
    R = l_encSeq/nSamp;
    H= -sum(probaV(1,:).*log2(probaV(1,:))); 
    %SNR[dB] = 10log10(var(x)/var(q)) , q = x - xnch (quantization error)
    %(Link between var(dn) = var(x) - sum(ak*rk from 1 to N)
    SNR = 10 *log10(sum(x.^2)/(nansum((x - xch).^2)));
end