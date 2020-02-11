clc
clear all
PathVideo='Y:\harsh\Harsh_Rubber\DataFeb\9Feb\10mm\';

PathDAQ='Y:\harsh\Harsh_Rubber\DataFeb\9Feb\10mm\';


DAQdata=importdata([PathDAQ '10mm_slow.lvm']);
timeDAQ=DAQdata(:,1);
StressDAQ=DAQdata(:,2);
StrainDAQ=DAQdata(:,3);

PathAnalysis='Y:\harsh\Harsh_Rubber\AnalysisFeb\9FebAnalysis\10mm\slow\'
fileVideo='10mm_slow';
[length_meas,Clamp1Pos,Clamp2Pos,time]=Length_Meas(PathVideo,fileVideo,PathAnalysis);

%%
close all
plot(time,length_meas)
hold on
yyaxis right
plot(time,700-Clamp1Pos)
