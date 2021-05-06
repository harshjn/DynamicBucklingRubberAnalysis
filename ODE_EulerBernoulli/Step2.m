% We try to numerically solve the differential equation.
clear all
close all
clc
clf
% load('Chirp1.mat')

load('Step1.mat')
y0_ = y(end,:);
clearvars -except y0_
plot(y0_)
n=512
yIn = y0_;


n=512
y0=yIn;%(2:end-1)
y0(n+1:2*n) = y0(n+1:2*n)+0.5e-3*(rand(n,1)-0.5)';
% y0(1.5*n) = y0(1.5*n)+random
plot(y0)
%%
global ncall  G d0 Fmat_ tMat_ lMat_ rho
% Independent variable for ODE integration
ncall=0;
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
d0 = 100e-3;


%%
tmat=linspace(0,12e-3,1000);
tau = 1e-4;
Fmat =  -1.5*exp(-tmat./tau) ;

v=1;
Dmat = 0.095*ones(size(tmat))-v*tmat;
subplot(2,1,1)
plot(tmat,Dmat)
ylabel('D(t)'); xlabel('time')
% clf
subplot(2,1,2)

plot(tmat,Fmat)
ylabel('F'); xlabel('time')

%%
tic
reltol=1.0e-6; abstol=1.0e-6;
options=odeset('RelTol',reltol,'AbsTol',abstol);
% [t,y]=ode45(@(t,y) odeEulerBernoulli2(t,y,B_by_K,FbyKtMat,tMat,ell), tspan,y0,options);
noise = 1e-7;
[t,y]=ode23(@(t,y) odeEulerBernoulli4(t,y,Fmat,Dmat,tmat,G,I,A,v), [tmat(1) tmat(end)],y0);

toc
%
%%
close all
figure(1)
plot(tMat_,Fmat_,'.')
title('Force')
%%
figure(2)
plot(tMat_,lMat_)
title('Length of strip l')
ylim([0 0.2])
%%
figure(3)
waterfall(y(1:10:end,n+1:2*n))
view(10,100)
%%

y_=zeros(size(y,1),n);
for i = 1: length(t)
    y_(i,:) = smooth(y(i,n+1:2*n),30);
end




v=1;
dMat = zeros(length(t),512);
for i = 1: length(t)
    dMat(i,:) =linspace(0,0.095-v*t(i),512);
end
figure(1)
% subplot(2,1,2)
% clf
tMat = repmat(t,512,1)';
% plot(y__(8090,:))
for i = 1: length(t)
    LengthMat(i) = arclength(dMat(i,:),y_(i,:));
end
% %%
% plot(t,LengthMat)
% hold on
% plot(tMat_,lMat_)
% ylim([0.09 0.12])