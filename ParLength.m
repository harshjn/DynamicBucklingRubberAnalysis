%% Parallel length calculate on HPC
parpool(32);
load("ImageData2mmA.mat")
FrameNum=length(s);
widMat=zeros(FrameNum,896);
pklocs=zeros(FrameNum,896);
yWaterfall=zeros(FrameNum,896);
yFitMat=zeros(FrameNum,896);
length_meas=zeros(FrameNum,1);
length_measData=length_meas;
length_measFit=length_meas;
widthMat=zeros(FrameNum,896);
time=(1:FrameNum)./15000*5;
%%

parfor ii=1:1:FrameNum
    ii
    imgData=s(ii).cdata;
    imgData_=imgData;
    imgData_(160:248,1:372)=0;
    imgData_(29:69,1:385)=0;
    [~,Y1]=max(imgData_);
    % Then we set the starting and the end points.
    Y2=Y1;
%     plot(Y2)
    try
        P1=sum(imgData(210:240,1:400))/31;
        [~,locs,widths,proms]=findpeaks(-1*P1);
        indMat=find(proms>30 & widths<10);
        YHigh1=locs(indMat(end))+15;
%         pause(0.01);
%         YHigh2=find(imgData(210,vidWidth/2:end)>40);
    catch
%         YHigh1=find(sum(imgData(210:240,1:400))/31>40);

        YHigh1=1;
%         YHigh2=vidWidth;
    end
    clamp1=YHigh1(end)+20;
    clamp2=842;
    Clamp1Pos(ii)=clamp1;
    Clamp2Pos(ii)=clamp2;

end
%%
tic

parfor ii=1:1:FrameNum
% for ii=2300
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
    clamp2=850;
    Clamp1Pos(ii)=clamp1;
    Clamp2Pos(ii)=clamp2;

end
%%
tic
% imat=3000:100:5000

parfor ii =1:FrameNum
%     try
    ii
    imgData=s(ii).cdata;
    imgData_=imgData;
    imgData_(160:248,1:372)=0;
    imgData_(29:69,1:385)=0;
    pklocsii=zeros(1,896);
%     yiMat=zeros(size(imgData,2),1);
%     widMat=zeros(size(imgData,2),1);
    
    for yi=Clamp1Pos(ii):Clamp2Pos(ii)
        yiMat=(imgData_(:,yi));
%         yiMat2(yi)=std(double(imgData(:,yi)));
        [pks,locs,widths,proms]=findpeaks(double(yiMat));
        [val,ind]=max(pks);
%         pklocsii(yi)=locs(ind);
%         widMat(ii,yi)=widths(ind);
        yiStart=ceil(locs(ind)-3.*widths(ind));
        if yiStart <1
            yiStart=1
        end
		
        yiEnd=ceil(locs(ind)+3.*widths(ind));
        if yiEnd > 240
            yiEnd=240
        end
        Mat_=yiMat(yiStart:yiEnd);
        
		x=1:length(Mat_);
        y=double(Mat_);
        f = fit(x',y,'gauss1');
        pklocsii(yi)=yiStart+abs(f.b1);        
        
    end
    % measure length
    x = Clamp1Pos(ii):Clamp2Pos(ii);
    y_ = pklocsii(:);
    yWaterfall(ii,:)=y_;
    y=y_(y_>0);
    p = polyfit(x,y',25);
    x1 = linspace(x(1)-1,x(end)+1);
    y1 = polyval(p,x1);
    % figure
%     imshow(s(ii).cdata)
%     hold on
%     plot(x,y,'c.')
%     plot(x1,y1,'r-')
    % hold off
    length_meas(ii)=arclength(x1,y1);
%     length_meas(ii)=arclength(x,y'); 

%     title([time(ii) length_meas(ii)])

%     pause(0.05)
end
% end
toc
%%
close all
plot(length_meas)
hold on
plot(Clamp2Pos-Clamp1Pos)
saveas(figure(1),'Result2.jpg')
save DataResults2.mat 
