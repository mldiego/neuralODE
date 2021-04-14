%% Attempt to do reachability analysis of a Neural Network ODE
% Function defined in a different file for CORA
controlPeriod = 4.0; % total seconds
reachStep = 0.001; % smaller reachStep, more accurate, longer computation
C = eye(2); % Want to get both of the outputs from NeuralODE
nnode = NonLinearODE(2,1,@spiral_non,reachStep,controlPeriod,C); % Nonlinear ODE plant 
% Load neural network parameters
load('odeffnn_spiral_non.mat');
% Contruct NeuralODE
layer1 = LayerS(Wb{1},Wb{2}','purelin');
net1 = FFNNS(layer1); % neural network (input)
layer4 = LayerS(Wb{7},Wb{8}','purelin');
layer_out = FFNNS(layer4);

%% Reachability scenario 1
% Setup
x0 = [2.0;0.0]; % This is like the initial input to the ODeblock
u = 0; % Initial input chosen (no inputs as for dynamical plants)

R0 = Star([1.95;-0.05],[2.05;0.05]);
U = Star(0,0);

% Reachability
t = tic;
R1 = net1.reach(R0,'approx-star');
R2 = nnode.stepReachStar(R1,U);
R2all = nnode.intermediate_reachSet;
R3 = layer_out.reach(R2all,'approx-star');
toc(t);

% Simulation
nnode.params.tFinal = 25;
x0 = net1.evaluate(x0);
[~,y3] = nnode.evaluate(x0,u);
y4 = y3;
for i=1:length(y4)
    y3(i,:) = layer_out.evaluate(y4(i,:)');
end

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(R3,1,2,'b');
plot(y3(:,1),y3(:,2),'r');
title('NeuralODE demo - Spiral Nonlinear');
xlabel('x_1');
ylabel('x_2');
saveas(f,'nonlinearspiral_0.05.png')


%% Reachability scenario 2
controlPeriod = 3.0; % total seconds
reachStep = 0.001; % smaller reachStep, more accurate, longer computation
C = eye(2); % Want to get both of the outputs from NeuralODE
nnode2 = NonLinearODE(2,1,@spiral_non,reachStep,controlPeriod,C); % Nonlinear ODE plant 

% Setup
x0 = [2.0;0.0]; % This is like the initial input to the ODeblock
u = 0; % Initial input chosen (no inputs as for dynamical plants)

R0 = Star([1.9;-0.1],[2.1;0.1]);
U = Star(0,0);

% Reachability
% Reachability
t = tic;
R1 = net1.reach(R0,'approx-star');
R2 = nnode2.stepReachStar(R1,U);
R2all = nnode2.intermediate_reachSet;
R3 = layer_out.reach(R2all,'approx-star');
toc(t);

% Simulation
% [tV,y] = nnode.evaluate(x0,u);

% Simulation
nnode.params.tFinal = 25;
x0 = net1.evaluate(x0);
[~,y3] = nnode.evaluate(x0,u);
y4 = y3;
for i=1:length(y4)
    y3(i,:) = layer_out.evaluate(y4(i,:)');
end

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(R3,1,2,'b');
plot(y3(:,1),y3(:,2),'r');
title('NeuralODE demo - Spiral Nonlinear');
xlabel('x_1');
ylabel('x_2');
saveas(f,'nonlinearspiral_0.1.png')

%% Safety property
% Stay within +0.3 and -0.3 in both x and y coordinates from original
% trajectory