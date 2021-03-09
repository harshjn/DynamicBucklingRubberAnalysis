function [StressGrams] = StressV2Grams_Synapsis(V_Val,ZeroV)

% ZeroV=0; 
STD= 0.001; %Error
Slope=-2.6859e3;
StressGrams=((V_Val-ZeroV)*Slope);
% ZeroV can change with experiment. Slope will not change.
weight=[0.7 1.55 2.05 3.15 4.2];
Volts=[-0.18 -0.508 -0.69 -1.09 -1.49];

% plot(weight,Volts,'.')
sprintf('output in grams. Positive voltage is compression, Negative is stretch of load cell')
end