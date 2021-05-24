%% Attempt to do reachability analysis of a Neural Network ODE
% Function defined in a different file for CORA
controlPeriod = 2.0; % total seconds
reachStep = 0.01; % smaller reachStep, more accurate, longer computation
C = eye(2); % Want to get both of the outputs from NeuralODE
% Load neural network parameters
% Contruct NeuralODE
layer1 = LayerS(Wb{1},Wb{2}','purelin');
layer4 = LayerS(Wb{7},Wb{8}','purelin');
odeblock = NonLinearODE(2,1,@spiral_non,reachStep,controlPeriod,C); % Nonlinear ODE plant 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1, odelayer, layer4};
neuralode = NeuralODE(neuralLayers);

%% Reachability scenario 1
% Setup
x0 = [2.0;0.0]; % This is like the initial input to the ODeblock
R0 = Star([1.95;-0.05],[2.05;0.05]);

t = tic;
R1 = neuralode.reach(R0); % Reachability
t1 = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(R1,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
title('NeuralODE demo - Spiral Nonlinear');
xlabel('x_1');
ylabel('x_2');
saveas(f,'plane_p1_1.png')


