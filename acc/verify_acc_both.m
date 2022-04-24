%% Verify neual ODE = NNCS ACC
plant_data = load('plant_3rd_order_node.mat');
controller_data = load("controller_node.mat");

% Two ways to test, as a NNCS, or as one neural ODE. Will it be the same
% similar enough?
%% Verification scenario
% initial condition of x_lead
% xlead = [108 110];
xlead = [90 92];
% x_lead = cell(10, 1);
% x_lead{1, 1} = [108 110];
% x_lead{2, 1} = [106 108];
% x_lead{3, 1} = [104 106];
% x_lead{4, 1} = [102 104];
% x_lead{5, 1} = [100 102];
% x_lead{6, 1} = [98 100];
% x_lead{7, 1} = [96 98];
% x_lead{8, 1} = [94 96];
% x_lead{9, 1} = [92 94];
% x_lead{10, 1} = [90 92];
% initial condition of v_lead
v_lead = [32 32.2];
% initial condition of x_internal_lead
% internal_acc_lead = [0 0];
% initial condition of x_ego
x_ego = [10 11]; 
% initial condition of v_ego
v_ego = [30 30.2];
% initial condition of x_internal_ego
% internal_acc_ego = [0 0];
% initial input accel
a_lead = 0;
a_ego = 0;

% safety specification: relative distance > safe distance
% dis = x_lead - x_ego  
% safe distance between two cars, see here 
% https://www.mathworks.com/help/mpc/examples/design-an-adaptive-cruise-control-system-using-model-predictive-control.html
% dis_safe = D_default + t_gap * v_ego;
t_gap = 1.4;
D_default = 10;
vset = 30;

% safety specification: x_lead - x_ego - t_gap * v_ego - D_default > 0
% unsafe region: x_lead - x_ego - t_gap * v_ego <= D_default 
% unsafe_mat = [1 0 0 -1 -t_gap 0];
% unsafe_vec = [D_default];


%% Method 1 -- NNCS with control period = 0.1
% N = 50;  % Number of control steps
cp = 0.1; % Control step
ts = 0.01; % Verification time step for plant dynamics
numSteps = cp/ts;
% The dynamical models (ODEs) have to be passed as function handles so we
% will define them at the end of the script
% 1) Define car plant as a linear ODE
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
linearcar = LinearODE(A3rd,B3rd,C,D,cp,10);
% car_node = NeuralODE({linearcar});
% 2) Define the controller
w1 = controller_data.neuralOdeParameters.fc1.Weights;
b1 = controller_data.neuralOdeParameters.fc1.Bias;
w2 = controller_data.neuralOdeParameters.fc2.Weights;
b2 = controller_data.neuralOdeParameters.fc2.Bias;
Ac = extractdata(w2*w1);
Bc = extractdata(b2 + w2*b1);
Cc = zeros(5); Cc(1)=1;
Dc = zeros(5,1);
linearCon = LinearODE(Ac,Bc,Cc,Dc,cp,10);

U = Star(1,1);
% [xlead,vlead,a_int_lead,xego,vego,z_int_ego,aego,alead]
lb = [xlead(1);v_lead(1);0;x_ego(1);v_ego(1);0;0;0]; %lower bound
ub = [xlead(2);v_lead(2);0;x_ego(2);v_ego(2);0;0;0]; % upper bound
X0 = Star(lb,ub); %
map_mat = [0 0 0 0 1 0 0 0;
            1 0 0 -1 0 0 0 0;
            0 1 0 0 -1 0 0 0];
U_fix = Star([30;1.4],[30;1.4]); % vset and tgap
Up_fix = Star(0,0); % a_lead (var 8)
cont_map = [0 0 0 0 1];


% Perform reachability analysis
trajR = X0;
trajU = [];
N = 50;
for k=1:N
    R1 = linearcar.simReach('direct', X0, U, ts, 10, []); % reachability of plant
    X0 = R1(end); % Get only last reach set (reach set at control period)
    trajR = [trajR X0]; % Keep track of trajectory of NNCS
%     Xout = X0.affineMap(C(1:6,:),[]);
    ppp = X0.affineMap(map_mat,[]);
    Uin = U_fix.concatenate(ppp);
    Rc = linearCon.simReach('direct', Uin, U, cp, 1, []); % reachability of controller
    Rc = Rc(end); % Get only last reach set (reach set at control period)
    Rc = Rc.affineMap(cont_map,[]); % Only care about output #1
    trajU = [trajU Rc];
    x08 = X0.affineMap([0 0 0 0 0 0 0 1],[]);
    X0 = X0.affineMap(C(1:6,:),[]); % Get set for variables 1 to 6
    X0 = X0.concatenate(Rc); % Add state/input 7 (a_ego)
%     X0 = X0.concatenate(Up_fix); % Add state/input 8 (a_lead) constant = 0
    X0 = X0.concatenate(x08);
    if X0.nVar > 1000
        X0 = X0.getBox;
        X0 = X0.toStar;
    end
