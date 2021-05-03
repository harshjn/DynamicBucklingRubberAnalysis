function [X,V,F] = ODESolver_1DRubber(x0,y0,Vx0,Vy0,L,N,dt,k,compressionFactor,gamma,B)

FxMat = zeros(N,1);
FyMat = zeros(N,1);
x1 = zeros(N,1);
y1 = zeros(N,1);
thetaLeft = zeros(N,1);
thetaRight = zeros(N,1);
dLeft  =  zeros(N,1);
dRight =  zeros(N,1);

for n = 2:N-1
% We can take values from previous iteration and calculate the new values.
    x1(n)  = x0(n) + Vx0(n) *dt;
    y1(n)  = y0(n) + Vy0(n) *dt;
    %BoundaryConditions
    x1(1) = 0; x1(N)=compressionFactor*L; y1(1) = 0; y1(N)= 0;
    
    dLeft(n)  = sqrt( (x0(n)-x0(n-1))^2  + ( y0(n) - y0(n-1) )^2 );
    dRight(n) = sqrt( (x0(n)-x0(n+1))^2  + ( y0(n) - y0(n+1) )^2 );
    thetaLeft(n)  = atan2( y0(n-1) - y0(n), x0(n) - x0(n-1) );
    thetaRight(n) = atan2( y0(n+1) - y0(n), x0(n+1) - x0(n) );

    % Order of spring force
    Elasticorder = 1;
    FxMat(n) = -k *( dLeft(n)-L/(N-1) ).^Elasticorder *cos(thetaLeft(n)) + ...
        k*( dRight(n)-L/(N-1) ) .^Elasticorder*cos(thetaRight(n)) - gamma*Vx0(n)   ;
    FyMat(n) = k *( dLeft(n)-L/(N-1) ).^Elasticorder*sin(thetaLeft(n)) + ...
        k*( dRight(n)-L/(N-1) ).^Elasticorder *sin(thetaRight(n))  - gamma*Vy0(n)  ;
    
   % Bending Force
    thetaLeft(n)  = pi - thetaLeft(n); % measured from +x axis, ACW
    if thetaRight(n)<0
        thetaRight(n) = 2*pi + thetaRight(n);
    end
    
    OrderBending=3;
    th = thetaRight(n)/2 + thetaLeft(n)/2;
    FyMat(n) = FyMat(n) + B*sin(th)* (pi- abs(thetaLeft(n) - thetaRight(n)))^OrderBending -5*dt.^2 ;
    FxMat(n) = FxMat(n) + B*cos(th)* (pi- abs(thetaLeft(n) - thetaRight(n)))^OrderBending;

%     FxMat(n) = FxMat(n) + B* (thetaLeft(n) + thetaRight(n) )^2 ;
%     FyMat(n) = FyMat(n) - B* (thetaLeft(n) + thetaRight(n) )^2;
%     
end

Vx1 = Vx0 + dt*FxMat;
Vy1 = Vy0 + dt*FyMat;
%BoundaryConditions
x1(1) = 0; x1(N)=compressionFactor*L;
y1(1) = 0; y1(N)= 0;
Vx1(1)= 0; Vx1(N)= 0;
Vy1(1)= 0; Vy1(N)= 0;

X=[x1 y1];
V=[Vx1 Vy1];
F=[FxMat FyMat];
%%
% figure(2)
% IndexTime = 340761
% plot(xMat(:,IndexTime),yMat(:,IndexTime),'o-')
% title(sprintf('Time= %.3f',tMat(IndexTime)))
% xlim([-0.1 1])
% ylim([-1 1])
end
