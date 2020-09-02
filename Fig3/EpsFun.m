function f = EpsFun(t,y)

c=3.3e5;
% eta=1*32.05*c; E1=1.36*c; E2=9.52*c;
eta=0.1*3.05*c; E1=2.36*c; E2=2.42*c;
% eta=1*3.05*c; E1=2.36*c; E2=2.42*c;

tau=E2/eta
syms x
%%

t2=10.01;
sigma1(x)=tanh(10*(x))-1-1*tanh(100*(x-10))+0.5+0.7*tanh(100*(x-t2));
sigma2(x)=piecewise(x<t2,1,x>t2,exp(-20*(x-t2)));%*cos(150*(x-t2)));
sigma(x)=2.20e5*sigma1(x)*sigma2(x);


% figure(2)
% hold on
% fplot(sigma,[0 30])

%%
sigmaDot(x)=diff(sigma,x);

LHS(x)=sigma(x)+eta/(E1+E2)*sigmaDot(x);

f = ( double(LHS(t))-E1*E2/(E1+E2)*y )/((E1*eta)/(E1+E2));
end