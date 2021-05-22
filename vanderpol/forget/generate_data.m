function generate_data()
rng(2021); % Set random seed
N = 200; % Number of simulations
function [t,y] = VanderPol(idis, ivel, mu, A, omega, tf)
    [t,y] = ode45(@vdp1,[0 tf],[idis; ivel]);
    plot(t,y(:,1),'-o',t,y(:,2),'-o')
    title('Solution of van der Pol Equation (\mu = 1) with ODE23');
    xlabel('Time t');
    ylabel('Solution y');
    legend('y_1','y_2')
    figure
    plot(y(:,1),y(:,2))
    title('Phase plane plot')
    function dydt = vdp1(t,y)
        dydt = [y(2); mu*(1-y(1)^2)*y(2)-y(1)+A*sin(omega*t)];
    end
end

x0 = 2;
v0 = 0;
A = 8;
omega = 4;
mu = 3;
tf = 20;
rng(2021); % Set random seed
N = 1000; % Number of simulations
uncD = 0.5;
uncD = 2*(rand(N,2)-0.5)*uncD;
uncV = 0.1;
uncV = 2*(rand(N,2)-0.5)*uncV;
tvec = cell(1,N);
states = cell(1,N);
for i=1:N
    idis = x0+uncD(i);
    ivel = v0+uncV(i);
    [t,y] = VanderPol(idis, ivel, mu, A, omega, tf);
    tvec{i} = t;
    states{i} = y;
end

save('vdp_data.mat','tvec','states');
end

