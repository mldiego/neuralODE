%% Attempt to do reachability analysis of a Neural Network ODE
% Function defined in a different file for CORA
controlPeriod = 8; % total seconds (ode1)
controlPeriod1 = 1; % total seconds (ode2 and ode3)
reachStep = 0.1; % 1 
reachStep1 = 0.1; % 1 second
% Load parameters
load('/home/manzand/Documents/Python/neuralODE_examples/bounce_ball/odeffnn_bball_pos_gen.mat')
% Contruct NeuralODE
layer1 = LayerS(Wb{1},Wb{2}','poslin');
net1 = FFNNS(layer1); % neural network (input)
% ODEBlock only linear layers
% Convert in form of a linear ODE model
data_dim = 64;
w1 = Wb{3};
b1 = Wb{4}';
w2 = Wb{5};
b2 = Wb{6}';
w3 = Wb{7};
b3 = Wb{8}';
Aout = w3*w2*w1;
Bout = b3 + w3*w2*b1 + w3*b2;
Cout = eye(data_dim);
D = zeros(data_dim,1);
numSteps = controlPeriod/reachStep;
numSteps1 = controlPeriod1/reachStep1;
ode1 = LinearODE(Aout,Bout,Cout,D,controlPeriod,numSteps);
% odeblock = NonLinearODE(states,inputs,@spiral,reachStep,controlPeriod,C); % Nonlinear ODE plant 
% Output layers 
layer2 = LayerS(Wb{9},Wb{10}','poslin');
net2 = FFNNS(layer2); % neural network (input)
% ODEBlock only linear layers
% Convert in form of a linear ODE model
data_dim = 64;
w1 = Wb{11};
b1 = Wb{12}';
w2 = Wb{13};
b2 = Wb{14}';
w3 = Wb{15};
b3 = Wb{16}';
Aout = w3*w2*w1;
Bout = b3 + w3*w2*b1 + w3*b2;
Cout = eye(data_dim);
D = zeros(data_dim,1);
ode2 = LinearODE(Aout,Bout,Cout,D,controlPeriod1,numSteps1);
layer3 = LayerS(Wb{17},Wb{18}','purelin');
net3 = FFNNS(layer3); % neural network (input)


% % Test the output layer by layer
% x0 = 17.0;
% R0 = Star(x0,x0); % No uncertainty
% U = Star(1,1);
% x1 = net1.evaluate(x0); % [ 0.0000,  0.0000,  7.9329, ..., 0.0000,  7.9630,  9.2251]
% R1 = net1.reach(R0,'approx-star');
% [x2, ~, ~] = ode1.simulate([1 1], [0 8], x1); % [-4.9573e+01, -7.8748e+01, -3.2205e+00,  ...,  3.9060e+01, -7.1707e+01, -4.3545e+01]]
% R2 = ode1.simReach('direct',R1,U,reachStep,numSteps); %try ode45
% R2b = ode1.simReach('ode45',R1,U,reachStep,numSteps);
% x3 = net2.evaluate(x2(2,:)'); % [ 0.0000,  0.0000,  0.0000,  ...,  0.0000,  0.0000, 18.5793]
% R3 = net2.reach(R2,'approx-star');
% R3b = net2.reach(R2b,'approx-star');
% [x4, ~, ~] = ode2.simulate([1 1], [0 1], x3); %  [ -3.4189, -12.9826, -15.0849,  ...,  -2.8055,  20.2326,   6.7024]
% R4 = ode2.simReach('direct',R3(end),U,reachStep1,numSteps1); %try ode45
% R4b = ode2.simReach('ode45',R3b(end),U,reachStep1,numSteps1);
% x4 = x4(2,:)';
% x5 = net3.evaluate(x4); % [ 0.8192]
% R5 = net3.reach(R4(end),'approx-star');
% R5b = net3.reach(R4b(end),'approx-star');
% [m,M] = R5.getRanges();
% [m2,M2] = R5b.getRanges();



% Setup
x0 = 15; % This is like the initial input to the ODeblock
% u = [0]; % Initial input chosen (no inputs as for dynamical plants)
unc = 0.1;

R0 = Star(x0-unc,x0+unc);
U = Star(0,0);

% Reachability
t = tic;
R1 = net1.reach(R0,'approx-star');
R2 = ode1.simReach('direct',R1,U,reachStep,numSteps); %try ode45
R3 = net2.reach(R2,'approx-star');
R4 = [];
for i=1:length(R3)
    rtemp = ode2.simReach('direct',R3(i),U,reachStep1,numSteps1);
    R4 = [R4 rtemp(end)];
end
Rout = net3.reach(R4,'approx-star');
tb = toc(t);
disp('Elapsed Time to compute reachable sets ' + string(tb));


% Plot results
tvec = 0:reachStep:controlPeriod;

f = figure;
hold on;
Star.plotRanges_2D(Rout,1,tvec,'b');
title('NeuralODE - Bouncing ball');
xlabel('x_1');
ylabel('x_2');
saveas(f,'bballlinear_pos_gen.png');


save('reach_pos_gen.mat','tb','Rout','tvec');