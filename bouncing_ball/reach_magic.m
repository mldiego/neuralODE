% Hand picked neural ODE reachability example
controlPeriod = 0.01; % total seconds
reachStep = 0.005; % smaller reachStep, more accurate, longer computation
C = eye(2); % Want to get both of the outputs from NeuralODE
dim = 2;
nnode = NonLinearODE(dim,1,@magicBBall,reachStep,controlPeriod,C); % Nonlinear ODE plant 

x0 = [15;0];
u = 0;
tf = 8;
tvec = 0:controlPeriod:tf;
states = zeros(dim+2,length(tvec));
% jumps = zeros(2,length(tvec));
for step=1:length(tvec)
%     states(:,step) = x0;
    [~,y] = nnode.evaluate(x0,u);
    yt = y(end,:)';
%     jump = satlin(-1000000000000*yt(1));
    jump = heaviside(-1*yt(1));
    x2_jump = 2*(-0.9)*jump;
    states(:,step) = [x0;jump;x2_jump];
    x01 = yt(1);
    x02 = yt(2)+yt(2)*x2_jump;
    x0 = [x01;x02];
end

f = figure;
hold on;
plot(tvec,states(1,:),'r');
plot(tvec,states(2,:),'b');
plot(tvec,states(3,:),'k');
xlim([0 10]);
ylim([-20 20]);
xlabel('Time (s)');
title('Hybrid System');
saveas(f,'HybridSystem_sim.png');


%% Same, but with NNs
% The above equations are correctly representing the dynamics of a bouncing
% ball when the size step is small (0.01 or smaller)

% NN1 can be converted into a linear (state-space form) ODE
A = [0 1;0 0]; 
B = [0; -9.81];
% Convert in form of a linear ODE model
state_vars = 2;
outputs = 2;
inputs = 1;
C = eye(state_vars);
D = zeros(outputs,1);
numSteps = controlPeriod/reachStep;
odeblock = LinearODE(A,B,C,D,controlPeriod,numSteps);
% Neural network 2 - Satlin network - heaviside function replaces it, but
% NN2 keeps same architecture
% w2 = -100000000000000;
% b2 = 0;
% layer2 = LayerS(w2,b2,'satlin');
layer3 = LayerS(2*(-0.9),0,'purelin');
% layers2 = [layer2, layer3];
% net2 = FFNNS(layers2);
net2 = FFNNS(layer3);

% Last computation will me made manually with affineMap (simple multiplication)

% Initialize simulation
x0 = [15;0];
u = 0;
statesNN = zeros(dim+1,length(tvec));
% Simulation using the neural network (neural ODE)
for step=1:length(tvec)
%     states(:,step) = x0;
    [~,y] = nnode.evaluate(x0,u);
    yt = y(end,:)';
    jump = heaviside(-1*yt(1));
    jump = net2.evaluate(jump);
    statesNN(:,step) = [x0;jump];
    x01 = yt(1);
    x02 = yt(2)+yt(2)*jump;
    x0 = [x01;x02];
end

f = figure;
hold on;
plot(tvec,statesNN(1,:),'r');
plot(tvec,statesNN(2,:),'b');
plot(tvec,statesNN(3,:),'k');
xlim([0 10]);
ylim([-20 20]);
xlabel('Time (s)');
title('Neural Event ODE');
saveas(f,'NeuralEventODE_sim.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% We shall try the reachability analysis of THE SYSTEM %
X0 = Star([14.9;0.0],[15.1;0.1]);
U = Star(1,1);
% statesNN = zeros(dim+1,length(tvec));
sets = [];
numSteps = 10;
reachStep = controlPeriod/numSteps;
net3 = FFNNS(LayerS([1 1],0,'purelin'));
% for step=1:length(tvec)
treach = num2cell([tvec;tvec]);
for step=1:length(tvec)
    Xt = [];
    for xx=X0
        X1 = odeblock.simReach('direct',xx,U,reachStep,numSteps);
    %     X1 = odeblock.simReach('direct',X0,U,controlPeriod,2);
    %     X1 = nnode.stepReachStar(X0,U);
        X1end = X1(end);
        Xpos = X1end.affineMap([1 0],[]);
        Xvel = X1end.affineMap([0 1],[]);
        scalar = reach_heaviside(Xpos,Xvel);
%         Xt = [];
        for sc=scalar
            scal = net2.evaluate(sc);
            Xvel2 = Xvel.affineMap(scal,[]);
            X3in = Star([Xvel.V;Xvel2.V],Xvel.C,Xvel.d,Xvel.predicate_lb,Xvel.predicate_ub);
            X3out = net3.reach(X3in,'approx-star');
            Xtemp = Star([Xpos.V;X3out.V],Xvel.C,Xpos.d,Xpos.predicate_lb,Xpos.predicate_ub);
            Xt = [Xt Xtemp];
        end
    end
    X0 = Xt; % Update initial state 
    sets = [sets X0];
    treach{2,step} = sets;
end

f = figure;
Star.plotBoxes_2D_noFill(sets,1,2,'b');
hold on;
scatter(statesNN(1,:),statesNN(2,:),'.r');
title('Neural Event ODE');
xlabel('Position (m)');
ylabel('Velocity (m/s)');
saveas(f,'NeuralEventODE_reach.png');

f = figure;
hold on;
plot_with_time(treach,1,'r');
plot_with_time(treach,2,'b');
title('Neural Event ODE');
xlabel('Time (s)');
% ylabel('Velocity (m/s)');
saveas(f,'NeuralEventODE_reach_time.png');


%% Helper Functions

function scalar_jump = reach_heaviside(X_star,Xvel)
    [a1,a2] = X_star.getRanges;
    [a3,~] = Xvel.getRanges;
    if a3>0
        scalar_jump = 0; %If velocity is positive (going up), no jumps are allowed
    % There are 3 other cases (0, 1 or [0,1])
    elseif a1 < 0
        if a2 < 0
            scalar_jump = 1;
        elseif a2 >= 0
%             warning('We should be issuing 2 sets');
            scalar_jump = [0, 1];
%             scalar_jump = 1;
        else
            error('Wrong ranges');
        end
    elseif a1 >= 0
        scalar_jump = 0;
    else
        error('Wrong ranges')
    end
end

function plot_with_time(treach,index,color)
    n = length(treach);
    [ymin, ymax] = treach{2,1}.getRange(index);
    y = [ymin ymax];
    x = [treach{1,1} treach{1,1}];
    plot(x, y, color);
    hold on;
    for i=2:n
        for ss=1:length(treach{2,i})
            [ymin, ymax] = treach{2,i}(ss).getRange(index);
            y = [ymin ymin ymax ymax ymin];
            x = [treach{1,i-1} treach{1,i} treach{1,i} treach{1,i-1} treach{1,i-1}];
            plot(x, y, color)
%             hold on; 
        end
    end
    hold off;
end