%% Load different plant models
% 1) Linear (learned)
plant_data = load('plant_3rd_order_node.mat');
states = 8; 
w1 = plant_data.neuralOdeParameters.fc1.Weights;
b1 = plant_data.neuralOdeParameters.fc1.Bias;
w2 = plant_data.neuralOdeParameters.fc2.Weights;
b2 = plant_data.neuralOdeParameters.fc2.Bias;
A = w2*w1;
B = b2 + w2*b1;
A3rd = zeros(8,8);
A3rd(1,:) = [0 1 0 0 0 0 0 0];
A3rd(2,:) = [0 0 1 0 0 0 0 0];
A3rd(3,:) = [0 0 A(1,1) 0 0 A(1,2:4)];
A3rd(4,:) = [0 0 0 0 1 0 0 0];
A3rd(5,:) = [0 0 0 0 0 1 0 0];
A3rd(6,:) = [0 0 A(2,1) 0 0 A(2,2:4)];
A3rd(7,:) = [0 0 A(3,1) 0 0 A(3,2:4)];
A3rd(8,:) = [0 0 A(4,1) 0 0 A(4,2:4)];
B3rd = extractdata([zeros(2,1);B(1);zeros(2,1);B(2:4)]);
C = eye(states); C(7,7) = 0; C(end) = 0;
D = zeros(8,1);
cp = 0.1;
lnt = LinearODE(A3rd,B3rd,C,D,1,100);
% Nonlinear learned
reachStep = 0.01;
controlPeriod = 0.1;
outmat = eye(8);
nl = NonLinearODE(8,1,@tanh_plant, 0.01,1,outmat);
% nl.options.alg = 'poly';
% Car dynamics
reachStep = 0.01;
controlPeriod = 0.1;
output_mat = [0 0 0 0 1 0;1 0 0 -1 0 0; 0 1 0 0 -1 0]; % feedback: relative distance, relative velocity and ego-car velocity
orig = NonLinearODE(6,2,@acc_dynamics, 0.01, 1, output_mat);

%% Compare simulations


%% Compare different reach set trajectories 
% Why are we getting different closed-loop behavior?
% Scenario 1
lb = [90; 32; 0; 10; 30; 0];
ub = [110; 32.2; 0; 11; 30.2; 0];
init_set = Star(lb,ub);
% Input set
input_set = Star([-1;-2],[-1;-2]);
% U = Star(0,0);
U = Star(1,1);
X0 = Star([lb;-1;-2],[ub;-1;-2]);
Ro = orig.stepReachStar(init_set,input_set,'lin');
Ro_all = [init_set orig.intermediate_reachSet];
Rl = lnt.simReach('direct', X0, U, 0.01, 100, []); % reachability of plant
Rnl = nl.stepReachStar(X0,U,'lin');
Rnl_all = [X0 nl.intermediate_reachSet];
% Visualize results
times = 0:0.01:1;
figure;
subplot(2,3,1)
Star.plotRanges_2D(Ro_all,1,times,'r');
hold on;
Star.plotRanges_2D(Rl,1,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,1,times,'g');
xlabel('Time (s)');
ylabel('xlead');
subplot(2,3,2)
Star.plotRanges_2D(Ro_all,2,times,'r');
hold on;
Star.plotRanges_2D(Rl,2,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,2,times,'g');
xlabel('Time (s)')
ylabel('vlead')
subplot(2,3,3)
Star.plotRanges_2D(Ro_all,3,times,'r');
hold on;
Star.plotRanges_2D(Rl,3,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,3,times,'g');
xlabel('Time (s)')
ylabel('alead')
subplot(2,3,4)
Star.plotRanges_2D(Ro_all,4,times,'r');
hold on;
Star.plotRanges_2D(Rl,4,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,4,times,'g');
xlabel('Time (s)')
ylabel('xego')
subplot(2,3,5)
Star.plotRanges_2D(Ro_all,5,times,'r');
hold on;
Star.plotRanges_2D(Rl,5,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,5,times,'g');
xlabel('Time (s)')
ylabel('vego')
subplot(2,3,6)
Star.plotRanges_2D(Ro_all,6,times,'r');
hold on;
Star.plotRanges_2D(Rl,6,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,6,times,'g');
xlabel('Time (s)')
ylabel('aego')

