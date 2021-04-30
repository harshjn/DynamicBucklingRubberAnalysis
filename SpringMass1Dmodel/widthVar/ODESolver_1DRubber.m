function [X,V,F] = ODESolver_1DRubber(x0,y0,Vx0,Vy0,L,N,dt,w,kL,kT,compressionFactor,gamma)

FxMat = zeros(N,1);
FyMat = zeros(N,1);
x1 = zeros(N,1);
y1 = zeros(N,1);
thetaLeft = zeros(N,1);
thetaRight = zeros(N,1);
dLeft  =  zeros(N,1);
dRight =  zeros(N,1);
%%
for n = 2:N-1
% We can take values from previous iteration and calculate the new values.
    if x0(n)<x0(n-1)
        x0(n) = x0(n-1)+L/(N-1)*rand(1);
    elseif x0(n)>x0(n+1)
        x0(n) = x0(n+1)-L/(N-1)*rand(1);
    end

    x1(n)  = x0(n) + Vx0(n) *dt;
    y1(n)  = y0(n) + Vy0(n) *dt;
    
%     if x1(n)<x1(n-1)
%         x1(n) = x1(n-1)+L/(N-1)*0.1;
%     elseif x1(n)>x1(n+1)
%         x1(n) = x1(n+1)-L/(N-1)*0.1;
%     end
    %BoundaryConditions
    x1(1) = 0; x1(N)=compressionFactor*L; y1(1) = 0; y1(N)= 0;
    
    pt     = [x0(n), y0(n)];
    ptLeft = [x0(n-1), y0(n-1)];
    ptRight = [x0(n+1),y0(n+1)];
    
    a = ptRight-ptLeft;
    slope1 = a(2)/a(1);
    slope2 = -1/slope1;
    pt2 = pt+[1,slope2];
    dLeft(n)  = sqrt( (x0(n)-x0(n-1))^2  + ( y0(n) - y0(n-1) )^2 );
    dRight(n) = sqrt( (x0(n)-x0(n+1))^2  + ( y0(n) - y0(n+1) )^2 );
    thetaLeft(n)  = atan2( y0(n-1) - y0(n), x0(n) - x0(n-1) );
    thetaRight(n) = atan2( y0(n+1) - y0(n), x0(n+1) - x0(n) );

    try
        P = InterX([pt(1), pt2(1);pt(2), pt2(2)],[ptLeft(1),ptRight(1);ptLeft(2),ptRight(2)]);
        theta(n)  = atan2( P(2) - pt(2), P(1) - pt(1) );
%         '111'
    catch
        theta(n) =0;
        P = pt;
%         '000'
    end
    t_dist = sqrt( (P(1) - pt(1))^2 + (P(2) - pt(2))^2);
    % Order of spring force
    Elasticorder = 1;
    FxMat(n) = -kL *( dLeft(n)-L/(N-1) ).^Elasticorder *cos(thetaLeft(n)) + ...
        kL*( dRight(n)-L/(N-1) ) .^Elasticorder*cos(thetaRight(n)) - gamma*Vx0(n)   ;
    FyMat(n) = kL *( dLeft(n)-L/(N-1) ).^Elasticorder*sin(thetaLeft(n)) + ...
        kL*( dRight(n)-L/(N-1) ).^Elasticorder *sin(thetaRight(n))  - gamma*Vy0(n)  ;
 %%   
   % Bending Force
%     OrderBending=1;
%     th = thetaRight(n)/2 + thetaLeft(n)/2;
    g=10; % Gravity
    % The mass of strip is around 1g = 1e-3;
    M=(1e-3/N)*w/1e-2;
    FyMat(n) = FyMat(n) + kT*t_dist*sin(theta(n)) - M*g ; 
    FxMat(n) = FxMat(n) + kT*t_dist*cos(theta(n))    ;

%     FxMat(n) = FxMat(n) + B* (thetaLeft(n) + thetaRight(n) )^2 ;
%     FyMat(n) = FyMat(n) - B* (thetaLeft(n) + thetaRight(n) )^2;
%     
end

Vx1 = Vx0 + dt*FxMat/M;
Vy1 = Vy0 + dt*FyMat/M;
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
