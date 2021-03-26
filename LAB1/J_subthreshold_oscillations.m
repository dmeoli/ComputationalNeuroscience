%%%%%%%%%%%%%%%%%%%% (J) Subthreshold oscillations %%%%%%%%%%%%%%%%%%%%
% These neurons exhibit oscillatory potentials.

clear variables;

a=0.05;  b=0.26;  c=-60;  d=0;
j=0.04;  k=5;  l=140;
r=false;

u=-62;  % threshold value of the model neuron
w=b*u;

udot=[]; 
wdot=[];
grad_u=[]; 
grad_w=[];

tau = 0.25;
tspan = 0:tau:200;
T1=tspan(end)/10;

for t=tspan
    if (t>T1) && (t < T1+5) 
        I=2;
    else
        I=0;
    end
    
    [u, w, du, dw] = izhikevich(a, b, c, d, j, k, l, u, w, I, tau, r);
    grad_u(end+1)=du;
    grad_w(end+1)=dw;
    
    if u > 30  % not a threshold, but the peak of the spike
        udot(end+1)=30;
    else
        udot(end+1)=u;
    end
    wdot(end+1)=w;
end

% plot membrane potential
fig = figure;
plot(tspan,udot,[0 T1 T1 (T1+5) (T1+5) max(tspan)],-90+[0 0 10 10 0 0],...
    tspan(220:end),-10+20*(udot(220:end)-mean(udot)));
axis([0 max(tspan) -90 30])
xlabel('time')
ylabel('membrane potential')
title('(J) subthreshold oscillations');
print(fig,'img/J_subthreshold_oscillations_membrane_potential.png','-dpng')

% plot phase portrait
fig = figure;
hold on;
plot(udot,wdot)
quiver(udot,wdot,grad_u,grad_w,'r')
xlabel('membrane potential')
ylabel('recovery variable')
title('(J) subthreshold oscillations phase portrait');
print(fig,'img/J_subthreshold_oscillations_phase_portrait.png','-dpng')