function yOut = PositionMap(PositionVolts,MaxMin)

% Here we convert Voltage data from a log potentiometer into Position Mapping

% MaxMin=[max(StrainVolts) min(StrainVolts)];
% DaqData=importdata('Y:\harsh\Harsh_Rubber\DataMarch\StrainCalibration.lvm');
% StrainData=DAQData(:,3);
% StrainFilt=(StressFilterFunction(StrainData,5000));
% plot(StrainFilt)
% 
if isempty(MaxMin)
    Max=9.9;
    Min=2.65;
else
    Max=MaxMin(1);
    Min=MaxMin(2);

end
DistMat=linspace(0,31,32);

% Max=9.8828; Min=2.7049;
A=[Max 9.8828 9.8668 9.8446 9.8231 9.7986 9.7568 9.7062 9.657 9.6047 9.5576 ...
    9.5093 9.4269 9.1706 8.8083 8.4439 8.0972 7.7277 7.37 7.0026 ...
    6.638 6.284 5.9173 5.5564 5.1887 4.8257 4.4428 4.08 3.7272 3.3631 3.0191 Min ]; 



sprintf('Output in mm from Volts')
yOut=interp1(A,DistMat,PositionVolts);
end
