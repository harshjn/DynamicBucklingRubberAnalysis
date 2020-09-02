% We will plot data and fitting on top of each other.

% This will help us in calculating the parameters to more accuracy
%% Experimental
A=importdata('10mm_c1.lvm');
time=A(:,1);
StressVoltsRaw=A(:,2);
PositionVoltsRaw=A(:,3);
StressFilt=StressFilterFunction(StressVoltsRaw,5e4);
PositionMM=PositionMap(PositionVoltsRaw,[]);
% plot(PositionMM)
% close all
%%
clf
figure(2)
StrainExp=(30-PositionMM)./30*0.43+0.013;
plot(time,StrainExp)
yyaxis right
% plot(time,StressFilt)
% title('Stress,Strain - experimental')
ForceN=0.01*StressV2Grams_Synapsis(StressFilt,mean(StressFilt(end-1e4:end)));
StressN=ForceN/1e-5;
plot(time,StressN)
% Theoretical Calculation %%%%%%%%
%%
syms a t s x
% close all
Speed=0.04; % 30 ms edge rise
Amp=0.44;
F1(t) = Amp/Speed*t*heaviside(t) - Amp/Speed*t* heaviside(t - Speed) + ...
 Amp * heaviside(t - Speed);
% fplot(F1(t),[-0.01 0.06])
% figure(1)
StrainTh(t)=F1(t-7.38)- F1(t-25.52);
% yyaxis left
% hold on
% fplot(StrainTh(t),[-1 46])
% Matching strains
timeExp=time;
hold on
scatter(timeExp,StrainExp)
fplot(StrainTh(t),[-1 46])
%%
figure(1)
hold on
% Eps(t)=0.5*(tanh(10*t) - tanh(10*t - 20))
c=3.3e5;
eta=0.1*3.05*c; E1=2.36*c; E2=2.42*c;
% eta=1*32.05*c; E1=1.36*c; E2=9.52*c;
tau=E2/eta
StressTh(t)= ilaplace(E1*(E2+eta*s)/(E1+E2+eta*s)*laplace(StrainTh(t)));
yyaxis right
StressExp=StressN;
scatter(timeExp,StressExp)
yyaxis right
fplot(StressTh(t),[-1 45],'b-.')
title('theoretical Stress Vs Experimental Data')
hold off