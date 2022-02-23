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

% rng(4); % set random seed (This kinda works, takes forever)
rng(2023);

%% Create random weight variables
% Set as global variables the parameters used in the nonlinear dynamics
global w41 b41 w42 b42 w7 b7;
w1 = randn(3,6)'; b1 = randn(6,1);     % layer 1
w2 = randn(6,6)'; b2 = randn(6,1);     % layer 2
w3 = randn(6,6)'; b3 = randn(6,1);     % layer 3
% w41 = randn(6,6)'; b41 = randn(6,1); % layer 4.1
% w42 = randn(6,6)'; b42 = randn(6,1);  % layer 4.2
w41 = randi(100,6,6); b41 = randi(100,6,1); % layer 4.1
w42 = randi(100,6,6); b42 = randi(100,6,1);  % layer 4.2
w5 = randn(6,10)'; b5 = randn(10,1);   % layer 5
w6 = randn(10,3)'; b6 = randn(3,1);    % layer 6
w7 = randi(100,3,3)'; b7 = randi(100,3,1);     % layer 7
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
states = 6;
outputs = 6; % Only actual dimensions
% A1 = w42*w41;
% B1 = w42*b41 + b42;
C1 = eye(states);
% D1 = zeros(outputs,1);
% nS1 = cP1/reachStep1; % number of reach steps
% odeblock1 = LinearODE(A1,B1,C1,D1,cP1,nS1);
odeblock1 = NonLinearODE(6,1,@dyn1,reachStep1,cP1,C1); % Nonlinear ODE
% Output layers 
layer4 = ODEblockLayer(odeblock1,cP1,reachStep1,true);
%%%%%%%%%%%%%%%%%%
% odeblock 2 (outout) (layer7)
cP2 = 1; % tf simulation
reachStep2 = 0.01; % reach step
% Convert in form of a linear ODE model
states = 3; % 2 + 1 augmented dimension
outputs = 3; % Only actual dimensions
% A2 = w7;
% B2 = b7;
C2 = eye(states);
% D2 = zeros(outputs,1);
% nS2 = cP2/reachStep2; % number of reach steps
% odeblock2 = LinearODE(A2,B2,C2,D2,cP2,nS2);
odeblock2 = NonLinearODE(3,1,@dyn2,reachStep2,cP2,C2);
% Output layers 
layer7 = ODEblockLayer(odeblock2,cP1,reachStep1,false);
neuralLayers = {layer1,layer2,layer3,layer4,layer5,layer6,layer7,layer8};
neuralode = NeuralODE(neuralLayers);

%% Reachability run #1 (b)
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
Star.plotBoxes_2D_noFill(Rb,1,2,'k');
pg = plot(yyy(1,1),yyy(2,1),'k');
xlabel('x_1');
ylabel('x_2');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj1_cav3_b.pdf','ContentType','vector');
% saveas(f,"traj1_cav3_b.png");


