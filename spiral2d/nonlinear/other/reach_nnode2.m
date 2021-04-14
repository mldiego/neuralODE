%% Attempt to do reachability analysis of a more comples Neural Network ODE
% This NeuralODE consists of:
%  - Feedforward NN, 2 ReLU layers
%  - ODEblock (tanh + linear layers)
%  - Feedforward NN, ReLU + linear layers

rng(1); % Select random seed generator

% Neural network (before)
inp1 = 2;
n1 = 20; % Number of neurons layer 1
n2 = 2; % Number of neurons layer 2 (inputs to ODEblock)
b1 = rand(n1,1); % bias layer 1
w1 = rand(n1,inp1); % weights layer 1
b2 = rand(n2,1); % bias layer 2
w2 = rand(n2,n1); % weights layer 2
layer1 = LayerS(w1,b1,'poslin'); % hidden layer #1
layer2 = LayerS(w2,b2,'poslin'); % hidden layer #2
Layers = [layer1 layer2];
net1 = FFNNS(Layers); % neural network controller

% Function defined in a different file for CORA
controlPeriod = 0.2; % total seconds
reachStep = 0.025; % 1 second
C = eye(2); % Want to get both of the outputs from NeuralODE
nnode = NonLinearODE(2,2,@node_demoCORA,reachStep,controlPeriod,C); % Nonlinear ODE plant 

% Neural network (after)
inp1 = 2; % Outputs of ODEblock
n1 = 20; % Number of neurons layer 1
n2 = 2; % Number of neurons layer 2 (inputs to ODEblock)
b1 = rand(n1,1); % bias layer 1
w1 = rand(n1,inp1); % weights layer 1
b2 = rand(n2,1); % bias layer 2
w2 = rand(n2,n1); % weights layer 2
layer1 = LayerS(w1,b1,'poslin'); % hidden layer #1
layer2 = LayerS(w2,b2,'purelin'); % hidden layer #2
Layers = [layer1 layer2];
net2 = FFNNS(Layers); % neural network controller

% Setup
x0 = [1;1]; % Input to the NeuralODE
R0 = Star([0.99;0.99],[1.01;1.01]); % Input set to NeuralODE
U = Star([0;0],[0;0]);
u = [0;0];


% Reachability in 3 steps (FFNNS, ODEblock, FFNNS)
R1 = net1.reach(R0,'approx-star');
R2 = nnode.stepReachStar(R1,U);
R3 = net2.reach(R2,'approx-star');

% Simulation
[tV,y] = nnode.evaluate(x0,u);

% Plot results
figure;
hold on;
Star.plotBoxes_2D_noFill(R1,1,2,'r');
title('NeuralODE demo - NN1');
xlabel('x_1');
ylabel('x_2');

figure;
hold on;
Star.plotBoxes_2D_noFill(R2,1,2,'b');
title('NeuralODE demo - ODEblock');
xlabel('x_1');
ylabel('x_2');

figure;
hold on;
Star.plotBoxes_2D_noFill(R3,1,2,'k');
title('NeuralODE demo - NN2');
xlabel('x_1');
ylabel('x_2');
