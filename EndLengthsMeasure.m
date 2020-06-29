%% Set the end points of your strip and measure length

length_measFit=zeros(FrameNum,1);
length_measData=zeros(FrameNum,1);

%%
% figure

yEnd2=75;
xEnd2=878;

yEnd1=78;
subplot(5,1,1)
for ii=287
    
ii
xEnd1=Clamp1Pos(ii)-15;

jj=25;
y_=yWaterfall(ii,:);
x = Clamp1Pos(ii)+jj:Clamp2Pos(ii);
y=y_(y_>0);

y=y(jj+1:end);
p = polyfit(x,y,25);
x1 = linspace(x(1),x(end),(x(end)-x(1))/4);
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
pause(0.01)

end
%%
figure;
for ii = 2000: 5000
y_=yWaterfall(ii,:);
x = Clamp1Pos(ii):Clamp2Pos(ii);
y=y_(y_>0);
imshow(s(ii).cdata)
hold on
plot(x,y,'c.')
title(ii)
pause(0.01)
end
%%
figure
plot(length_measData)

hold on; plot(length_measFit)
yyaxis right; plot(mean(widMat,2))
hold on
yyaxis left; plot(Clamp2Pos-Clamp1Pos-jj)
