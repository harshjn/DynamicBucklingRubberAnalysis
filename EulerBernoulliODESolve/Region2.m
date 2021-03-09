% We try to numerically solve the differential equation.
clear all
close all
clc
clf

load('Data1.mat')
y0_ = y(end,:);
clearvars -except y0_
plot(y0_)
n=200
yIn = y0_;

% for i = n+1:2*n
%     yIn(i) = ( y0_(i)+y0_(end+1-n) )/2;
% end

% hold on
plot(yIn)
%%
global ncall  G ell ell0
% Independent variable for ODE integration
ncall=0;
% Initial condition
n=200;
MassPerLength = 0.01;
G = 3e6/MassPerLength;
w = 10e-3;
t = 1e-3;
I = w*t^3/12;
B = G*I;
A = w*t;
% gamma is typically 0.02
F = G*A*0.04;
ell0 = 100e-3;
ell = ell0
nMax = ell/pi*sqrt(F/B);
y0 =zeros(2*n,1);
% y0(2*n-n/2) = 1e-3;

for i = n+2:2*n-2
y0(i) = 0.0005*sin(20*pi*i/n);
end

y0(2:n-2) = y0(n+2:2*n-2)*1e-4;
% y0(2:n-2) = y0(n+2:2*n-2)*1e-4;

% y0(n+1:2*n)=y0_(n+1:2*n);

% y0 = yCondition
% for i = n+2:2*n-2
% y0(i) = 1e-5*sin(15*pi*i/(n));
% end
% y0(n+3:2*n-2) = 1e-7*(rand(n-4,1)-0.5);
% y0(n*3/2) = 0.00001*(rand(1)-0.5);
hold on
xMat = (1:n)/n*ell;
plot(y0(1:2*n))
xlabel('length')
ylabel('height')
hold off
% y0=yIn
%%
figure(2)
% ODE integration
tspan = [0 20e-3];
tmat = linspace(tspan(1),tspan(2),200);
Fmat = [linspace(5,1.2,200)];
nMax = ell/pi*sqrt(F/B);
clf
plot(Fmat)
%%
tic
% reltol=1.0e-09; abstol=1.0e-06;
% options=odeset('RelTol',reltol,'AbsTol',abstol);
% [t,y]=ode45(@(t,y) odeEulerBernoulli2(t,y,B_by_K,FbyKtMat,tMat,ell), tspan,y0,options);
[t,y]=ode45(@(t,y) odeEulerBernoulli5(t,y,Fmat,tmat,B), tspan,y0);

toc
%%
% contourf(y(:,n+1:2*n))

figure(1)
for ii = 1:1:length(t)
clf
plot(y(ii,n+1:2*n))
title(t(ii))
ylim([-0.03 0.03])

hold on
pause(0.1)
end

%%
xMat = (1:n)*ell/n;
clf
for jj = 1: size(y,1)
yInd = y(jj,n+1:2*n);
gammaMat(jj)   = (arclength(xMat,yInd)-ell)/ell;
end
plot(t,gammaMat)
%%
figure(2)
waterfall((y(1:1:end,n+1:2*n)))
view(10,100)

%