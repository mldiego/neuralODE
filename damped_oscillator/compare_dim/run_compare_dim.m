% Set parameters
unc = 0.01;
unc_all = false;
cpath = "/home/manzand/Documents/Python/sonode/experiments/damped_oscillators_linear/anode(";
for dim=1:1:20
    if dim==1
        pathfile = '/home/manzand/Documents/Python/sonode/experiments/damped_oscillators_linear/anode(1)./1./model.mat';
    else
        pathfile = cpath+string(dim)+")./4./model.mat";
    end
        reach_anode(pathfile,dim, unc, unc_all);
end