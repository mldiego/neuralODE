%% Create MNIST results table
files_to_load = ["ffnn/ffnn_large_nnv","ffnn/ffnn_nnv","ffnn/ffnn_small_nnv",...
    "cnn/cnn_small_nnv","cnn/cnn_medium_nnv","cnn/cnn_tiny_nnv",...
    "ffnn/eval.mat","cnn/eval.mat"];

names = {'fnn_small';'fnn_mid';'fnn_large';'cnn_small';'cnn_mid';'cnn_large'};
% Run 1: 10% noise
fnl = load(files_to_load{1}+"_12.75.mat");
fnm = load(files_to_load{2}+"_12.75.mat");
fns = load(files_to_load{3}+"_12.75.mat");
cnl = load(files_to_load{4}+"12.75.mat");
cnm = load(files_to_load{5}+"12.75.mat");
cns = load(files_to_load{6}+"_12.75.mat");
evalf = load(files_to_load{7});
evalc = load(files_to_load{8});
% Create tables
acc = [evalf.acc_small; evalf.acc_medium; evalf.acc_large; evalc.acc_tiny; evalc.acc_medium; evalc.acc_small];
robs = [fns.rob/fns.numT;fnm.rob/fnm.numT;fnl.rob/fnl.numT;cns.rob/cns.numT;cnm.rob/cnm.numT;cnl.rob/cnl.numT;];
timeA = [fns.timeT/fns.numT;fnm.timeT/fnm.numT;fnl.timeT/fnl.numT;cns.timeT/cns.numT;cnm.timeT/cnm.numT;cnl.timeT/cnl.numT;];

% Run 2: 5% noise
fnl = load(files_to_load{1}+"_25.5.mat");
fnm = load(files_to_load{2}+"_25.5.mat");
fns = load(files_to_load{3}+"_25.5.mat");
cnl = load(files_to_load{4}+"25.5.mat");
cnm = load(files_to_load{5}+"25.5.mat");
cns = load(files_to_load{6}+"_25.5.mat");

% Create columns
robs2 = [fns.rob/fns.numT;fnm.rob/fnm.numT;fnl.rob/fnl.numT;cns.rob/cns.numT;cnm.rob/cnm.numT;cnl.rob/cnl.numT;];
timeA2 = [fns.timeT/fns.numT;fnm.timeT/fnm.numT;fnl.timeT/fnl.numT;cns.timeT/cns.numT;cnm.timeT/cnm.numT;cnl.timeT/cnl.numT;];

% names = ["NODEsmall";"NODEmid";"NODElarge";"CNODEsmall";"CNODEmid";"CNODElarge"];
colmns = {'Accuracy (%)' 'Robust (10%)' 'Time (s)' 'Robust (10%)' 'Time (s)'}; % Add another run of results?
T = table(acc,robs,timeA,robs2,timeA2);

% T.Properties.VariableNames = colmns;

table2latex(T,'mnist_res.tex')