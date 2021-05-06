clc
clear all
close all
clf
A1 = load('Step1.mat');

A2 = load('Step2.mat');



%%

n = 512;
y1 = A1.y(1:end,n+1:2*n);
y2 = A2.y(1:end,n+1:2*n);
y_ = [y1(1:end-1,:);y2];

t1 = A1.t;
t2 = A2.t;
t=[t1(1:end-1); t2+t1(end)];
figure(1)
subplot(2,1,1)
% plot(A1.tMat_,A1.Fmat_,'b.')
% hold on
% plot(A2.tMat_+A1.tMat_(end),A2.Fmat_,'b.')

x = ([A1.tMat_(1:end-1) A2.tMat_+A1.tMat_(end)]);
v = ([A1.Fmat_(1:end-1) A2.Fmat_]);
% 
% xq = linspace(x(1),x(end),10000);
% vq = interp1(x,v,xq);
plot(x,smooth(v,1),'LineWidth',8)
xlabel('time(s)')
ylabel('Force(N)')
xlim([0.00 0.01])
set(gca,'FontSize',18) % Creates an axes and sets its FontSize to 18

% set(gca, 'XScale','log')
%%

y__=zeros(size(y_));
for i = 1: length(t)
    y__(i,:) = smooth(y_(i,:),30);
end


v=1;
dMat = zeros(length(t),512);
for i = 1: length(t)
    dMat(i,:) =linspace(0,0.1-v*t(i),512);
end
figure(1)
subplot(2,1,2)
% clf
tMat = repmat(t,1,512);
% plot(y__(8090,:))
for i = 1: length(t)
    LengthMat(i) = arclength(dMat(i,:),y__(i,:));
end
LengthMat_ = LengthMat;
LengthMat_(78:end) = smooth(LengthMat(78:end),10000);
subplot(2,1,2)
plot(t,LengthMat_,'LineWidth',8)
hold on
% plot(t(1:100:end),LengthMat(1:100:end),'.')
xlim([0 0.01])
hold on
v=1;
plot(t,0.1-v*t,'LineWidth',5)
ylim([0.090 0.101])
xlim([0 0.01])
ylabel('Length (m)')
xlabel('time(s)')
set(gca,'FontSize',18) % Creates an axes and sets its FontSize to 18

%%

y__=zeros(size(y_));
for i = 1: length(t)
    y__(i,:) = smooth(y_(i,:),100);
end


figure(2)
clf
n=1
s=surf(dMat(n:end,:),tMat(n:end,:)-t(n)+1e-3,y__(n:end,:))
s.EdgeColor='none'
view(0,90)
set(gca,'YScale', 'log')
set(gca,'Ydir', 'reverse')
set(gca,'Xdir', 'reverse')
% set(gca,'ColorScale','log')
ylim([0.004 0.018])
caxis([-0.001 0.002])
set(gca,'FontSize',18) % Creates an axes and sets its FontSize to 18
grid off
colorbar
%%
% subplot(1,2,1)
% contourf(,t,y__,'edgeColor','none')
colorbar('northoutside')
ylabel('time(ms)')
xlabel('Normalised Length')
set(gca, 'YDir','reverse')
set(gca,'YScale', 'log')
