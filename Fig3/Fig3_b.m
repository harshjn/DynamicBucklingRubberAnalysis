%%
figure(3)
plot(time,PositionMM)
yyaxis right
plot(time,StressN)
%%
Eps0=0.44;
options=odeset('AbsTol',1e-7,'RelTol',10e-6,'Stats','on','OutputFcn',@odeplot); 
figure(2)
clf

[tv1 f1]=ode23s('EpsFun',[0:1e-3:30],Eps0,options);
%%
timeTheoretical = (-5:1e-3:30)';


StressTh=double(vpa(sigma(timeTheoretical),8));

writematrix([timeEps,EpsTh],'EpsThoretical.csv')
writematrix([timeTheoretical,StressTh],'StressThoretical.csv')