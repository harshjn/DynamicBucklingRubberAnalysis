speedMat = 0.5 ;
Bmat = [1e-7 :1e-7:1e-5 ] ;
lengthsMatMin = zeros(size(Bmat));
lengthsMatMax = zeros(size(Bmat));

for i = 10
    clearvars -except speedMat i Bmat lengthsMatMin lengthsMatMax
    speed=speedMat(1);
    N=40;
    dt= 1e-4;
    T =  20;
    L =  0.1;
    k= 300 * N ;
    B = k * Bmat(i) *N

    tMat = 0: dt: T;
    xMat = zeros(N,length(tMat));
    yMat = zeros(N,length(tMat));
    gamma = 5;
    compressionFactor = 1.5;
    
    xMat(1,:) = 0;
    xMat(N,:) = L;
    yMat(1,:) = 0;
    yMat(N,:) = 0;
    %%
    % Calculate all forces
    x0=zeros(N,1);
    y0=zeros(N,1);
    x0(1)=0;
    x0(N)=compressionFactor*L;
    for n = 2:N-1
    x0(n) = (n-1)*compressionFactor*L/(N-1); 
    end
    % x0(3)=0.5
    y0=rand(N,1)*1e-9;
    %%
    xMat=zeros(N,length(tMat));
    yMat= zeros(N,length(tMat));
    VxMat=zeros(N,length(tMat));
    VyMat=zeros(N,length(tMat));
    xMat(:,1) = x0;
    yMat(:,1) = y0;
    tInd = 2;
    %% Set middle condition
    % tInd = IndexTime
    % xMat=xMat(:,IndexTime)
    % yMat=yMat(:,IndexTime)
    %%
    tic()
    for tInd = tInd: T/dt
        if compressionFactor >0.8
            compressionFactor = 1.5-speed*tMat(tInd);
        end

    %     if tInd==T/dt/30
    %         yMat(:,tInd-1) = yMat(:,tInd-1)+randn(N,1)*1e-9;
    %     end

    %     [X,V,F] = ODESolver_1DRubber(xMat(n,tInd-1),yMat(n,tInd-1),VxMat(n,tInd-1),VyMat(n,tInd-1));
        [X,V,F] = ODESolver_1DRubber(xMat(:,tInd-1),yMat(:,tInd-1),VxMat(:,tInd-1)...
            ,VyMat(:,tInd-1),L,N,dt,k,compressionFactor,gamma,B);


        VxMat(:,tInd) = V(:,1);
        VyMat(:,tInd) = V(:,2);

        xMat(:,tInd) = X(:,1);
        yMat(:,tInd) = X(:,2);
        tInd;
    end
    toc()
    %% plot
%     % close all;
%     figure(2)
%     % hold on
%     Nparticle = 15
%     subplot(2,2,1)
%     scatter(tMat(1:tInd-1),xMat(Nparticle,1:tInd-1))
%     subplot(2,2,2)
%     scatter(tMat(1:tInd-1),yMat(Nparticle,1:tInd-1))
%     subplot(2,2,3)
%     scatter(tMat(1:tInd-1),VxMat(Nparticle,1:tInd-1))
%     subplot(2,2,4)
%     scatter(tMat(1:tInd-1),VyMat(Nparticle,1:tInd-1))
% 
%     sgtitle(strcat('particle=',string(Nparticle)))
%     fileN1 = strcat(string(Bmat(i)), strcat('particle=',string(Nparticle),'.png'))
%     savefig(fileN1)
    %% Plot particles
    figure(3)
    IndexTime =191001
    plot(xMat(:,IndexTime),yMat(:,IndexTime),'o-')
    title(sprintf('Time= %.3f',tMat(IndexTime)))
%     xlim([-0.1 1])
%     ylim([-0.07 0.07])
    fileName = strcat(string(Bmat(i)),'2.png')
    saveas(gcf,fileName)
    %%
    % F1 = diff(yMat)/diff(xMat)
    % Bending_Energy = sum( ( diff(F1)/diff(xMat) ).^2 );
    % dists = sqrt( diff(yMat).^2 + diff(xMat).^2 );
    % Elastic_Energy = [sum( ( dists - L/N ).^2 )];
    close all
    lengths2 = sum(sqrt(diff(yMat).^2 + diff(xMat).^2));
    figure(1)
    plot(tMat,lengths2)
    xlabel('time'); ylabel('length(mm)')
    title(string(Bmat(i)))
    fileName = strcat(string(Bmat(i)),'.png')
    saveas(gcf,fileName)
    %%
    fileName = strcat(string(Bmat(i)),'.mat')
%     save(fileName)
    lengthsMatMin(i) = min(lengths2(1:end-10));
    lengthsMatMax(i) = lengths2(end-10);
   
end
%%

scatter(Bmat,lengthsMatMin,'r')
hold on;scatter(Bmat,lengthsMatMin,'b')
%%
figure;
scatter(Bmat(1:90)*k*N,Jump(1:90),'r.')
xlabel('Bending spring constant')
ylabel('jump(mm)')


%%
saveas(gcf,strcat(string(i),'totall.png'))