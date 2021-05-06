%% We input y(x) and write down the coupled differential equation in time.
%% Boundary Condition: y0 = y'0 = y''0 = y'''0 = 0
% Boundary Condition: yN = y'N = y''N = y'''N = 0
% Boundary Condition: y''''N =y''''0 = 0
%% We use these boundary conditions to evaluate the D2y and D4y
function dydt = odeEulerBernoulli4(t,y,Fmat,Dmat,tmat,G,I,A,v)
global ncall d0 Fmat_ tMat_ lMat_ rho

% rho = 1000;
n=length(y)/2;
dydt = zeros(2*n,1);

% dx=abs((xu-xl)/(n-1));
D2y = ones(n,1);
D4y = ones(n,1);

F = interp1(tmat,Fmat,t);
D_t = interp1(tmat,Dmat,t);
l_exact = arclength( linspace(0,D_t,n),y(n+1:2*n) )

Fmat_(end+1) = F;
tMat_(end+1) = t;
lMat_(end+1) = l_exact;
nmax = d0/pi*sqrt(abs(F)/G/I)
t


xbar = 3/n;
xMat = [1 2 3 4 5]/n;
Coeff_D2    = fdcoeffF(2,xbar,xMat) ;
Coeff_D4    = fdcoeffF(4,xbar,xMat) ;
for i = 3:n-2
    D2y(i)   = sum(Coeff_D2.*[y(i-2) y(i-1) y(i) y(i+1) y(i+2)]) ;
    D4y(i)   = sum(Coeff_D4.*[y(i-2) y(i-1) y(i) y(i+1) y(i+2)]) ;
end

D4y(1)= 0;%sum(Coeff_D4.*[y(n-1) y(n) y(1) y(2) y(3)]) ; (Periodic BC commented out)
D4y(2)= 0;%sum(Coeff_D4.*[y(n) y(1) y(2) y(3) y(4)]) ; 
D4y(n-1)= 0;%sum(Coeff_D4.*[y(n-3) y(n-2) y(n-1) y(n) y(1)]) ; 
D4y(n)  = 0;%sum(Coeff_D4.*[y(n-2) y(n-1) y(n) y(1) y(2)]) ; 

D2y(1)= 0;%sum(Coeff_D2.*[y(n-1) y(n) y(1) y(2) y(3)]) ;
D2y(2)= 0;%sum(Coeff_D2.*[y(n) y(1) y(2) y(3) y(4)]) ; 
D2y(n-1)= 0;%sum(Coeff_D2.*[y(n-3) y(n-2) y(n-1) y(n) y(1)]) ; 
D2y(n)  = 0;%sum(Coeff_D2.*[y(n-2) y(n-1) y(n) y(1) y(2)]) ; 


dydt(n+1:2*n) = F/(rho*A*D_t^2)*D2y - G*I/(rho*A*D_t^4)* D4y;
dydt(n+1:2*n) = dydt(n+1:2*n);%+1e-2*(rand(n,1)-0.5);
% nRand = n+randi(n);
% dydt(nRand) = dydt(nRand) +noise;
dydt(1:n) = y(n+1:2*n);
ncall=ncall+1;