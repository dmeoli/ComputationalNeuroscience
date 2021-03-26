%%%%%%%%%%%%%%%%%%%% (T) Inhibition-Induced Bursting %%%%%%%%%%%%%%%%%%%%
% These neurons can fire tonic bursts of spikes in response to a prolonged
% hyperpolarization.

clear variables;

a=-0.026;  b=-1;  c=-45;  d=-2;
j=0.04;  k=5;  l=140;
r=false;

u=-63.8;  % threshold value of the model neuron
w=b*u;

udot=[]; 
wdot=[];
grad_u=[]; 
grad_w=[];

tau = 0.5;
tspan = 0:tau:350;

for t=tspan
    if (t < 50) || (t>250)
        I=80;
    else
        I=75;
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
plot(tspan,udot,[0 50 50 250 250 max(tspan)],-80+[0 0 -10 -10 0 0]);
axis([0 max(tspan) -90 30])
xlabel('time')
ylabel('membrane potential')
title('(T) inhibition induced bursting');
print(fig,'img/T_inhibition_induced_bursting_membrane_potential.png','-dpng')

% plot phase portrait
fig = figure;
hold on;
plot(udot,wdot)
quiver(udot,wdot,grad_u,grad_w,'r')
xlabel('membrane potential')
ylabel('recovery variable')
title('(T) inhibition induced bursting phase portrait');
print(fig,'img/T_inhibition_induced_bursting_phase_portrait.png','-dpng')