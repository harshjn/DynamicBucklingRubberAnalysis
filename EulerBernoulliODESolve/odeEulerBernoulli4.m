%% We input y(x) and write down the coupled differential equation in time.
%% Boundary Condition: y0 = y'0 = y''0 = y'''0 = 0
% Boundary Condition: yN = y'N = y''N = y'''N = 0
% Boundary Condition: y''''N =y''''0 = 0
%% We use these boundary conditions to evaluate the D2y and D4y
function dydt = odeEulerBernoulli4(t,y,Fmat,tmat,B,ell)
global ncall d0 ell F0 Fmat_
global G
n=length(y)/2;
dydt = zeros(2*n,1);

% dx=abs((xu-xl)/(n-1));
D2y = zeros(n,1);
D4y = zeros(n,1);

F = interp1(tmat,Fmat,t);

xInd = length(y)/2+1:length(y);
xMat = (1:n )*d0/n;

lnew = arclength(xMat,y(xInd));
gamma      = (lnew-ell)/ell;
gamma %print
t

if lnew < d0/0.9
    ell = lnew;
else
    F = F - G*gamma;
end

if (F<0)
    F=0.01*F0;
end
Fmat_(end+1) = F;
nmax = ell/pi*sqrt(F/B)
xbar = 3/n*d0;
xMat = [1 2 3 4 5]/n*d0;
Coeff_D2    = fdcoeffF(2,xbar,xMat);
Coeff_D4    = fdcoeffF(4,xbar,xMat);
for i = 3:n-3
    D2y(i)     = sum(Coeff_D2.*[y(i-2) y(i-1) y(i) y(i+1) y(i+2)]);
    D4y(i)     = sum(Coeff_D4.*[y(i-2) y(i-1) y(i) y(i+1) y(i+2)]);
end
% for i = [2, n-2]
%     xbar = i/n;
%     xMat = [i-1 i i+1]/n;
%     Coeff_D    = fdcoeffF(2,xbar,xMat);
%     D2y(i)     = sum(Coeff_D(:,2).*[y(i-1) y(i) y(i+1)]');
% end
dydt(n+1:2*n) = -F*D2y - B* D4y;
dydt(1:n) = y(n+1:2*n);
% dydt(2*n) = 0;
% dydt(n+1) = 0;
% dydt(1)   =0;
% dydt(n) = 0;
ncall=ncall+1;