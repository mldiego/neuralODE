%% Try recreating neural ODE examples from torchDiffeq
% In torch layers are defined with 3 layers, 2 in NNV (tanh & linear)
% If want to keep training neural ODEs in pytorch, may want to automate the
% process of transferring parameters and architecture to MATLAB


% Layer 1
w1 = [-0.21494997, -0.5349672;
      -0.474923  , -0.40800333;
      0.51359445, -0.26980552;
       -0.44382808, 0.43869254];
b1 = [.02499252, -0.00268107,  0.00835384, -0.01090521]';
act_func1 = 'tansig';
layer1 = LayerS(w1,b1,act_func1);
% Layer 2
w2 = [1.5686066 ,  1.324116  ,  0.77145904, -1.10245;
       -0.62316656, -1.2899268 ,  1.4636261 , -1.2737932];
b2 = [-0.05339327, -0.0138618]';
act_func2 = 'purelin';
layer2 = LayerS(w2,b2,act_func1);
% Neural ODE
Layers = [layer1 layer2];
nnode = FFNNS(Layers); % neural network controller

% Simulate nnode
x = [1;1]; % input
x = x.^3;
y = nnode.evaluate(x);
% Step 2
x = y.^3; % input
yn = nnode.evaluate(x);
% Step 3
x = y.^3; % input
yn = nnode.evaluate(x);
