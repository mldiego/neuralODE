%% Attempt to do reachability analysis of a Neural Network ODE
% Function defined in a different file for CORA
controlPeriod = 25; % total seconds
reachStep = 0.01; % 1 second
C = eye(2); % Want to get both of the outputs from NeuralODE
nnode = NonLinearODE(2,2,@node_demoCORA,reachStep,controlPeriod,C); % Nonlinear ODE plant 

% % Setup
% x0 = [1;1]; % This is like the initial input to the ODeblock
% u = [0;0]; % Initial input chosen (no inputs as for dynamical plants)
% 
% R0 = Star([0.98;0.98],[1.02;1.02]);
% U = Star([0;0],[0;0]);

% Setup
x0 = [2.005;0.005]; % This is like the initial input to the ODeblock
u = [0;0]; % Initial input chosen (no inputs as for dynamical plants)

R0 = Star([2;0],[2.01;0.01]);
U = Star([0;0],[0;0]);

% Reachability
R = nnode.stepReachStar(R0,U);

% Simulation
[tV,y] = nnode.evaluate(x0,u);

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill([R0 nnode.intermediate_reachSet],1,2,'r');
plot(y(:,1),y(:,2),'b');
title(['NeuralODE - Spiral - T_f = ' char(string(controlPeriod))]);
xlabel('x_1');
ylabel('x_2');
saveas(f,['nnode_spiral_' char(string(controlPeriod)) '.png']);

%% Notes
% Simulation and reachability matches those of pytorch. The input to the
% neural network is not really the input, just the initial state. 

% So we may need to add some "fake" input every time we do reachability.
% One key question is to know how "deep" this neural ODE block is... How
% can we save this in NNV?

% We also need to automatically create a CORA function from this ODE
% block...
