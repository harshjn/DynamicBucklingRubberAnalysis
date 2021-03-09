% We try to numerically solve the differential equation.
clear all
clc
clf
%%
global ncall  G d0 ell F0 Fmat_
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
F0 = G*A*0.1;
F=F0;
Fmat_=[];
d0 = 100e-3;
% ell = d0;
y0 =zeros(2*n,1);
% y0(2*n-n/2) = 1e-3;
% for i = n+n/4:2*n-n*5/12
% y0(i) = 0.0001*sin(6*pi*i/n)+0.0001;
% end

% for i = n+2:2*n-2
% y0(i) = 1e-5*sin(15*pi*i/(n));
% end
y0(n+3:2*n-2) = 1e-7*(rand(n-4,1)-0.5);
% y0(n*3/2) = 0.00001*(rand(1)-0.5);

xMat = (1:n)/n*d0;
plot(xMat,y0(n+1:2*n))
xlabel('length')
ylabel('height')
ell = arclength(xMat,y0(n+1:2*n));
nMax = ell/pi*sqrt(F/B);

%% Set F
figure(2)
% ODE integration
tspan = [0 5e-3];
tmat = linspace(tspan(1),tspan(2),1200);
Fmat = [linspace(0,F,200) linspace(F,F,100) linspace(F,-F,900) ];
clf
plot(tmat,Fmat)

%%
tic
reltol=1.0e-06; abstol=1.0e-06;
options=odeset('RelTol',reltol,'AbsTol',abstol);
% [t,y]=ode45(@(t,y) odeEulerBernoulli2(t,y,B_by_K,FbyKtMat,tMat,ell), tspan,y0,options);
[t,y]=ode45(@(t,y) odeEulerBernoulli4(t,y,Fmat,tmat,B,ell), tspan,y0);

toc
%%
% contourf(y(:,n+1:2*n))
figure(1)
for ii = 1:10:length(t)
clf
plot(y(ii,n+1:2*n))
title(t(ii))
ylim([-0.1 0.1])

hold on
pause(0.01)
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
waterfall(y(1:10:1000,n+1:2*n))
view(10,100)

%