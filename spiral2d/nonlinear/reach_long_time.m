%% Attempt to do reachability analysis of a Neural Network ODE
% Function defined in a different file for CORA
controlPeriod = 5.0; % total seconds
reachStep = 0.05; % smaller reachStep, more accurate, longer computation
C = eye(3); % Want to get both of the outputs from NeuralODE
% Load neural network parameters
load('odeffnn_spiral_non.mat');
% Contruct NeuralODE
Wb{1} = [Wb{1} zeros(2,1);zeros(1,3)]; % Add a time variable for plotting purposes
Wb{2} = [Wb{2}';1];
Wb{7} = [Wb{7} zeros(2,1);zeros(1,2) 1];
Wb{8} = [Wb{8}';0];
layer1 = LayerS(Wb{1},Wb{2},'purelin');
layer4 = LayerS(Wb{7},Wb{8},'purelin');
odeblock = NonLinearODE(3,1,@spiral_non_time,reachStep,controlPeriod,C); % Nonlinear ODE plant 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1, odelayer, layer4};
neuralode = NeuralODE(neuralLayers);

%% Reachability scenario 1
% Setup
x0 = [2.0;0.0;0.0]; % This is like the initial input to the ODeblock
R0 = Star([1.95;-0.05;0.0],[2.05;0.05;0.0]);

t = tic;
R1 = neuralode.reach(R0); % Reachability
t1 = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

f = figure;
hold on;
Star.plotBoxes_2D_noFill(R1,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
xlabel('x_1');
ylabel('x_2');
saveas(f,'nonlinearspiral_time.png')

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(R1,3,2,'b');
plot(yyy(3,:),yyy(2,:),'r');
xlabel('x_1');
ylabel('x_2');
saveas(f,'nonlinearspiral_time2.png')

f = figure;
hold on;
Star.plotBoxes_2D_noFill(R1,3,1,'b');
plot(yyy(3,:),yyy(1,:),'r');
xlabel('x_1');
ylabel('x_2');
saveas(f,'nonlinearspiral_time1.png')

save('reach_long_time.mat','t1','R1','-v7.3');


% %% Reachability scenario 2
% controlPeriod = 10.0; % total seconds
% reachStep = 0.01; % smaller reachStep, more accurate, longer computation
% C = eye(2); % Want to get both of the outputs from NeuralODE
% odeblock = NonLinearODE(2,1,@spiral_non,reachStep,controlPeriod,C); % Nonlinear ODE plant 
% odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
% neuralLayers = {layer1, odelayer, layer4};
% neuralode = NeuralODE(neuralLayers);
% 
% % Setup
% x0 = [2.0;0.0]; % This is like the initial input to the ODeblock
% R0 = Star([1.9;-0.1],[2.1;0.1]);
% 
% t = tic;
% R2 = neuralode.reach(R0); % Reachability
% tb = toc(t);
% yyy = neuralode.evaluate(x0); % Simulation
% 
% 
% % Plot results
% f = figure;
% hold on;
% Star.plotBoxes_2D_noFill(R2,1,2,'b');
% plot(yyy(1,:),yyy(2,:),'r');
% title('NeuralODE demo - Spiral Nonlinear');
% xlabel('x_1');
% ylabel('x_2');
% saveas(f,'nonlinearspiral_long.png')

%% Safety property
% Stay within +0.3 and -0.3 in both x and y coordinates from original
% trajectory