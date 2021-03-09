function [length_meas,Clamp1Pos,Clamp2Pos,time]=Length_Meas(PathVideo,Filename,PathAnalysis)


try
    Processed=1;
    load([PathAnalysis Filename '.mat']);
catch
    Processed=0;
end

if Processed ==1
    
    return
end


%%

vidObj=VideoReader([PathVideo Filename '.avi'])

vidObj
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
'currTime',[]);
k = 1;
Fs=15000;
%%
startTime=0;endTime=vidObj.Duration;
vidObj.CurrentTime=141;
s1 = imrotate(readFrame(vidObj),0.0);
imshow(s1)
%%
% s(k).currTime=vidObj.CurrentTime;
% imshow(s1(:,:,2))
s2=s1(:,:,1);
imshow(s2)
%%
k=1;
vidObj.CurrentTime=startTime;
while vidObj.CurrentTime<endTime
% vidObj.hasFrame
s1 = imrotate(readFrame(vidObj),0.0);
% s(k).currTime=vidObj.CurrentTime;
% imshow(s1(:,:,2))
s2=s1(:,:,1);
s(k).cdata = s2;
s(k).currTime=vidObj.CurrentTime;
% imshow(s(k).cdata)
k = k+1
end
%%
FrameNum=k-1;
xMAT=zeros(vidWidth,1,FrameNum);
yMAT=xMAT;
for num=1:FrameNum
    xMat=1:1:vidWidth; 
    yMat=zeros(1,vidWidth);
    for j=1:vidWidth
        im1=s(num).cdata;
        im1(160:240,1:372)=0;
        [val,yMat(j)]=max(im1(:,j));
    end
    xMAT(:,:,num)=xMat';
    yMAT(:,:,num)=yMat';
end

%% detecting clamps
kk=3270;
imgData=s(kk).cdata;
% imshow(imgData)
imgData_=imgData;
imgData_(160:240,1:372)=0;
imgData_(29:50,329:385)=0;

% [~,Y1]=max(imgData_);
% hold on
% % figure
% plot(Y1)
% figure
P1=sum(imgData(210:240,1:400))/31;
plot(P1)

% figure;
% imshow(imgData_)
%%
% First we ignore the points above a cutoff not of interest to us
length_meas=zeros(1,FrameNum-1);
Clamp1Pos=zeros(1,FrameNum-1);
Clamp2Pos=zeros(1,FrameNum-1);
MeanWidth=zeros(1,FrameNum-1);
MeanStdWidth=zeros(1,FrameNum-1);
StdMeanWidth=zeros(1,FrameNum-1);

%%
parfor ii=2000:6500   %1:1:FrameNum
    ii
    imgData=s(ii).cdata;
    imgData_=imgData;
    imgData_(160:240,1:372)=0;
    imgData_(29:53,1:385)=0;
    [~,Y1]=max(imgData_);
    % Then we set the starting and the end points.
    Y2=Y1;
%     plot(Y2)
    try
        P1=sum(imgData(210:240,1:400))/31;
        [~,locs,widths,proms]=findpeaks(-1*P1);
        indMat=find(proms>30 & widths<10);
        YHigh1=locs(indMat(end));
        pause(0.01);
%         YHigh2=find(imgData(210,vidWidth/2:end)>40);
    catch
%         YHigh1=find(sum(imgData(210:240,1:400))/31>40);

        YHigh1=1;
%         YHigh2=vidWidth;
    end
    clamp1=YHigh1(end)+10;
    clamp2=880;
    Clamp1Pos(ii)=clamp1;
    Clamp2Pos(ii)=clamp2;
    imshow(s(ii).cdata)
    hold on

%     plot(Y1);
%     scatter(clamp2,Y1(clamp2))
%     scatter(clamp1,Y1(clamp1))
%     hold off
    % Now we measure the Lengths with arclength
%     YCrop=Y2(clamp1:clamp2-2);
%     YCrop3=YCrop;
% 
%     XCrop=clamp1:clamp2-2;
%     x = XCrop;
%     y = YCrop3;
%     p = polyfit(x,y,25);
%     x1 = linspace(XCrop(1),XCrop(end));
%     y1 = polyval(p,x1);
%     % figure
%     imshow(s(ii).cdata)
%     hold on
%     plot(x,y,'c.')
%     plot(x1,y1,'k-')
%     % hold off
%     length_meas(ii)=arclength(x1,y1);
%     title([ii length_meas(ii)])
%     pause(0.05)
%     close all

end
%%


for ii=1:1:FrameNum-1
    ii
    imgData=s(ii).cdata;
    yiMat=zeros(size(imgData,2),1);
    yiMat2=zeros(size(imgData,2),1);

    Norm_=mean(maxk(imgData,5));
    for yi=Clamp1Pos(ii):Clamp2Pos(ii)
        yiMat(yi)=mean(imgData(:,yi));
%         yiMat2(yi)=std(double(imgData(:,yi)));
    end
	Norm_=mean(maxk(imgData,10));
    y_=yiMat./Norm_';
%     y_2=yiMat2;%./Norm_';
%     MeanWidth(ii)=mean(y_(y_<0.2 & y_>0));
% 	MeanStdWidth(ii)=mean(y_2(y_<0.2 & y_>0));
    StdMeanWidth(ii)=std(yiMat(y_<0.2 & y_>0));



end  



%%
% close all
figure
plot(time,length_meas,'.')
hold on

plot(time,Clamp2Pos-Clamp1Pos)
% set(gca, 'XScale', 'log')
yyaxis right
% plot(time,MeanStdWidth)
hold on
plot(time,StdMeanWidth)

legend('Contour length','ClampDistance','StdMeanWidth')
%%
figure;
plot(widMat(1341,:))
hold on
plot(widMat(1121,:))


%%
time=(1:length(length_meas))./Fs;
% Addr_file='Y:\harsh\Harsh_Rubber\AnalysisJanuary\LengthBump\DataOctober\8to5cmData\'
% save([PathAnalysis Filename '.mat'], 'Clamp1Pos','Clamp2Pos','length_meas','time')
%%
close all
plot(time-0.17,smooth(length_meas,15)./7,'.')
hold on
% yyaxis right
plot(time-0.17,smooth(Clamp2Pos-Clamp1Pos,15)./7)
set(gca, 'XScale', 'log')
yline(586.4/7)
end