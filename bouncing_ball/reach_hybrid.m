% problem description
% params.R0 = zonotope([15;0.0],diag([0.1,0.01]));      % initial set
params.R0 = zonotope([30;0.0;0.0],diag([0.01,0.0,0.0]));      % initial set
params.startLoc = 1;                                % initial location
params.tFinal = 10;                                % final time


% Reachability Options ----------------------------------------------------

% settings for continuous reachability 
options.timeStep = 0.1;
options.taylorTerms = 10;
options.zonotopeOrder = 20;

% settings for hybrid systems
options.guardIntersect = 'polytope';
options.enclose = {'box'}; 


% % Hybrid Automaton --------------------------------------------------------
% 
% % continuous dynamics 
% A = [0 1; 0 0];
% B = [0; 0];
% c = [0; -9.81];
% linSys = linearSys('linearSys',A,B,c);
% 
% % system parameters
% alpha = -0.80;                  % rebound factor
% 
% % invariant set 
% inv = mptPolytope([-1,0],0);
% 
% % guard sets
% guard = conHyperplane([1,0],0,[0,1],0);
% 
% % reset function
% reset.A = [0, 0; 0, alpha]; reset.b = zeros(2,1);
% 
% % transitions
% trans{1} = transition(guard,reset,1);
% 
% % location object
% loc{1} = location('loc1',inv,trans,linSys); 
% 
% % hybrid automata
% HA = hybridAutomaton(loc);

% Hybrid Automaton (w/ time)--------------------------------------------------------

% continuous dynamics 
A = [0 1 0; 0 0 0; 0 0 0];
B = [0; 0; 0];
c = [0; -9.81; 1];
linSys = linearSys('linearSys',A,B,c);

% system parameters
alpha = -0.80;                  % rebound factor

% invariant set 
inv = mptPolytope([-1,0,0],0);

% guard sets
guard = conHyperplane([1,0,0],0,[0,1,0],0);

% reset function
reset.A = [0, 0, 0; 0, alpha, 0; 0 0 1]; reset.b = zeros(3,1);

% transitions
trans{1} = transition(guard,reset,1);

% location object
loc{1} = location('loc1',inv,trans,linSys); 

% hybrid automata
HA_time = hybridAutomaton(loc);


% Reachability Analysis ---------------------------------------------------

tic;
% R = reach(HA,params,options);
R = reach(HA_time,params,options);
tComp = toc;

disp(['Computation time for reachable set: ',num2str(tComp),' s']);


% % Simulation --------------------------------------------------------------
% 
% % settings for random simulation
% simOpt.points = 10;        % number of initial points
% simOpt.fracVert = 0.5;     % fraction of vertices initial set
% simOpt.fracInpVert = 0.5;  % fraction of vertices input set
% simOpt.inpChanges = 10;    % changes of input over time horizon  
% 
% % random simulation
% simRes = simulateRandom(HA,params,simOpt); 



% Visualization -----------------------------------------------------------
try
    load('reach_pos.mat');
catch
    disp('No neuralODE reach set found')
end

f = figure ;
hold on

% plot reachable set
plot(R,[3,1],'w','EdgeColor','k');

% plot initial set
plot(params.R0,[3,1],'r','Filled',true,'EdgeColor','k');

floor = Star([0; -0.1],[11; 0]);

% Star.plotRanges_2D(Rout,1,tvec,'b');
% Star.plotBoxes_2D(floor,1,2,'r');
% title('Bouncing ball');
% xlabel('Time (s)');
% ylabel('Position (m)');
% saveas(f,'Bball_compare_22.png');

% % plot simulated trajectories
% plot(simRes,[1,2],'b');
% 
% axis([0,1.2,-6,4]);