%% Scenario 2
lb = [90; 32; 0; 10; 31; 0];
ub = [110; 32.2; 0; 11; 31.2; 0];
init_set = Star(lb,ub);
% Input set
input_set = Star([1;2],[1;2]);
% U = Star(0,0);
U = Star(1,1);
X0 = Star([lb;1;2],[ub;1;2]);
Ro = orig.stepReachStar(init_set,input_set,'lin');
Ro_all = [init_set orig.intermediate_reachSet(101:end)];
Rl = lnt.simReach('direct', X0, U, 0.01, 100, []); % reachability of plant
Rnl = nl.stepReachStar(X0,U,'lin');
Rnl_all = [X0 nl.intermediate_reachSet(101:end)];
% Visualize results
times = 0:0.01:1;
figure;
subplot(2,3,1)
Star.plotRanges_2D(Ro_all,1,times,'r');
hold on;
Star.plotRanges_2D(Rl,1,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,1,times,'g');
xlabel('Time (s)');
ylabel('xlead');
subplot(2,3,2)
Star.plotRanges_2D(Ro_all,2,times,'r');
hold on;
Star.plotRanges_2D(Rl,2,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,2,times,'g');
xlabel('Time (s)')
ylabel('vlead')
subplot(2,3,3)
Star.plotRanges_2D(Ro_all,3,times,'r');
hold on;
Star.plotRanges_2D(Rl,3,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,3,times,'g');
xlabel('Time (s)')
ylabel('alead')
subplot(2,3,4)
Star.plotRanges_2D(Ro_all,4,times,'r');
hold on;
Star.plotRanges_2D(Rl,4,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,4,times,'g');
xlabel('Time (s)')
ylabel('xego')
subplot(2,3,5)
Star.plotRanges_2D(Ro_all,5,times,'r');
hold on;
Star.plotRanges_2D(Rl,5,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,5,times,'g');
xlabel('Time (s)')
ylabel('vego')
subplot(2,3,6)
Star.plotRanges_2D(Ro_all,6,times,'r');
hold on;
Star.plotRanges_2D(Rl,6,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,6,times,'g');
xlabel('Time (s)')
ylabel('aego')

% Scenario 3
lb = [90; 32; 0; 10; 31; 0];
ub = [110; 32.2; 0; 11; 31.2; 0];
init_set = Star(lb,ub);
% Input set
input_set = Star([0;2],[1;2]);
% U = Star(0,0);
U = Star(1,1);
X0 = Star([lb;0;2],[ub;1;2]);
Ro = orig.stepReachStar(init_set,input_set,'lin');
Ro_all = [init_set orig.intermediate_reachSet(201:end)];
Rl = lnt.simReach('direct', X0, U, 0.01, 100, []); % reachability of plant
Rnl = nl.stepReachStar(X0,U,'lin');
Rnl_all = [X0 nl.intermediate_reachSet(201:end)];
% Visualize results
times = 0:0.01:1;
figure;
subplot(2,3,1)
Star.plotRanges_2D(Ro_all,1,times,'r');
hold on;
Star.plotRanges_2D(Rl,1,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,1,times,'g');
xlabel('Time (s)');
ylabel('xlead');
subplot(2,3,2)
Star.plotRanges_2D(Ro_all,2,times,'r');
hold on;
Star.plotRanges_2D(Rl,2,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,2,times,'g');
xlabel('Time (s)')
ylabel('vlead')
subplot(2,3,3)
Star.plotRanges_2D(Ro_all,3,times,'r');
hold on;
Star.plotRanges_2D(Rl,3,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,3,times,'g');
xlabel('Time (s)')
ylabel('alead')
subplot(2,3,4)
Star.plotRanges_2D(Ro_all,4,times,'r');
hold on;
Star.plotRanges_2D(Rl,4,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,4,times,'g');
xlabel('Time (s)')
ylabel('xego')
subplot(2,3,5)
Star.plotRanges_2D(Ro_all,5,times,'r');
hold on;
Star.plotRanges_2D(Rl,5,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,5,times,'g');
xlabel('Time (s)')
ylabel('vego')
subplot(2,3,6)
Star.plotRanges_2D(Ro_all,6,times,'r');
hold on;
Star.plotRanges_2D(Rl,6,times,'b');
hold on;
Star.plotRanges_2D(Rnl_all,6,times,'g');
xlabel('Time (s)')
ylabel('aego')