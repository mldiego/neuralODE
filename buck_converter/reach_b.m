% Reachability analysis of the average model
% Diego Manzanas, September 30th 2020
close all

%% Define layers and neural ODE
controlPeriod = 0.3; % total seconds
reachStep = 0.001; % 1 second
% Load parameters
load("C:\Users\diego\Documents\GitHub\Python\sonode\experiments\buck_converter\odenet_buck2.mat");
% Contruct NeuralODE
layer1 = LayerS(Wb{1},Wb{2}','purelin');
% ODEBlock only linear layers
% Convert in form of a linear ODE model
states = 4;
outputs = 4;
inputs = 1;
w1 = Wb{3};
b1 = Wb{4}';
w2 = Wb{5};
b2 = Wb{6}';
w3 = Wb{7};
b3 = Wb{8}';
% Aout = w2*w1;
% Bout = b2' + b1'*w2';
Aout = w3*w2*w1;
Bout = b3 + w3*w2*b1 + w3*b2;
Cout = eye(states);
D = zeros(outputs,1);
numSteps = controlPeriod/reachStep;
odeblock = LinearODE(Aout,Bout,Cout,D,controlPeriod,numSteps);
% Output layers 
% layer4 = LayerS(Wb{7},Wb{8}','purelin');
layer4 = LayerS(Wb{9},Wb{10}','purelin');
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1, odelayer, layer4};
neuralode = NeuralODE(neuralLayers);

%% Reachability run #1
% Setup
x0 = [0.0;0.0]; % This is like the initial input to the ODEblock (initial state)
R0 = Star([0.0;0.0],[0.1;0.1]);

t = tic;
Rb = neuralode.reach(R0); % Reachability
tb = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
xlabel('x_1');
ylabel('x_2');
saveas(f,'buck_reach_b.png');

%% Reachability run #2
R0 = Star([0.0;0.0],[0.2;0.2]);

t = tic;
Ra = neuralode.reach(R0); % Reachability
ta = toc(t);

% Plot results
f = figure;
Star.plotBoxes_2D_noFill(Ra,1,2,'b');
hold on;
plot(yyy(1,:),yyy(2,:),'r');
xlabel('x_1');
ylabel('x_2');
saveas(f,'buck_reach_a.png');

save('reach_b.mat','ta','tb');