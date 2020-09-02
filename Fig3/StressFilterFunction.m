function [Stress_filtered]=StressFilterFunction(Stress,Fs)

x=Stress;

% Fs=50000;
T=1/Fs; 
L=size(x,1);
t=(0:L-1)*T;


%% Design a filter

f=1;

Fnorm=f*(2*T);
df = designfilt('lowpassfir','FilterOrder',60,'CutoffFrequency',Fnorm);


%%
% grpdelay(df,2048,Fs)   % plot group delay
D = mean(grpdelay(df)) % filter delay in samples
%%
y = filter(df,[x; zeros(D,1)]); % Append D zeros to the input data
y = y(D+1:end);                  % Shift data to compensate for delay

% figure
% plot(t,x,t,y,'r','linewidth',1.5);
% title('Filtered Waveforms');
% xlabel('Time (s)')
% legend('Original Noisy Signal','Filtered Signal');
% grid on
% axis tight
Stress_filtered=y;