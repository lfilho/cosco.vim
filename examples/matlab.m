% Probability density function: natural measure
% Ricardo Carretero April-2003, Copyright (c).

f = inline('4*x.*(1-x)','x');

Nit=1e5;
Nshow=100;
Nbox=125;
Ntrans=1000
Nstop=Nit/Nshow;

xmin=0;
xmax=1;
dx=(xmax-xmin)/Nbox;
x=linspace(xmin+dx/2,xmax-dx/2,Nbox);
box=zeros(1,Nbox);

fs=15;
lw=2;
figure(1)

x0=0.01;
xo=x0;

for i=1:Ntrans
 xn=f(xo);
 xo=xn;
end

for i=1:Nshow
 fprintf('%d, ',i)
 for j=1:Nstop
  xn=f(xo);
  ii = ceil(xn*Nbox);
  box(ii)=box(ii)+1;
  xo=xn;
 end
 clf
 set(gca,'FontSize',[fs]);
 bar(x,box/(dx*Nstop*i),1,'w')
 hold on
 plot(x,1./(pi*sqrt(x-x.^2)),'LineWidth',lw);
 axis([0 1 0 5]);
 xlabel('x')
 ylabel('\mu(x)');
 pause(0.001)
end
