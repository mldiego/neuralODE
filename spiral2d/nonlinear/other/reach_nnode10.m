%% Attempt to do reachability analysis of a Neural Network ODE
% Function defined in a different file for CORA
controlPeriod = 2.1; % total seconds
reachStep = 0.001; % smaller reachStep, more accurate, longer computation
C = eye(2); % Want to get both of the outputs from NeuralODE
nnode = NonLinearODE(2,2,@nnode_demo10,reachStep,controlPeriod,C); % Nonlinear ODE plant 

% Setup
x0 = [2.005;0.005]; % This is like the initial input to the ODeblock
u = 0; % Initial input chosen (no inputs as for dynamical plants)

R0 = Star([2;0],[2.01;0.01]);
U = Star([0;0],[0;0]);

% Reachability
R = nnode.stepReachStar(R0,U);

% Simulation
[tV,y] = nnode.evaluate(x0,u);

% Plot results
figure;
hold on;
Star.plotBoxes_2D_noFill([R0 nnode.intermediate_reachSet],1,2,'r');
plot(y(:,1),y(:,2),'b');
title('NeuralODE demo - NNV - 2.1');
xlabel('x_1');
ylabel('x_2');

%%%%%%%%%% Reachability example 2 - NNV - This works as it should

% Function defined in a different file for CORA
controlPeriod = 25; % total seconds
reachStep = 0.001; % smaller reachStep, more accurate, longer computation
C = eye(2); % Want to get both of the outputs from NeuralODE
nnode2 = NonLinearODE(2,2,@nnode_demo10,reachStep,controlPeriod,C); % Nonlinear ODE plant 

% Reachability
R2 = nnode2.stepReachStar(R0,U);

% Simulation
[tV2,y2] = nnode2.evaluate(x0,u);

% Simulation
nnode2.params.tFinal = 25;
[tV3,y3] = nnode2.evaluate(x0,u);

% Plot results
figure;
hold on;
Star.plotBoxes_2D_noFill([R0 nnode2.intermediate_reachSet],1,2,'r');
plot(y3(:,1),y3(:,2),'b');
title('NeuralODE demo - NNV - 1.5');
xlabel('x_1');
ylabel('x_2');


%% Notes
% Sometimes simulations does not match the reachable set trajectories
% Let's compare our implementation with CORA's

%% CORA reachability
R0c = zonotope([R0.Z.c, R0.Z.V]);
Uc = zonotope([U.Z.c, U.Z.V]);
params1 = nnode.params;
params1.tFinal = 1.5;
params1.U = Uc;
params1.R0 = R0c;

sys = nonlinearSys(nnode.dynamics_func, 2, 2); % CORA nonlinearSys class
Rc = reach(sys, params1, nnode.options); % CORA reach method using zonotope and conservative linearization

simOpt = nnode.options;
simOpt.x0 = x0;
simOpt.tFinal = 1.5;
simOpt.u = u;
[t,yc] = simulate(sys, simOpt);

figure;
hold on;
plot(Rc,[1 2],'r','Filled',false);
plot(yc(:,1),yc(:,2),'b');
title('NeuralODE demo - CORA - 1.5');
xlabel('x_1');
ylabel('x_2');

%%%%%%% Reachability example 2 - CORA %%%%%%%%%%%%%%
R0c = zonotope([R0.Z.c, R0.Z.V]);
Uc = zonotope([U.Z.c, U.Z.V]);
params2 = nnode.params;
params2.tFinal = 2.1;
params2.U = Uc;
params2.R0 = R0c;

sys2 = nonlinearSys(nnode.dynamics_func, 2, 2); % CORA nonlinearSys class
Rc2 = reach(sys2, params2, nnode.options); % CORA reach method using zonotope and conservative linearization

simOpt = nnode.options;
simOpt.x0 = x0;
simOpt.tFinal = 2.1;
simOpt.u = u;
[t2,yc2] = simulate(sys2, simOpt);

simOpt = nnode.options;
simOpt.x0 = x0;
simOpt.tFinal = 25;
simOpt.u = u;
[t3,yc3] = simulate(sys2, simOpt);

figure;
hold on;
plot(Rc2,[1 2],'r','Filled',false);
plot(yc2(:,1),yc2(:,2),'b');
title('NeuralODE demo - CORA - 2.5');
xlabel('x_1');
ylabel('x_2');


%% Visualize all results together
figure;
hold on;
plot(Rc2,[1 2],'r','Filled',false);
plot(Rc,[1 2],'m','Filled',false);
plot(yc(:,1),yc(:,2),'k');
plot(yc2(:,1),yc2(:,2),'b');
plot(yc3(:,1),yc3(:,2),'g');
title('NeuralODE demo - CORA');
xlabel('x_1');
ylabel('x_2');


figure;
hold on;
Star.plotBoxes_2D_noFill([R0 nnode.intermediate_reachSet],1,2,'r');
Star.plotBoxes_2D_noFill([R0 nnode2.intermediate_reachSet],1,2,'m');
plot(y(:,1),y(:,2),'b');
plot(y2(:,1),y2(:,2),'k');
plot(y3(:,1),y3(:,2),'g');
title('NeuralODE demo - NNV');
xlabel('x_1');
ylabel('x_2');

%% Notes
% After setting a low relative tolerance and absolute tolerance in NNV's 
% wrapper simulation, we achieve the expected results