% Display no figures
set(0,'DefaultFigureVisible','off')

% Run Piecewise linear neural ODE experiment
disp("Piecewise Linear");
run reach_pwl.m

% Run nonlinear neural ODE experiment
disp("Nonlinear");
run reach_nl.m

% Run cav/emsoft extra experiments
disp("Cav - 1");
run reach_cav1.m

disp("Cav - 2");
run reach_cav2.m

disp("Cav - 3");
run reach_cav3.m

disp("Cav - 5");
run reach_cav5.m

disp("Cav - 6");
run reach_cav6.m

disp("Cav - 4");
run reach_cav4.m

disp("Creating time table");
run process_times.m