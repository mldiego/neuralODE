% Reachability analysis of a Neural ODE

%% Define layers and neural ODE
controlPeriod = 10; % total seconds
reachStep = 0.05; % 1 second
% Load parameters
load("C:\Users\diego\Documents\GitHub\Python\sonode\experiments\damped_oscillators_linear\ilnode(1)\5\model.mat");
% Contruct NeuralODE
% ODEBlock only linear layers
% Convert in form of a linear ODE model
layer1 = LayerS(Wb{1},Wb{2}','purelin');
layer3 = LayerS(Wb{9},Wb{10}','purelin');
states = 3; % 2 + 1 augmented dimension
outputs = 3; % Only actual dimensions
inputs = 1;
w1 = Wb{3};
b1 = Wb{4}';
w2 = Wb{5};
b2 = Wb{6}';
w3 = Wb{7};
b3 = Wb{8}';
Aout = w3*w2*w1;
Bout = b3 + w3*w2*b1 + w3*b2;
Cout = eye(states);
D = zeros(outputs,1);
numSteps = controlPeriod/reachStep;
odeblock = LinearODE(Aout,Bout,Cout,D,controlPeriod,numSteps);
% Output layers 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1,odelayer,layer3};
neuralode = NeuralODE(neuralLayers);
tvec = 0:reachStep:controlPeriod;

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
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
hold on;
plot(yyy(1,:),yyy(2,:),'r');
xlabel('x_1');
ylabel('x_2');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
saveas(f,'DampedOsc_linear_10.png');

% f = figure;
% Star.plotRanges_2D(Rb,1,tvec,'b');
% hold on;
% plot(tvec,yyy(1,:),'r');
% xlabel('Time (s)');
% ylabel('x_1');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% saveas(f,'DampedOsc_long7_traj1_1.png');

% f = figure;
% Star.plotRanges_2D(Rb,2,tvec,'b');
% hold on;
% plot(tvec,yyy(2,:),'r');
% xlabel('Time (s)');
% ylabel('x_2');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% saveas(f,'DampedOsc_long7_traj1_2.png');

%% Save results
% May want to set equal axes so that the set representations are equally
% visualized
save('reach_linear_10.mat','ta','Rb');