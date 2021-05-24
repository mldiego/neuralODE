%% Create MNIST results table

files_to_load = {'ffnn/ffnn_large_nnv.mat','ffnn/ffnn_nnv.mat','ffnn/ffnn_small_nnv.mat',...
    'cnn/cnn_small_nnv.mat','cnn/cnn_medium_nnv.mat','cnn/cnn_tiny_nnv.mat',...
    'ffnn/eval.mat','cnn/eval.mat'};

names = {'fnn_small';'fnn_mid';'fnn_large';'cnn_small';'cnn_mid';'cnn_large'};
fnl = load(files_to_load{1});
fnm = load(files_to_load{2});
fns = load(files_to_load{3});
cnl = load(files_to_load{4});
cnm = load(files_to_load{5});
cns = load(files_to_load{6});
evalf = load(files_to_load{7});
evalc = load(files_to_load{8});

acc = [evalf.acc_small; evalf.acc_medium; evalf.acc_large; evalc.acc_tiny; evalc.acc_medium; evalc.acc_small];
robs = [fns.rob/fns.numT;fnm.rob/fnm.numT;fnl.rob/fnl.numT;cns.rob/cns.numT;cnm.rob/cnm.numT;cnl.rob/cnl.numT;];
timeA = [fns.timeT/fns.numT;fnm.timeT/fnm.numT;fnl.timeT/fnl.numT;cns.timeT/cns.numT;cnm.timeT/cnm.numT;cnl.timeT/cnl.numT;];

% names = ["NODEsmall";"NODEmid";"NODElarge";"CNODEsmall";"CNODEmid";"CNODElarge"];
colmns = {'Name' 'Accuracy (%)' 'Robust (%)' 'Time (s)'}; % Add another run of results?
T = table(acc,robs,timeA);

% T.Properties.VariableNames = colmns;

table2latex(T,'mnist_res.tex')