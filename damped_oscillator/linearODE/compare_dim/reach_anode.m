function reach_anode(filepath, dim, unc, unc_all)
    % Reachability analysis of a Neural ODE

    %% Define layers and neural ODE
    controlPeriod = 10; % total seconds
    reachStep = 0.01; % 1 second
    % Load parameters
    load(filepath);
    % Contruct NeuralODE
    % ODEBlock only linear layers
    % Convert in form of a linear ODE model
    states = 2+dim; % 2 + 1 augmented dimension
    outputs = 2+dim; % Only actual dimensions
    inputs = 1;
    if dim ~= 18
        w1 = Wb{1};
        b1 = Wb{2}';
        w2 = Wb{3};
        b2 = Wb{4}';
        w3 = Wb{5};
        b3 = Wb{6}';
    else
        b1 = b1';
        b2 = b2';
        b3 = b3';
    end
    Aout = w3*w2*w1;
    Bout = b3 + w3*w2*b1 + w3*b2;
    Cout = eye(states);
    D = zeros(outputs,1);
    numSteps = controlPeriod/reachStep;
    odeblock = LinearODE(Aout,Bout,Cout,D,controlPeriod,numSteps);
    % Output layers 
    odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
    neuralLayers = {odelayer};
    neuralode = NeuralODE(neuralLayers);
    name = "DampedOsc_augDim_"+string(dim);

    %% Reachability run #1
    % Setup
    x0 = [-1.4996;-0.4609]; % Initial state first trajectory
    if unc_all
        x0 = [x0;zeros(dim,1)];
        lb = x0-unc;
        ub = x0+unc;
    else
        lb = x0-unc;
        lb = [lb;zeros(dim,1)];
        ub = x0+unc;
        ub = [ub;zeros(dim,1)];
        x0 = [x0;zeros(dim,1)];
    end
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
    title('Damped Oscillator');
    xlabel('x_1');
    ylabel('x_2');
    saveas(f,name+"_traj1.png");

    %% Reachability run #2
    % Setup
    x0 = [2.4714;0.3462]; % Initial state second trajectory
    if unc_all
        x0 = [x0;zeros(dim,1)];
        lb = x0-unc;
        ub = x0+unc;
    else
        lb = x0-unc;
        lb = [lb;zeros(dim,1)];
        ub = x0+unc;
        ub = [ub;zeros(dim,1)];
        x0 = [x0;zeros(dim,1)];
    end
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
    title('Damped Oscillator');
    xlabel('x_1');
    ylabel('x_2');
    saveas(f,name+"_traj2.png");

    %% Reachability run #3
    % Setup
    x0 = [0.2647;-0.0339]; % Initial state third trajectory
    if unc_all
        x0 = [x0;zeros(dim,1)];
        lb = x0-unc;
        ub = x0+unc;
    else
        lb = x0-unc;
        lb = [lb;zeros(dim,1)];
        ub = x0+unc;
        ub = [ub;zeros(dim,1)];
        x0 = [x0;zeros(dim,1)];
    end
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
    title('Damped Oscillator');
    xlabel('x_1');
    ylabel('x_2');
    saveas(f,name+"_traj3.png");

    %% Save results
    % May want to set equal axes so that the set representations are equally
    % visualized
    save("reach"+string(dim)+".mat",'ta','tb','tc');
end