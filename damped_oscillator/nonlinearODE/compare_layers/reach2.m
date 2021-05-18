%% Attempt to do reachability analysis of a Neural Network ODE
% Function defined in a different file for CORA
controlPeriod = 3.0; % total seconds
reachStep = 0.01; % smaller reachStep, more accurate, longer computation
C = eye(2); % Want to get both of the outputs from NeuralODE
% Load neural network parameters
odeblock = NonLinearODE(2,1,@node2,reachStep,controlPeriod,C); % Nonlinear ODE plant 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralode = NeuralODE({odelayer});

%% Reachability run #1
% Setup
x0 = [-1.4996;-0.4609]; % Initial state first trajectory
unc = 0.01;
lb = x0-unc;
ub = x0+unc;
R0 = Star(lb,ub);

t = tic;
Rb = neuralode.reach(R0); % Reachability
ta = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('Damped Oscillator');
xlabel('x_1');
ylabel('x_2');
saveas(f,'DampedOsc_2_traj1.png');

%% Reachability run #2
% Setup
odeblock = NonLinearODE(2,1,@node2,reachStep,controlPeriod,C); % Nonlinear ODE plant 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralode = NeuralODE({odelayer});
x0 = [2.4714;0.3462]; % Initial state second trajectory
unc = 0.01;
lb = x0-unc;
ub = x0+unc;
R0 = Star(lb,ub);

t = tic;
Rb = neuralode.reach(R0); % Reachability
tb = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('Damped Oscillator');
xlabel('x_1');
ylabel('x_2');
saveas(f,'DampedOsc_2_traj2.png');

%% Reachability run #3
% Setup
odeblock = NonLinearODE(2,1,@node2,reachStep,controlPeriod,C); % Nonlinear ODE plant 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralode = NeuralODE({odelayer});
x0 = [0.2647;-0.0339]; % Initial state third trajectory
unc = 0.01;
lb = x0-unc;
ub = x0+unc;
R0 = Star(lb,ub);

t = tic;
Rb = neuralode.reach(R0); % Reachability
tc = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('Damped Oscillator');
xlabel('x_1');
ylabel('x_2');
saveas(f,'DampedOsc_2_traj3.png');

%% Save results
% May want to set equal axes so that the set representations are equally
% visualized
save('reach2.mat','ta','tb','tc');
