% Set parameters
unc = 0.01;
cpath = "/home/manzand/Documents/Python/sonode/experiments/damped_oscillators_linear/node./1_1_";
for neur=10:10:60
    pathfile = cpath+string(neur)+"./model.mat";
    reach_node(pathfile, unc);
end