%     disp("Sim Time = "+string(k*cp));
end

% Visualize results
% figure;
% hold on;
% Star.plotBoxes_2D_noFill(trajR,1,2,'r');
% xlabel('xlead')
% ylabel('vlead')
% figure;
% hold on;
% Star.plotBoxes_2D_noFill(trajR,1,4,'r');
% xlabel('xlead')
% ylabel('xego')
% figure;
% hold on;
% Star.plotBoxes_2D_noFill(trajR,4,5,'r');
% xlabel('xego')
% ylabel('vego')
times = 0:0.1:0.1*N;
% Visualize distance vs safe_distance
% safety specification: distance > alp * safe_distance
map = [1 0 0 -1 0 0 0 0; 0 0 0 0 1 0 0 0]; % get distance between two cars and velocity of ego car
S = [];
for i=1:N+1
    S = [S trajR(i).affineMap(map, [])];
end
% safe_distance vs. velocity
alp = 1;
map1 = [0 0 0 0 alp*t_gap 0 0 0; 0 0 0 0 1 0 0 0]; % safe distance and velocity of ego car
S1 = [];
for i=1:N+1
    S1 = [S1 trajR(i).affineMap(map1, [alp*D_default; 0])];
end
% Get individual sets for each variable
dis = [];
safe_dis = [];
ego_vel = [];
lead_vel = [];
for i=1:length(trajR)
    dis = [dis trajR(i).affineMap([1 0 0 -1 0 0 0 0], [])];
    safe_dis = [safe_dis trajR(i).affineMap([0 0 0 0 alp*t_gap 0 0 0], alp*D_default)];
    ego_vel = [ego_vel trajR(i).affineMap([0 0 0 0 1 0 0 0], [])];
    lead_vel = [lead_vel trajR(i).affineMap([0 1 0 0 0 0 0 0], [])];
end
figure;
hold on;
plot(0,xlead(1)-x_ego(1),'b','DisplayName','dis')
plot(0,xlead(1)-x_ego(1),'r','DisplayName','safe_dis')
legend('AutoUpdate','off');
Star.plotRanges_2D(dis,1,times,'b');
hold on;
Star.plotRanges_2D(safe_dis,1,times,'r');
legend;
xlabel('Time (s)')
ylabel('Distance (m)')
figure;
hold on;
plot(0,v_ego(1),'r','DisplayName','ego')
plot(0,v_lead(1),'b','DisplayName','lead')
legend('AutoUpdate','off');
Star.plotRanges_2D(ego_vel,1,times,'b');
hold on;
Star.plotRanges_2D(lead_vel,1,times,'r');
xlabel('Time (s)')
ylabel('Speed (m/s)')
% Visualize output set of controller
figure;
Star.plotRanges_2D(trajU,1,times(2:end),'k')
xlabel('Time (s)')
ylabel('a_{ego}')

%% Method 2 -- Neural ODE
tf = N*cp; % 5 seconds









%% Helper Function and Neural ODE definitions
% Linear model (no definiiton required, good for understanding
% function dx = nncs(x,u)
% global plant_data controller_data
%   xp = x(1:8);
%   yp = w1*xp+b1;
%   yp = w2*dx+b2;
%   dx(1,6) = yp(1:6);
%   dx(9) = 0; % vset
%   dx(10) = 0; % t_gap
%   xc = [x9;x10;x5;x1-x4;x2-x5];
%   yc = W1*xc+B1;
%   yc = W2*yc+B2;
%   dx(7) = yc(1);
%   dx(8) = 0;
%   dx(11) = x1-x4; % drel % We need to add these two variables to treat the model as a A*X + B;
%   dx(12) = x2-x5; % vrel
% end
% What is this in terms of A, B, C and D?

% Nonlinear model
% function dx = nncs(x,u)
% global plant_data controller_data
% 
% end

% Linear model, no definiton required
% function dx = acc_plant(x,u)
% global plant_data 
% 
% end

% function dx = acc_controller(x,u)
% global controller_data
% 
% end

%% Notes
% Plant dynamics states
% x1 = xlead;     % lead car position
% x2 = vlead;     % lead car velocity
% x3 = ylead;     % lead internal acceleration
% x4 = xego;      % ego car velocity
% x5 = vego;      % ego car velocity
% x6 = yego;      % ego internal acceleration
% x7 = a_ego;     % input acceleration
% x8 = a_lead     % input acceleration
% Controller dynamics states (v_set, t_gap, v_ego, d_rel, v_rel)
% x9 = v_set; dx9 = 0;
% x10 = t_gap; dx10 = 0;
% x11 = v_ego; dx11 = dx5 = x6;
% x12 = d_rel; dx12 = x1-x4;
% x13 = v_rel; dx13 = x2-x5; % Maybe no need to add the last 3 variables in
% the ode, just use the other states and then we may be able to use it all
% within one neural ode
% Not sure this is going to work because we will not be able to reset some
% of the states in the controller, so it should not work actually
