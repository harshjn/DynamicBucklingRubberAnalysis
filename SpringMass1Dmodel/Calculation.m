speedMat = 1e-3*1.33.^linspace(1,30,30) ;
% BMat = [1e-10 3e-10 6e-10 1e-9 3e-9 6e-9 1e-8 3e-8 6e-8 1e-7 3e-7 6e-7 1e-6 3e-6 6e-6 1e-5 3e-5 6e-5 1e-4 3e-4 6e-4 1e-3] ;
lengthsMatMin = zeros(size(speedMat));
lengthsMatMax = zeros(size(speedMat));
dt = 1e-5;
T=0.07;

tMat = 0: dt: T;

for i = 1:30
    clearvars -except dt tMat T speedMat i speedMat lengthsMatMin lengthsMatMax
    speed=speedMat(i);
    N=10;
    L=0.1;
    w = 1e-2; t = 1e-3; G = 3e6;
    kL=G*w*t/L;
    I = w*t^3/12;
    kT = G*I/L^3;
    gamma = 0.1;
    B=kL/1e1;

    % SpeedVar =1;
    % if SpeedVar ==1
    %     compressionFactor = 1 ; % Starting compression factor
    % else
    %     compressionFactor = 0.8 ;
    % end
    %%
    % Initial Condition
    StretchFactor = 1.15;
    x0=zeros(N,1);
    y0=zeros(N,1);
    x0(1)=0;
    x0(N)=StretchFactor*L;


    for n = 2:N-1
    x0(n) = (n-1)*StretchFactor*L/(N-1); 
    end
    % x0(3)=0.5
    y0(2:N-1)=(rand(N-2,1)-0.5)*1e-5;
    %%

    xMat=zeros(N,length(tMat));
    yMat= zeros(N,length(tMat));
    VxMat=zeros(N,length(tMat));
    VyMat=zeros(N,length(tMat));
    xMat(:,1) = x0;
    yMat(:,1) = y0;
    tInd = 2;
    %%
    tic()
    for tInd = tInd: T/dt    
        x(N) = x0(N) - speed*tInd*dt;
        compressionFactor = x(N)/L;
        xMat(2:N-1,tInd-1) = xMat(2:N-1,tInd-1)+(rand(N-2,1)-0.5)*1e-4;
    %     [X,V,F] = ODESolver_1DRubber(xMat(n,tInd-1),yMat(n,tInd-1),VxMat(n,tInd-1),VyMat(n,tInd-1));
        [X,V,F] = ODESolver_1DRubber(xMat(:,tInd-1),yMat(:,tInd-1),VxMat(:,tInd-1)...
            ,VyMat(:,tInd-1),L,N,dt,kL,kT,compressionFactor,gamma);

        VxMat(:,tInd) = V(:,1);
        VyMat(:,tInd) = V(:,2);
        xMat(:,tInd) = X(:,1);
        yMat(:,tInd) = X(:,2);
        tMat(tInd)
    end
    toc()

    %% Plot particles
figure(3)
IndexTime =6001;
tMat(IndexTime)
plot(xMat(:,IndexTime),yMat(:,IndexTime),'o-')
title(sprintf('Time= %.3f',tMat(IndexTime)))
%     xlim([-0.1 1])
ylim([-0.05 0.05])
fileName = strcat(string(speedMat(i)),'2.png');
%     saveas(gcf,fileName)
xlim([0 0.1])
%%
% close all
lengths2 = sum(sqrt(diff(yMat).^2 + diff(xMat).^2));
figure(1)
plot(tMat,smooth(lengths2,1))
yline(0.1,'--')
xlabel('time'); ylabel('length(mm)')
title(string(speedMat(i)))
ylim([0.06 0.115])
xlim([0 0.07])
%%
savefig(strcat(string(speed),'.fig'))
end