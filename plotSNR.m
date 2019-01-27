mrk={'-+','-*','->','--'};
figure;
%name = 'track70';
load('ID_30_300.mat');
%load('pcm_Cap_02.mat');
X = 2:15;
xMax = min(X) + length(X)-1;  
xMin = min(X);
yMin = min(N_SNR(1,X-1));
%yMin = 80;
N_SNR
%yMin = 88;
%load(strcat('N_',num2str(1),'_M_30000_',name,'_GMAP.mat'),'D','R');
%h = semilogy(fliplr(D),flip(R),mrk{1},'Color','r','LineWidth', 1);
plot(X,N_SNR(1,X-1),mrk{1},'Color','r','LineWidth', 1);
hold on
%load('SNR_H_Cap_2.mat');
%load('Cap_30_2.mat');
yMax = max(SNR(3,X-1));
plot(X,SNR(1,X-1),mrk{2},'Color','g','LineWidth', 1);
hold on
plot(X,SNR(2,X-1),mrk{3},'Color','y','LineWidth', 1);
hold on
plot(X,SNR(3,X-1),mrk{4},'Color','b','LineWidth', 1);
axis([xMin xMax yMin yMax])
set(0,'defaultTextInterpreter','latex') % to use LaTeX format
l = legend('PCM','N = 1', 'N = 2','N = 4');
set(gca,'FontSize',13);
title('SNRs PCM vs DPCM');

set(l,'Interpreter','latex');
xlabel('$B [bit]$')
ylabel('$SNR$  [dB]')
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on',...
    'YGrid', 'on', 'XGrid', 'on'); 
%}
