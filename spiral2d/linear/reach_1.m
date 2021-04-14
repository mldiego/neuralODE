%% Attempt to do reachability analysis of a Neural Network ODE
% Function defined in a different file for CORA
controlPeriod = 1; % total seconds
reachStep = 0.01; % 1 second
C = eye(2); % Want to get both of the outputs from NeuralODE
% Load parameters
% load('/home/manzand/Documents/Python/neuralODE_examples/odeffnn_spiral.mat')
load('odeffnn_spiral.mat');
% Contruct NeuralODE
layer1 = LayerS(Wb{1},Wb{2}','purelin');
net1 = FFNNS(layer1); % neural network (input)
% ODEBlock only linear layers
% Convert in form of a linear ODE model
states = 2;
outputs = 2;
inputs = 1;
w1 = Wb{3};
b1 = Wb{4}';
w2 = Wb{5};
b2 = Wb{6}';
Aout = w2*w1;
Bout = b2' + b1'*w2';
Cout = eye(states);
D = zeros(outputs,1);
numSteps = controlPeriod/reachStep;
odeblock = LinearODE(Aout,Bout',Cout,D,controlPeriod,numSteps);
% odeblock = NonLinearODE(states,inputs,@spiral,reachStep,controlPeriod,C); % Nonlinear ODE plant 
% Output layers 
layer4 = LayerS(Wb{7},Wb{8}','purelin');
layer_out = FFNNS(layer4);


% Setup
x0 = [2.0;0.0]; % This is like the initial input to the ODeblock
% u = [0]; % Initial input chosen (no inputs as for dynamical plants)

R0 = Star([1.9;-0.1],[2.1;0.1]);
U = Star(0,0);

% Reachability
% t = tic;
% R1 = net1.reach(R0,'approx-star');
% R2 = odeblock.simReach('direct',R0,U,reachStep,numSteps);
% % R = odeblock.stepReachStar(R0,U);
% % R2all = odeblock.intermediate_reachset;
% R3b = layer_out.reach(R2,'approx-star');
% tb = toc(t);

% Simulation
tvec = 0:reachStep:controlPeriod;
u = zeros(length(tvec),1);
[ysim, ~, ~] = odeblock.simulate(u, tvec, x0);

% Simulation
% [tV,ysim] = odeblock.evaluate(x0,u);

% Plot results
% f = figure;
% hold on;
% Star.plotBoxes_2D_noFill(R3b,1,2,'b');
% plot(ysim(:,1),ysim(:,2),'r');
% title('NeuralODE demo - Spiral Linear');
% xlabel('x_1');
% ylabel('x_2');
% saveas(f,'spirallinear_0.1.png');

% Repeat with the Neural ODE block
odeblock = LinearODE(Aout,Bout',Cout,D,controlPeriod,numSteps);
% odeblock = NonLinearODE(states,inputs,@spiral,reachStep,controlPeriod,C); % Nonlinear ODE plant 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1, odelayer, layer4};
neuralode = NeuralODE(neuralLayers);
R = neuralode.reach(R0); % Reachability
yyy = neuralode.evaluate(x0);
% % Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(R,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('NeuralODE demo - Spiral Linear');
xlabel('x_1');
ylabel('x_2');
% saveas(f,'spirallinear_0.1.png');

%% Reachability run #2
R0 = Star([1.95;-0.05],[2.05;0.05]);
U = Star(0,0);

% Reachability
t = tic;
R1 = net1.reach(R0,'approx-star');
R2 = odeblock.simReach('direct',R0,U,reachStep,numSteps);
% R = odeblock.stepReachStar(R0,U);
% R2all = odeblock.intermediate_reachset;
R3a = layer_out.reach(R2,'approx-star');
ta = toc(t);

% Simulation
tvec = 0:reachStep:controlPeriod;
u = zeros(length(tvec),1);
[ysim, tsim, xsim] = odeblock.simulate(u, tvec, x0);

% Simulation
% [tV,ysim] = odeblock.evaluate(x0,u);

% Plot results
f = figure;
Star.plotBoxes_2D_noFill(R3a,1,2,'b');
hold on;
plot(ysim(:,1),ysim(:,2),'r');
title('NeuralODE demo - Spiral Linear');
xlabel('x_1');
ylabel('x_2');
saveas(f,'spirallinear_0.05.png');

%% Reachability run #2
R0 = Star([1.8;-0.2],[2.2;0.2]);
U = Star(0,0);

% Reachability
t = tic;
R1 = net1.reach(R0,'approx-star');
R2 = odeblock.simReach('direct',R0,U,reachStep,numSteps);
% R = odeblock.stepReachStar(R0,U);
% R2all = odeblock.intermediate_reachset;
R3c = layer_out.reach(R2,'approx-star');
tc = toc(t);

% Simulation
tvec = 0:reachStep:controlPeriod;
u = zeros(length(tvec),1);
[ysim, tsim, xsim] = odeblock.simulate(u, tvec, x0);

% Simulation
% [tV,ysim] = odeblock.evaluate(x0,u);

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(R3c,1,2,'b');
plot(ysim(:,1),ysim(:,2),'r');
title('NeuralODE demo - Spiral Linear');
xlabel('x_1');
ylabel('x_2');
saveas(f,'spirallinear_0.2.png');

%% Reachability run #4
% Match final reachability time of nonlinear spiral models
controlPeriod = 4; % total seconds
reachStep = 0.001; % 1 second
numSteps = controlPeriod/reachStep;

R0 = Star([1.95;-0.05],[2.05;0.05]);
U = Star(0,0);

% Reachability
t = tic;
R1 = net1.reach(R0,'approx-star');
R2 = odeblock.simReach('direct',R0,U,reachStep,numSteps);
% R = odeblock.stepReachStar(R0,U);
% R2all = odeblock.intermediate_reachset;
R3d = layer_out.reach(R2,'approx-star');
td = toc(t);

% Simulation
% tvec = 0:reachStep:controlPeriod;
% u = zeros(length(tvec),1);
% [ysim, tsim, xsim] = odeblock.simulate(u, tvec, x0);

% Simulation
% [tV,ysim] = odeblock.evaluate(x0,u);

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(R3d,1,2,'b');
plot(ysim(:,1),ysim(:,2),'r');
saveas(f,'spirallinear_0.05_match.png');

%% Reachability run #2
% Match final reachability time of nonlinear spiral models
controlPeriod = 3; % total seconds
reachStep = 0.001; % 1 second
numSteps = controlPeriod/reachStep;

R0 = Star([1.9;-0.1],[2.1;0.1]);
U = Star(0,0);

% Reachability
t = tic;
R1 = net1.reach(R0,'approx-star');
R2 = odeblock.simReach('direct',R0,U,reachStep,numSteps);
% R = odeblock.stepReachStar(R0,U);
% R2all = odeblock.intermediate_reachset;
R3e = layer_out.reach(R2,'approx-star');
te = toc(t);

% Simulation
% tvec = 0:reachStep:controlPeriod;
% u = zeros(length(tvec),1);
% [ysim, tsim, xsim] = odeblock.simulate(u, tvec, x0);

% Simulation
% [tV,ysim] = odeblock.evaluate(x0,u);

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(R3e,1,2,'b');
plot(ysim(:,1),ysim(:,2),'r');
saveas(f,'spirallinear_0.1_match.png');

save('reach.mat','ta','tb','tc','td','te');


%% Notes
% Simulation and reachability matches those of pytorch. The input to the
% neural network is not really the input, just the initial state. 

% So we may need to add some "fake" input every time we do reachability.
% One key question is to know how "deep" this neural ODE block is... How
% can we save this in NNV?

% We also need to automatically create a CORA function from this ODE
% block...
