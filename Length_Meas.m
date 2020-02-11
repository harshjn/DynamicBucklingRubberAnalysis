function [length_meas,Clamp1Pos,Clamp2Pos,time]=Length_Meas(Path,Filename,PathAnalysis)


try
    Processed=1;
    load([Path Filename '.mat']);
catch
    Processed=0;
end

if Processed ==1
    
    return
end


%%

vidObj=VideoReader([Path Filename '.avi'])

vidObj
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
'currTime',[]);
k = 1;
Fs=15000;
%%
startTime=1000;endTime=1270;
vidObj.CurrentTime=1070;
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

FrameNum=k-1;
xMAT=zeros(vidWidth,1,FrameNum)
yMAT=xMAT;
for num=1:FrameNum
    xMat=1:1:vidWidth; 
    yMat=zeros(1,vidWidth);
    for j=1:vidWidth
        im1=s(num).cdata;
        [val,yMat(j)]=max(im1(:,j));
    end
    xMAT(:,:,num)=xMat';
    yMAT(:,:,num)=yMat';
end

XYZ=zeros(vidWidth,vidHeight,FrameNum);
YWaterfall=[];
size(XYZ(:,:,1))
for jj=1:FrameNum
    Z=jj*ones(vidWidth,1);
    X=xMAT(:,:,jj);
    Y=yMAT(:,:,jj);
    YWaterfall(jj,:)=Y;
    clr = jet;
%     scatter3(X,Z,Y,5,2*Y)
%     hold on
%     colormap(jet);
%     colorbar;
end
% xlabel('x')
% ylabel('y')
% zlabel('z')

% waterfall(YWaterfall)
%% Setting the cutoffs to detect ends
kk=934;
imshow(s(kk).cdata)
hold on
plot(YWaterfall(kk,:))
%% detecting clamps

kk=26;
imgData=s(kk).cdata;
imshow(imgData)
hold on
% figure
plot(imgData(200,:))

%%
% First we ignore the points above a cutoff not of interest to us

length_meas=zeros(1,FrameNum-1);
Clamp1Pos=zeros(1,FrameNum-1);
Clamp2Pos=zeros(1,FrameNum-1);
%%
for ii=1:FrameNum-1
ii
    imgData=s(ii).cdata;
    Y1=YWaterfall(ii,:);
    % Then we set the starting and the end points.
    Y2=YWaterfall(ii,1:end);
    plot(Y2)
    try
        YHigh1=find(imgData(200,1:vidWidth/2)>40);
        YHigh2=find(imgData(200,vidWidth/2:end)>40);
    catch
        YHigh1=1;
        YHigh2=vidWidth;
    end
    clamp1=YHigh1(end)-10;
    clamp2=vidWidth/2+YHigh2(1)+10;
    Clamp1Pos(ii)=clamp1;
    Clamp2Pos(ii)=clamp2;
    imshow(s(ii).cdata)
    hold on

    plot(Y1);
    scatter(clamp2,Y1(clamp2))
    scatter(clamp1,Y1(clamp1))
    hold off
    % Now we measure the Lengths with arclength
    YCrop=Y2(clamp1:clamp2-2);
    YCrop3=YCrop;

    XCrop=clamp1:clamp2-2;
    x = XCrop;
    y = YCrop3;
    p = polyfit(x,y,15);
    x1 = linspace(XCrop(1),XCrop(end));
    y1 = polyval(p,x1);
    % figure
    imshow(s(ii).cdata)
    hold on
    plot(x,y,'o')
    plot(x1,y1)
    % hold off
    length_meas(ii)=arclength(x1,y1);
    title([ii length_meas(ii)])
%     pause(0.1)
    % close all
end

%%
% close all
% plot(length_meas,'.')

% yyaxis right
% plot(700-Clamp1Pos)
time=(1:length(length_meas))./Fs;
% Addr_file='Y:\harsh\Harsh_Rubber\AnalysisJanuary\LengthBump\DataOctober\8to5cmData\'
save([PathAnalysis Filename '.mat'], 'Clamp1Pos','Clamp2Pos','YWaterfall','length_meas','time')

end
