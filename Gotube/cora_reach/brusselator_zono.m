%% Reachability analysis of the nonlinear system Brusselator
% Idea is to compare to Gotube and other tools

params.tFinal = 14;
params.R0 = zonotope([[1;1],0.01*eye(2)]);
params.U = zonotope([0,0]);


% Reachability Settings ---------------------------------------------------

options.timeStep = 0.05;
options.taylorTerms = 4;
% options.zonotopeOrder = 50;
options.zonotopeOrder = 20;
% options.zonotopeOrder = 2;
% options.intermediateOrder = 5; 
% options.errorOrder = 1;
options.alg = 'lin';
options.tensorOrder = 2;
% options.tensorOrder = 3;

% options.lagrangeRem.simplify = 'simplify';


% System Dynamics ---------------------------------------------------------

model = nonlinearSys(@Brusselator);


% Reachability Analysis ---------------------------------------------------

tic
R = reach(model, params, options);
tComp = toc;
disp(['computation time of reachable set: ',num2str(tComp)]);


% Simulation --------------------------------------------------------------

simOpt.points = 60;
simOpt.fracVert = 0.5;
simOpt.fracInpVert = 0.5;
simOpt.inpChanges = 6;

simRes = simulateRandom(model, params, simOpt);


% Visualization -----------------------------------------------------------

dims = {[1 2]};

for k = 1:length(dims)
    
    f = figure; hold on; box on;
    projDim = dims{k};
    
    % plot reachable sets
    plot(R,projDim,'FaceColor',[.8 .8 .8],'EdgeColor','b');
    
    % plot initial set
    plot(params.R0,projDim,'w','Filled',true,'EdgeColor','k');
    
    % plot simulation results     
%     plot(simRes,projDim,'b');

    % label plot
    xlabel(['x_{',num2str(projDim(1)),'}']);
    ylabel(['x_{',num2str(projDim(2)),'}']);
end
saveas(f,'../results/Brusselator_zono.png');

% example completed
completed = 1;