f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,3,'k');
pg = plot(yyy(1,1),yyy(3,1),'k');
xlabel('x_1');
ylabel('x_3');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj2_cav3_b.pdf','ContentType','vector');
% saveas(f,"traj2_cav3_b.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,2,3,'k');
pg = plot(yyy(2,1),yyy(3,1),'k');
xlabel('x_2');
ylabel('x_3');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj3_cav3_b.pdf','ContentType','vector');
% saveas(f,"traj3_cav3_b.png");

% tvec = 0:reachStep1:cP1; % time vector for plotting
% f = figure;
% Star.plotRanges_2D(Rb,1,tvec,'k');
% hold on;
% pg = plot(0, yyy(1,1),'k');
% xlabel('Time (s)');
% ylabel('x_1)');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT1_cav3_b.pdf','ContentType','vector');
% % saveas(f,"trajT1_cav3_b.png");
% 
% f = figure;
% Star.plotRanges_2D(Rb,2,tvec,'k');
% hold on;
% pg = plot(0, yyy(2,1),'k');
% xlabel('Time (s)');
% ylabel('x_2');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT2_cav3_b.pdf','ContentType','vector');
% % saveas(f,"trajT2_cav3_b.png");
% 
% f = figure;
% Star.plotRanges_2D(Rb,3,tvec,'k');
% hold on;
% pg = plot(0, yyy(3,1),'k');
% xlabel('Time (s)');
% ylabel('x_3');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT3_cav3_b.pdf','ContentType','vector');
% % saveas(f,"trajT3_cav3_b.png");

%% Reachability run #2 (b)
odeblock1 = NonLinearODE(6,1,@dyn1,reachStep1,cP1,C1); % Nonlinear ODE
layer4 = ODEblockLayer(odeblock1,cP1,reachStep1,true);
odeblock2 = NonLinearODE(3,1,@dyn2,reachStep2,cP2,C2);
layer7 = ODEblockLayer(odeblock2,cP1,reachStep1,false);
neuralLayers = {layer1,layer2,layer3,layer4,layer5,layer6,layer7,layer8};
neuralode = NeuralODE(neuralLayers);

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
Star.plotBoxes_2D_noFill(Rb,1,2,'k');
pg = plot(yyy(1,1),yyy(2,1),'k');
xlabel('x_1');
ylabel('x_2');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj1_cav3_a.pdf','ContentType','vector');
% saveas(f,"traj1_cav3_a.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,3,'k');
pg = plot(yyy(1,1),yyy(3,1),'k');
xlabel('x_1');
ylabel('x_3');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj2_cav3_a.pdf','ContentType','vector');
% saveas(f,"traj2_cav3_a.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,2,3,'k');
pg = plot(yyy(2,1),yyy(3,1),'k');
xlabel('x_2');
ylabel('x_3');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj3_cav3_a.pdf','ContentType','vector');
% saveas(f,"traj3_cav3_a.png");

% tvec = 0:reachStep1:cP1; % time vector for plotting
% f = figure;
% Star.plotRanges_2D(Rb,1,tvec,'k');
% hold on;
% pg = plot(0, yyy(1,1),'k');
% xlabel('Time (s)');
% ylabel('x_1');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT1_cav3_a.pdf','ContentType','vector');
% % saveas(f,"trajT1_cav3_a.png");
% 
% f = figure;
% Star.plotRanges_2D(Rb,2,tvec,'k');
% hold on;
% pg = plot(0, yyy(2,1),'k');
% xlabel('Time (s)');
% ylabel('x_2');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT2_cav3_a.pdf','ContentType','vector');
% % saveas(f,"trajT2_cav3_a.png");
% 
% f = figure;
% Star.plotRanges_2D(Rb,3,tvec,'k');
% hold on;
% pg = plot(0, yyy(3,1),'k');
% xlabel('Time (s)');
% ylabel('x_3');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT3_cav3_a.pdf','ContentType','vector');
% % saveas(f,"trajT3_cav3_a.png");

%% Reachability run #3 (c)
odeblock1 = NonLinearODE(6,1,@dyn1,reachStep1,cP1,C1); % Nonlinear ODE
layer4 = ODEblockLayer(odeblock1,cP1,reachStep1,true);
odeblock2 = NonLinearODE(3,1,@dyn2,reachStep2,cP2,C2);
layer7 = ODEblockLayer(odeblock2,cP1,reachStep1,false);
neuralLayers = {layer1,layer2,layer3,layer4,layer5,layer6,layer7,layer8};
neuralode = NeuralODE(neuralLayers);

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
Star.plotBoxes_2D_noFill(Rb,1,2,'k');
pg = plot(yyy(1,1),yyy(2,1),'k');
xlabel('x_1');
ylabel('x_2');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj1_cav3_c.pdf','ContentType','vector');
% saveas(f,"traj1_cav3_c.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,3,'k');
pg = plot(yyy(1,1),yyy(3,1),'k');
xlabel('x_1');
ylabel('x_3');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj2_cav3_c.pdf','ContentType','vector');
% saveas(f,"traj2_cav3_c.png");

f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,2,3,'k');
pg = plot(yyy(1,1),yyy(3,1),'k');
xlabel('x_2');
ylabel('x_3');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
exportgraphics(f,'traj3_cav3_c.pdf','ContentType','vector');
% saveas(f,"traj3_cav3_c.png");

% tvec = 0:reachStep1:cP1; % time vector for plotting
% f = figure;
% Star.plotRanges_2D(Rb,1,tvec,'k');
% hold on;
% pg = plot(0, yyy(1,1),'k');
% xlabel('Time (s)');
% ylabel('x_1');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT1_cav3_c.pdf','ContentType','vector');
% % saveas(f,"trajT1_cav3_c.png");
% 
% f = figure;
% Star.plotRanges_2D(Rb,2,tvec,'k');
% hold on;
% pg = plot(0, yyy(2,1),'k');
% xlabel('Time (s)');
% ylabel('x_2');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT2_cav3_c.pdf','ContentType','vector');
% % saveas(f,"trajT2_cav3_c.png");
% 
% f = figure;
% Star.plotRanges_2D(Rb,3,tvec,'k');
% hold on;
% pg = plot(0, yyy(3,1),'k');
% xlabel('Time (s)');
% ylabel('x_3');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% legend(pg,{'NNVODE (ours)'},"Location","best",'FontSize',14);
% exportgraphics(f,'trajT3_cav3_c.pdf','ContentType','vector');
% % saveas(f,"trajT3_cav3_c.png");

save('reach_cav3.mat','ta','tb','tc');

% Dynamics of first ODElayer
function dx = dyn1(x,t)
    global w41 b41 w42 b42;
%     dx1 = logsig(w41*x+b41);
    dx1 = w41*x+b41;
    dx = logsig(w42*dx1+b42);
%     dx = w42*dx1+b42;
end

function dx = dyn2(x,t)
    global w7 b7;
    dx = tanh(w7*x+b7);
end
