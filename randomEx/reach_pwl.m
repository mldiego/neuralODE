%% Create a random and more complex example of Neural ODEs
% The architecture is the following
% Inputs: 3
% Outputs: 3
% NeuralODE:
% layer 1: linear(3,6)
% layer 2: relu(6,6)
% layer 3: linear(6,6)
% layer 4: odeblock (6 states) (time series)
    % layerODE1: linear(6,10)
    % layerODE2: linear(10,6)
% layer 5: linear(6,10)
% layer 6: relu(10,3)
% layer 7: odeblock(3 states) (only output)
    % layerODE3: linear(3,3)
%layer 8: linear(3,3)

rng(202); % set random seed

%% Create random weight variables
w1 = randn(3,6)'; b1 = randn(6,1);     % layer 1
w2 = randn(6,6)'; b2 = randn(6,1);     % layer 2
w3 = randn(6,6)'; b3 = randn(6,1);     % layer 3
w41 = randn(6,10)'; b41 = randn(10,1); % layer 4.1
w42 = randn(10,6)'; b42 = randn(6,1);  % layer 4.2
w5 = randn(6,10)'; b5 = randn(10,1);   % layer 5
w6 = randn(10,3)'; b6 = randn(3,1);    % layer 6
w7 = randn(3,3)'; b7 = randn(3,1);     % layer 7
w8 = randn(3,3)'; b8 = randn(3,1);

%% Create NeuralODE 
layer1 = LayerS(w1,b1,'purelin'); % linear
layer2 = LayerS(w2,b2,'poslin'); % relu
layer3 = LayerS(w3,b3,'purelin'); % linear
layer5 = LayerS(w5,b5,'purelin'); %linear
layer6 = LayerS(w6,b6,'poslin'); % relu
layer8 = LayerS(w8,b8,'purelin'); % linear
% odeblock 1 (timeseries) (layer4)
cP1 = 1; % tf simulation
reachStep1 = 0.01; % reach step
% Convert in form of a linear ODE model
states = 6; % 2 + 1 augmented dimension
outputs = 6; % Only actual dimensions
A1 = w42*w41;
B1 = w42*b41 + b42;
C1 = eye(states);
D1 = zeros(outputs,1);
nS1 = cP1/reachStep1; % number of reach steps
odeblock1 = LinearODE(A1,B1,C1,D1,cP1,nS1);
% Output layers 
layer4 = ODEblockLayer(odeblock1,cP1,reachStep1,true);
%%%%%%%%%%%%%%%%%%
% odeblock 2 (outout) (layer7)
cP2 = 1; % tf simulation
reachStep2 = 0.01; % reach step
% Convert in form of a linear ODE model
states = 3; % 2 + 1 augmented dimension
outputs = 3; % Only actual dimensions
A2 = w7;
B2 = b7;
C2 = eye(states);
D2 = zeros(outputs,1);
nS2 = cP2/reachStep2; % number of reach steps
odeblock2 = LinearODE(A2,B2,C2,D2,cP2,nS2);
% Output layers 
layer7 = ODEblockLayer(odeblock2,cP1,reachStep1,false);
neuralLayers = {layer1,layer2,layer3,layer4,layer5,layer6,layer7,layer8};
neuralode = NeuralODE(neuralLayers);

%% Reachability run #1
unc = 0.1;
% Setup
x0 = rand(3,1); % Initial state 
lb = x0-unc;
ub = x0+unc;
R0 = Star(lb,ub);

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
saveas(f,"traj1_pwl_b.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,3,'b');
plot(yyy(1,:),yyy(3,:),'r');
xlabel('x_1');
ylabel('x_3');
saveas(f,"traj2_pwl_b.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,2,3,'b');
plot(yyy(2,:),yyy(3,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"traj3_pwl_b.png");

tvec = 0:reachStep1:cP1; % time vector for plotting
f = figure;
Star.plotRanges_2D(Rb,1,tvec,'b');
hold on;
plot(tvec,yyy(1,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT1_pwl_b.png");

f = figure;
Star.plotRanges_2D(Rb,2,tvec,'b');
hold on;
plot(tvec,yyy(2,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT2_pwl_b.png");

f = figure;
Star.plotRanges_2D(Rb,3,tvec,'b');
hold on;
plot(tvec,yyy(3,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT3_pwl_b.png");

%% Reachability run #2
unc = 0.2;
% Setup
% x0 = rand(3,1); % Initial state 
lb = x0-unc;
ub = x0+unc;
R0 = Star(lb,ub);

t = tic;
Rb = neuralode.reach(R0); % Reachability
ta = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
xlabel('x_1');
ylabel('x_2');
saveas(f,"traj1_pwl_a.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,3,'b');
plot(yyy(1,:),yyy(3,:),'r');
xlabel('x_1');
ylabel('x_3');
saveas(f,"traj2_pwl_a.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,2,3,'b');
plot(yyy(2,:),yyy(3,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"traj3_pwl_a.png");

tvec = 0:reachStep1:cP1; % time vector for plotting
f = figure;
Star.plotRanges_2D(Rb,1,tvec,'b');
hold on;
plot(tvec,yyy(1,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT1_pwl_a.png");

f = figure;
Star.plotRanges_2D(Rb,2,tvec,'b');
hold on;
plot(tvec,yyy(2,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT2_pwl_a.png");

f = figure;
Star.plotRanges_2D(Rb,3,tvec,'b');
hold on;
plot(tvec,yyy(3,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT3_pwl_a.png");

%% Reachability run #2
unc = 0.02;
% Setup
% x0 = rand(3,1); % Initial state 
lb = x0-unc;
ub = x0+unc;
R0 = Star(lb,ub);

t = tic;
Rb = neuralode.reach(R0); % Reachability
tc = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
xlabel('x_1');
ylabel('x_2');
saveas(f,"traj1_pwl_c.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,3,'b');
plot(yyy(1,:),yyy(3,:),'r');
xlabel('x_1');
ylabel('x_3');
saveas(f,"traj2_pwl_c.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,2,3,'b');
plot(yyy(2,:),yyy(3,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"traj3_pwl_c.png");

tvec = 0:reachStep1:cP1; % time vector for plotting
f = figure;
Star.plotRanges_2D(Rb,1,tvec,'b');
hold on;
plot(tvec,yyy(1,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT1_pwl_c.png");

f = figure;
Star.plotRanges_2D(Rb,2,tvec,'b');
hold on;
plot(tvec,yyy(2,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT2_pwl_c.png");

f = figure;
Star.plotRanges_2D(Rb,3,tvec,'b');
hold on;
plot(tvec,yyy(3,:),'r');
xlabel('x_2');
ylabel('x_3');
saveas(f,"trajT3_pwl_c.png");

save('reach_pwl.mat','ta','tb','tc');