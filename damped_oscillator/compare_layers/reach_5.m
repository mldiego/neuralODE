% Reachability analysis of a Neural ODE

%% Define layers and neural ODE
controlPeriod = 10; % total seconds
reachStep = 0.01; % 1 second
% Load parameters
load('/home/manzand/Documents/Python/sonode/experiments/damped_oscillators_linear/node./1_5_20./model.mat');
% Contruct NeuralODE
% ODEBlock only linear layers
% Convert in form of a linear ODE model
states = 2; % 2 + 1 augmented dimension
outputs = 2; % Only actual dimensions
inputs = 1;
w1 = Wb{1};
b1 = Wb{2}';
w2 = Wb{3};
b2 = Wb{4}';
w3 = Wb{5};
b3 = Wb{6}';
w4 = Wb{7};
b4 = Wb{8}';
w5 = Wb{9};
b5 = Wb{10}';
w6 = Wb{11};
b6 = Wb{12}';
w7 = Wb{13};
b7 = Wb{14}';
Aout = w7*w6*w5*w4w3*w2*w1;
Bout = b7+ w7*b6 + w7*w6*b5 + w7*w6*w5*b4 + w7*w6*w5*w4*b3 + w7*w6*w5*w4*w3*w2*b1 + w7*w6*w5*w4*w3*b2;
Cout = eye(states);
D = zeros(outputs,1);
numSteps = controlPeriod/reachStep;
odeblock = LinearODE(Aout,Bout,Cout,D,controlPeriod,numSteps);
% Output layers 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {odelayer};
neuralode = NeuralODE(neuralLayers);

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
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('Damped Oscillator');
xlabel('x_1');
ylabel('x_2');
saveas(f,'DampedOsc_5_traj1.png');

%% Reachability run #2
% Setup
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
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('Damped Oscillator');
xlabel('x_1');
ylabel('x_2');
saveas(f,'DampedOsc_5_traj2.png');

%% Reachability run #3
% Setup
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
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('Damped Oscillator');
xlabel('x_1');
ylabel('x_2');
saveas(f,'DampedOsc_5_traj3.png');

%% Save results
% May want to set equal axes so that the set representations are equally
% visualized
save('reach5.mat','ta','tb','tc');