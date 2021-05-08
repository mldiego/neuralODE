% Reachability analysis of a Neural Network ODE

%% Define layers and neural ODE
controlPeriod = 25; % total seconds
reachStep = 0.01; % 1 second
C = eye(2); % Want to get both of the outputs from NeuralODE
% Load parameters
load('odeffnn_spiral.mat');
% Contruct NeuralODE
layer1 = LayerS(Wb{1},Wb{2}','purelin');
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
% Output layers 
layer4 = LayerS(Wb{7},Wb{8}','purelin');
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1, odelayer, layer4};
neuralode = NeuralODE(neuralLayers);

%% Reachability run #1
% Setup
x0 = [2.0;0.0]; % This is like the initial input to the ODEblock (initial state)
R0 = Star([1.9;-0.1],[2.1;0.1]);

t = tic;
Rb = neuralode.reach(R0); % Reachability
tb = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('NeuralODE demo - Spiral Linear');
xlabel('x_1');
ylabel('x_2');
saveas(f,'spirallinear_0.1.png');

%% Reachability run #2
R0 = Star([1.95;-0.05],[2.05;0.05]);

t = tic;
Ra = neuralode.reach(R0); % Reachability
ta = toc(t);

% Plot results
f = figure;
Star.plotBoxes_2D_noFill(Ra,1,2,'b');
hold on;
plot(yyy(1,:),yyy(2,:),'r');
title('NeuralODE demo - Spiral Linear');
xlabel('x_1');
ylabel('x_2');
saveas(f,'spirallinear_0.05.png');

%% Reachability run #2
R0 = Star([1.8;-0.2],[2.2;0.2]);

t = tic;
Rc = neuralode.reach(R0); % Reachability
tc = toc(t);

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rc,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('NeuralODE demo - Spiral Linear');
xlabel('x_1');
ylabel('x_2');
saveas(f,'spirallinear_0.2.png');

%% Reachability run #4
% Match final reachability time of nonlinear spiral models
controlPeriod = 4; % total seconds
reachStep = 0.005; % 1 second
numSteps = controlPeriod/reachStep;

odeblock = LinearODE(Aout,Bout',Cout,D,controlPeriod,numSteps);
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1, odelayer, layer4};
neuralode = NeuralODE(neuralLayers);

R0 = Star([1.95;-0.05],[2.05;0.05]);

t = tic;
Rd = neuralode.reach(R0); % Reachability
td = toc(t);

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rd,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
saveas(f,'spirallinear_0.05_match.png');

%% Reachability run #2
% Match final reachability time of nonlinear spiral models
controlPeriod = 3; % total seconds
reachStep = 0.005; % 1 second
numSteps = controlPeriod/reachStep;

odeblock = LinearODE(Aout,Bout',Cout,D,controlPeriod,numSteps);
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1, odelayer, layer4};
neuralode = NeuralODE(neuralLayers);

R0 = Star([1.9;-0.1],[2.1;0.1]);
U = Star(0,0);

t = tic;
Re = neuralode.reach(R0); % Reachability
te = toc(t);

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(Re,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
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
