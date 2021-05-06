%%
clc
% clear all


yMatWaterfall=y__;
xMatWaterfall = repmat(linspace(0,0.1,512),size(yMatWaterfall,1),1);
time=tMat;
%%
figure(1)
clf
ModeAmplitudes = zeros(size(yMatWaterfall,1), 20);

% for ii = 1082   %tRange(1):tRange(end)
parfor ii = 1:size(yMatWaterfall,1)
    xMat = xMatWaterfall(ii,:);
    yMat=yMatWaterfall(ii,:);
    ii
    pause(0.01)
% end    
    Fs = 1;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = 1000;             % Length of signal
    t = (0:L-1)*T;        % Time vector

    X =smooth(yMat-0,26)%mean(yMat));
%     subplot(2,1,1)
%     plot(xMat,X)
%     ylim([-20 70])

    Y = fft(X);

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;

%     subplot(2,1,2)
%     hold on
%     plot(f(1:20),P1(1:20),'.') 
%     title('Single-Sided Amplitude Spectrum of X(t)')
%     xlabel('f (Hz)')
%     ylabel('|P1(f)|')
    [P1(1) P1(2) P1(3) P1(4) P1(5) P1(6)]
    ModeAmplitudes(ii,:)=P1(1:20);
end

%%
figure(3)
% clf
hold on
subplot(1,2,1)
for i = [2,6,7]
    hold on
plot(  ModeAmplitudes(:,i) )
end
xlim([1100 1300])

subplot(1,2,2)
for i = [1,2]
plot(  ModeAmplitudes(:,i) )
end
xlim([5000 5500])

xline(1160)
%%
figure
plot(ModeAmplitudes(1:700,1:6))
hold off

%%
clf
xx = 1:100;
yy = ModeAmplitudes(1:100,6);
plot(xx,yy,'--')
hold on
% close all
plot(xx'-61,1.37e-6*exp( 0.48*(xx-90.28) ),'--' );
ylim([0 0.5e-5])
xlim([0 40])