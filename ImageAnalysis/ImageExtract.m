vidObj=VideoReader('C:\Users\Admin\Desktop\DataAnalysis\5mmC.avi')

vidObj
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
'currTime',[]);
k = 1;
Fs=15000;
%%
startTime=450;endTime=vidObj.Duration;
vidObj.CurrentTime=1310;
s1 = imrotate(readFrame(vidObj),0.0);
imshow(s1)
hold on
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
% readFrame(vidObj);readFrame(vidObj);readFrame(vidObj);readFrame(vidObj);
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
save ImageData5mmC.mat s