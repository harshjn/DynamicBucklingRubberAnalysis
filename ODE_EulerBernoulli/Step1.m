% We try to numerically solve the differential equation.
clear all
close all
clc
%%
global  G d0 Fmat_ tMat_ lMat_ rho
% Independent variable for ODE integration
% ncall=0;
% Initial condition
n=512;
rho =1000;
G = 3e6;
w = 10e-3;
t = 1e-3;
I = w*t^3/12;
A = w*t;
Fmat_=[];
tMat_ =[];
lMat_ =[];
% ell = d0;
y0 =zeros(2*n,1);

y0(n*3/2) = 1e-5*(rand(1)-0.5);
d0 = 100e-3; %Length of strip ~ 10cm

%% Set F
figure(2)
% ODE integration
tmat = linspace(0,5.16e-3,10000);

v=1;
Dmat = 0.1*ones(size(tmat))-v*tmat;
subplot(2,1,1)
plot(tmat,Dmat)
ylabel('D(t)'); xlabel('time')
% clf
subplot(2,1,2)
gamma = (Dmat(end)-Dmat(1))/Dmat(1);
Fmat = linspace(0,gamma*G*A,length(tmat)) ;

plot(tmat,Fmat)
ylabel('F'); xlabel('time')



%%
tic
reltol=1.0e-9; abstol=1.0e-9;
options=odeset('RelTol',reltol,'AbsTol',abstol);
% [t,y]=ode45(@(t,y) odeEulerBernoulli2(t,y,B_by_K,FbyKtMat,tMat,ell), tspan,y0,options);
noise = 1e-7;
[t,y]=ode23s(@(t,y) odeEulerBernoulli4(t,y,Fmat,Dmat,tmat,G,I,A,v), [tmat(1) tmat(end)],y0);

toc

%%
close all
figure(1)
plot(tMat_,Fmat_,'.')
title('Force')
%%
figure(2)
plot(tMat_,lMat_,'.')
title('Length of strip l')
%%
figure(3)
waterfall(y(1:10:end,n+1:2*n))
view(10,100)
%%
%   
% figure(3)
% waterfall(y(1:1:833,n+1:2*n))
% view(10,100)
% %% 
% close all
% Y = fft(y(end,n+1:2*n));
% Fs = 1000;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 512;             % Length of signal
% t = (0:L-1)*T;        %
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
