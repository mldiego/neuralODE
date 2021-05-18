function reach_nlanode(dynamics, dim, unc, unc_all)
    % Reachability analysis of a Neural ODE

    %% Define layers and neural ODE
    % Function defined in a different file for CORA
    controlPeriod = 2.0; % total seconds
    reachStep = 0.05; % smaller reachStep, more accurate, longer computation
    C = eye(2+dim); % Want to get both of the outputs from NeuralODE
    % Load neural network parameters
    odeblock = NonLinearODE(2+dim,1,dynamics,reachStep,controlPeriod,C); % Nonlinear ODE plant 
    odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
    neuralode = NeuralODE({odelayer});
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
    odeblock = NonLinearODE(2+dim,1,dynamics,reachStep,controlPeriod,C); % Nonlinear ODE plant 
    odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
    neuralode = NeuralODE({odelayer});
    
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
    odeblock = NonLinearODE(2+dim,1,dynamics,reachStep,controlPeriod,C); % Nonlinear ODE plant 
    odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
    neuralode = NeuralODE({odelayer});
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

