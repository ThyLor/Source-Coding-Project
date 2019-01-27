clear all
filename = 'AmGone.wav';
nStart = 0;        %Number of seconds after which we consider the audio
nSec = 30;          %Number of seconds that have to be considered
[tr,F,nSamp] = RAUDIO(filename,nSec,nStart);
tr = single(tr);
%Adaptive predictor
%bSec = [0.2 1 2 30];
bSec = [0.2];
varBX = zeros(1,length(bSec));
%For each block size considerated
for u=1:length(bSec)
    blockSec = bSec(u);
    nSampPB = F * blockSec;
    nBlocks = floor(nSec/blockSec);
    nSamp = nBlocks * nSampPB;  %Number of samples finally considered
    x = tr(1:nSamp);
    pnTX = zeros(1,nSamp);
    dn = zeros(1,nSamp);
    vN = [1 2 4];
    %Performance indicators
    nTest = 14;
    bMin = 2;
    CGAIN = zeros(1,3);
    varD = zeros(1,3);
    D = zeros(3,nTest);
    R = zeros(3,nTest);
    H = zeros(3,nTest);
    SNR = zeros(3,nTest);
    %And for the PCM version
    N_D = zeros(3,nTest);
    N_R = zeros(3,nTest);
    N_H = zeros(3,nTest);
    N_SNR = zeros(3,nTest);
    rangeC = nStart*F +1:nStart*F + nSamp;
    xchNaive = zeros(1,nSamp);
    %For each order
    for index=1:3
        N = vN(index);              %Estimator order
        an = zeros(nBlocks,N);
        M = nSampPB;
        wts = zeros(N+1,1);
        wts(1) = 1/M;
        for i = 2:N+1
            wts(i) = 1/(M - (i-1));
        end
        varBX = 0;
        for k=1:nBlocks
            bI = (k-1)*M +1:k*M;
            block = single(x(bI));
            mu = mean(single(block));    %is the same as sum(block).^2)/nSamp
            vr = var(single(block));     %is the same as sum((block-mean(block)).^2)/nSamp;
            varBX = varBX + vr;
            %mu
            an(k,:) = PCOEFF(block,wts,M,N,mu,vr);
            for j=1:M-N
                cI = (k-1)*M + j + N;
                pnTX(cI) = dot(fliplr(block(j:j+N-1)),an(k,:));
                dn(cI) = x(cI) - pnTX(cI);
            end
        end
        %% Simulation of nTest cases: quantization,Golomb enc, Golomb dec.
        stepSize = zeros(1,nTest); %vector that will contain the step size for each test
        dnch = zeros(1,nSamp); %Matrix that contains the quantized values: dnch(i,:) contains the quantized values of the i-th test
        pDnch = zeros(1,nSamp);
        % Sim
        for B = bMin:bMin+nTest-1
            %1)Quantization with DPCM
            Delta = 2*max(abs(dn))/ 2^(B);
            stepSize(B-bMin+1) = Delta/2;
            dnch = PCM(dn,B,Delta);
            %2)Let's see without DPCM how quantization performs
            DeltaN = 2*max(abs(x))/ 2^(B);
            xchNaive = PCM(x,B,DeltaN);
            xchNaive = DeltaN*xchNaive + sign(xchNaive)*DeltaN/2;
            %Get the probability distribution: first row = Pr values, second row = alphabet
            aDnch = unique(dnch);
            pDnch = GMAP(dnch,nSamp);
            aPDnch = unique(pDnch);
            aXN = sort(unique(xchNaive));
            probaPV = [hist(pDnch,aPDnch)/nSamp; aPDnch];
            probaV = [hist(dnch,aDnch)/nSamp;  aDnch];
            probaX = [hist(xchNaive,aXN)/nSamp; aXN];
            probaX(1,:) = probaX(1,:) + 0.00000000001;            %Just a trick, just not to have zeros
            m = floor( - 1/log2(1-probaPV(1,find(probaPV(1,:) == max(probaPV(1,:)))))) + 1;
            l_encSeq = 0;
            l = zeros(1,nSamp);
            for i = 1:nSamp
                %Encoding
                cw = GENC(pDnch(i),m);
                l(i) = length(cw);
                l_encSeq = l_encSeq + length(cw);
                %Starts decoding the symbol
                cwDec = GMAPI([GDEC(cw,m)],1);
            end
            % Decoding
            %Here, it is supposed that both transmitter and receiver know the size of the audio
            % Reconstructed val.
            dnchRX = Delta*dnch + sign(dnch)*Delta/2;
            pnRX = single(zeros(1,nSamp));
            xch = pnTX + dnchRX;
            %Here the hyp that first N symbols are directly sent.
            for(i=1:nBlocks)
                xch((i-1)*M + 1:(i-1)*M + N) = x((i-1)*M + 1:(i-1)*M + N);
            end
            %Compute statistics
            [D(index,B-bMin+1),R(index,B-bMin+1),H(index,B-bMin+1),SNR(index,B-bMin+1)] = PIND(x,xch,probaV,nSamp,l_encSeq);
            [N_D(index,B-bMin+1),N_R(index,B-bMin+1),N_H(index,B-bMin+1),N_SNR(index,B-bMin+1)] = PIND(x,xchNaive,probaX,nSamp,B*nSamp);
        end
        %Compute statistics
        CGAIN(index) = 10 *log10(sum((x-mean(x)).^2)/(nansum((dn-mean(dn)).^2)));         %cgain does not depend on B: 10log10(var(x)/var(dn))
        varD(index) = sum((dn-mean(dn)).^2)/nSamp;                                        %Or var(dn), gets the same results
    end
    %Compute statistics
    varX = sum((x-mean(x)).^2)/nSamp;   %Or var(xn) gets the same results.
    varBX = varBX/nBlocks;
    %Save the data
    fName = strcat(filename(1:3),'_',num2str(nSec),'_',num2str(blockSec*10));
    save(fName);
end