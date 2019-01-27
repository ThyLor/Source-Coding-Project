function [full,F,nSamp] = RAUDIO(filename,nSec,nStart)
%filename = '70.wav';

info = audioinfo(filename);

[full,F] = audioread(filename,'native');
nSamp = F * nSec;   %Number of true samples
s = F * nStart +1;
full = full(s:s+nSamp-1);
fprintf('\n'); 
fprintf('Sampling frequency:      F = %d',F); fprintf(' [Hz] \n'); 
fprintf('Resolution:          nbits = %d',info.BitsPerSample); fprintf(' [bit] \n');

end