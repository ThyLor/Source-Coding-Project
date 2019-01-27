function xch = PCM (x,B,Delta)
    Nsteps = 2^(B-1) - 1;
    %Let's have a uniform quantizer
    xch = single(int16(sign(x)).*(int16(min(floor((single(abs(x))/Delta)),Nsteps))));
end