%%
clc
clear all
load('DataResults5mmC.mat')
load('Image5mmCData.mat')
length_measFit=zeros(FrameNum,1);
length_measData=zeros(FrameNum,1);

yEnd2=59;
xEnd2=890;
yEnd1=55;

tRange = [1100:3100];

xMatWaterfall=zeros([length(tRange) 1000]);
yMatWaterfall=zeros([length(tRange) 1000]);

time=(1:FrameNum)./15000;
%%
% figure
% subplot(2,1,2)
xEnd1_Mat=zeros(length(Clamp1Pos));
% parfor ii=1:FrameNum
parfor ii=tRange%:10:FrameNum
%     axis equal
    try
    ii
    xEnd1=Clamp1Pos(ii)-15;
    xEnd1_Mat(ii)=xEnd1;
    jj=30;
    y_=yWaterfall(ii,:);
    x = Clamp1Pos(ii)+jj:Clamp2Pos(ii);
    y=y_(y_>0);
    y=y(jj+1:end);
    p = polyfit(x,y,25);
    x1 = linspace(x(1),x(end),(x(end)-x(1))./12);
    y1 = polyval(p,x1);
    length_measFit(ii)=arclength([xEnd1 x1 xEnd2],[yEnd1 y1 yEnd2]);
    length_measData(ii)=arclength([xEnd1 x xEnd2],[yEnd1 y yEnd2]); 
    % figure
%     imshow(s(ii).cdata)
%     hold on
%     plot([xEnd1 x xEnd2],[yEnd1 y yEnd2],'c.')
%     plot([xEnd1 x1 xEnd2],[yEnd1 y1 yEnd2],'r.')
%     hold off
%     title([ii time(ii) length_measFit(ii)])
    % pause(0.01)
    
    xMatWaterfall(ii,:)=linspace(xEnd1,xEnd2,1000);
    yMatWaterfall(ii,:)=interp1([xEnd1 x xEnd2],[yEnd1 y yEnd2],linspace(xEnd1,xEnd2,1000));
    end
end

% csvwrite('ResultC.txt',[LengthMM,ClampDistMM',timeImage'])

%%
clearvars -except yMatWaterfall xMatWaterfall tRange

%%
ModeAmplitudes = zeros([length(tRange) 20]);

for ii = tRange(1):tRange(end)
    xMat = xMatWaterfall(ii,:);
    yMat=yMatWaterfall(ii,:);
    ii
%     figure(1)
%     plot(xMat,yMat)
%     pause(0.001)
% end
%
    
    Fs = 1;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = 1000;             % Length of signal
    t = (0:L-1)*T;        % Time vector

    X =yMat-mean(yMat);

    Y = fft(X);

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
%     plot(f,P1,'.') 
%     title('Single-Sided Amplitude Spectrum of X(t)')
%     xlabel('f (Hz)')
%     ylabel('|P1(f)|')
    ModeAmplitudes(ii-tRange(1)+1,:)=P1(1:20);
end



%%
hold on

for i = 2:7
    subplot(7,1,i-1)
    plot(tRange./15000,ModeAmplitudes(1:end,i)','x')
%     legend('1','2', '3','4', '5','6')
    title(i)
    xlabel('time (ms)')
    ylabel('Amplitude')
    xlim([1000/15000 1770/15000])
    ylim([1 50])
    set(gca,'YScale', 'log')
end
%     xline(1321/15000)
%%
B=[];
for i = 1:10
    A=ModeAmplitudes(1:end,i);
    Arep = repmat(A,1,100);
    B=[B Arep];
end
waterfall(B')
set(gca,'XScale', 'log')
xlim([40 2000])
colorbar
%%
C = gradient(B');
C(abs(C)>1)=0;
waterfall(B',C*10)
colorbar
%%
GrowthRates = zeros(10,1);
Decayrates  = zeros(10,1);
%%
plot(ModeAmplitudes(:,6))

for i = 6
%     yMat=ModeAmplitudes(126:150,4); %i=4
%     yMat=ModeAmplitudes(191:224,i);   %i=5
    yMat=ModeAmplitudes(120:145,i); %i=6

    xMat = (1:length(yMat))'/15000

    g = fittype('a+b*exp(c*x)');
    f=fit(xMat,yMat,g)
    
    plot(xMat,yMat)
    hold on
    plot(f)
    
%     GrowthRates(i) =1/f.c1;
    DecayRates(i) = f.c;
end




%%
wMat = zeros(1,length(tRange))
hold on
for ii = 1100:3100
    plot(yMatWaterfall(ii,:))
    wMat(ii)=mean((yMatWaterfall(ii,:)-58).^2);
end

%%


