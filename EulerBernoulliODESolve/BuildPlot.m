clc
clear all
close all
clf
A1 = load('Data1.mat');
A2 = load('Data2.mat');

Fmat = [A1.Fmat A2.Fmat];
tmat = [A1.tmat A1.tmat(end)+A2.tmat];
%%
figure(1)
shadeX = [0 0.0022 0.0022 0];
shadeY = [0 0 0.35 0.35];
patch('XData',shadeX,'YData',shadeY,'FaceColor',[0.25 0.25 0.25],'EdgeColor','none','FaceAlpha',0.1)
hold on
plot(tmat(1:320),smooth(Fmat(1:320),2)*1e-3)
hold off

%%
figure(2)
lMat = linspace(0,0.1,100);
tMat1 = t(1:241);
n = 100;
a1 = A1.y;
a2 = A2.y;
y = [a1(:,n+1:2*n); a2(:,n+1:2*n)] ;
t = [A1.t;A1.t(end)+A2.t];

subplot(1,2,1)
contourf(tMat1,lMat,-y(1:241,:)','edgeColor','none')
colorbar('northoutside')
xlabel('time(s)')
ylabel('Normalised Length')
%
tMat2 = t(242:1423);
subplot(1,2,2)
contourf(tMat2,lMat,y(242:1423,:)','edgeColor','none')
xlabel('time(s)')
% ylabel('normalised length')
colorbar('northoutside')


%%
% figure(3)
ell = 0.1
xMat = (1:n)*ell/n;
clf
for jj = 1: size(y,1)    
    yInd = y(jj,1:n);
    gammaMat(jj)   = (arclength(xMat,yInd)-ell)/ell;
end
% plot(t(1:241),gammaMat(1:241),'k')
% hold on
gm2=smooth(gammaMat(242:1223),200);
% plot(t(281:1223),gm2(40:end),'k')
% scatter(t(242:1223),gammaMat(242:1223),'bo',...
%     'MarkerEdgeAlpha',0.01,'MarkerFaceAlpha',0.01)

% gammaMat = [A1.gammaMat; A1.gammaMat(end)+A2.gammaMat];
%%
figure(3)
clf
tMat_ = [t(1:241); t(281:1223-50)];
gMat_ = [gammaMat(1:241) gm2(40:end-50)'];
subplot(2,1,1)
shadeX = [0 0.0022 0.0022 0];
shadeY = [-0.02 -0.02 0.015 0.015];
patch('XData',shadeX,'YData',shadeY,'FaceColor',[0.25 0.25 0.25],'EdgeColor','none','FaceAlpha',0.1)
hold on
plot(tMat_,gMat_-5.5*tMat_'+0.01,'.')
ylim([-0.02 0.015])
xlabel('time (s)')
ylabel('Contour strain')

subplot(2,1,2)
shadeX = [0 0.0022 0.0022 0];
shadeY = [0 0 0.35 0.35];
patch('XData',shadeX,'YData',shadeY,'FaceColor',[0.25 0.25 0.25],'EdgeColor','none','FaceAlpha',0.1)
hold on
plot(tmat(1:288),smooth(Fmat(1:288),2)*1e-3)
ylim([0 0.35])
xlabel('time(s)')
ylabel('Compressive Force (N)')
hold off

