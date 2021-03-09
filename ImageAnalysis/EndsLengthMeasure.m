%%
clc
clear all
load('DataResults5mmC.mat')
length_measFit=zeros(FrameNum,1);
length_measData=zeros(FrameNum,1);

yEnd2=59;
xEnd2=890;

yEnd1=55;

time=(1:FrameNum)./15000;
%%
% figure
% subplot(2,1,2)
% parfor ii=1:FrameNum
for ii=1152:1772%:10:FrameNum
%     axis equal
    try
    ii
    xEnd1=Clamp1Pos(ii)-15;
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
    imshow(s(ii).cdata)
    hold on
    plot([xEnd1 x xEnd2],[yEnd1 y yEnd2],'c.')
    plot([xEnd1 x1 xEnd2],[yEnd1 y1 yEnd2],'r.')
    hold off
    title([ii time(ii) length_measFit(ii)])
    % pause(0.01)
    end
end

%%
% length_measFit(1494:1505)=length_measFit(1493)
close all; hold on;
plot(length_measFit,'.')
plot(Clamp2Pos-Clamp1Pos+55)
timeImage=(1:FrameNum)/15000;
%%
LengthMM=length_measFit./7.5;
ClampDistMM=(Clamp2Pos-Clamp1Pos+55)./7.5;
csvwrite('Result5mmC.txt',[LengthMM,ClampDistMM',timeImage'])