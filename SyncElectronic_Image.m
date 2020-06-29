%This function compares the position data from ImageData And Electronic Data

FileName='5mm_A_3'
Amat=importdata(strcat('',FileName,'.lvm'));
Fs=0.5e5;
figure; 
% timeElectronic=Amat(:,1);

StressVolts=StressFilterFunction(Amat(:,2),Fs);
plot(-1*StressVolts)
hold on
yyaxis right
StrainVolts=Amat(:,3);
StrainMM=29-StrainMap(StrainVolts,[]);
plot(StrainMM)
% PressureMat=PressureV2Bar(Amat(:,4));
% plot(PressureMat)
legend('stress','strain')
title(FileName)


%%
% close all
% figure
tDelay=0.01;
Range_=1518000:1.615e6;
StrainVoltsRaw=Amat(Range_,3);
StrainCalibrated=StrainMM(Range_)+1.2311;
timeElectronic=tDelay+(1:length(Range_))/5e4;
plot(timeElectronic,StrainCalibrated)
hold on
plot(timeImage,ClampDistmm-107.7+30)
xlim([0.15 0.25])

%%
figure
plot(timeImage,ClampDistmm)
hold on;
plot(timeImage, Lengthmm)

StressZeroVolts=mean(StressVolts(end-1e4:end));
yyaxis right
StressGramsFiltered=StressV2Grams_Synapsis(StressMat,StressZeroVolts);
plot(timeElectronic,StressGramsFiltered)
StressRawVolts=Amat(Range_,2);
StressRawGrams=StressV2Grams_Synapsis(StressRawVolts,StressZeroVolts);
hold on
scatter(timeElectronic,StressRawGrams,'.','MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
xlabel('time (in seconds)')
% 'MarkerFaceColor','b','MarkerEdgeColor','b',    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2


%%

csvwrite('Image5mmAData.txt',[Lengthmm,ClampDistmm,timeImage'])

csvwrite('Electronic5mmAData.txt',[Lengthmm,ClampDistmm,timeImage'])

