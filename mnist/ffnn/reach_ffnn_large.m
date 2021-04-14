function reach_ffnn_large(pix,numT,noise,XTest,YTest)
%% Reachability analysis of an image classification ODE_FFNN (MNIST)
% Architecture of first ffnn mnist model:
%  - Inputs = 784 (Flatten images to 1D, original 28x28)
%  - Outputs = 10 (One hot vector)
%  - layer1: relu (64)
%  - layer2: relu (32)
%  - layer3: relu (32)
%  - layer4: relu (32)
%  - layer5: linear (16)
%  - layer6: ODEBlock{
%     -linear (10)
%     -linear (10)
%     -linear (10)
%     -linear (16)
%     }
%  - layer7: linear (10)

%% Section 1. odeblock with NNV reachability

%% Part 1. Loading and constructing the NeuralODE

% Load network parameters
file_path = '../../../../Python/neuralODE_examples/mnist/odeffnn_mnist_large.mat';
load(file_path); % Load neuralODe parameters 
% Contruct NeuralODE
layer1 = LayerS(Wb{1},Wb{2}','poslin');
layer2 = LayerS(Wb{3},Wb{4}','poslin');
layer3 = LayerS(Wb{5},Wb{6}','poslin');
layer4 = LayerS(Wb{7},Wb{8}','poslin');
layer5 = LayerS(Wb{9},Wb{10}','purelin');
layers = [layer1 layer2 layer3 layer4 layer5];
net1 = FFNNS(layers); % neural network controller
% ODEBlock only linear layers
% Convert in form of a linear ODE model
states = 16;
outputs = 16;
w1 = Wb{11};
b1 = Wb{12}';
w2 = Wb{13};
b2 = Wb{14}';
w3 = Wb{15};
b3 = Wb{16}';
w4 = Wb{17};
b4 = Wb{18}';
Aout = w4*w3*w2*w1;
Bout = w4*(w3*(w2*b1+b2)+b3)+b4;
Cout = eye(states);
D = zeros(outputs,1);
tfinal = 1;
numSteps = 20;
odeblock = LinearODE(Aout,Bout,Cout,D,tfinal,numSteps);
reachStep = tfinal/numSteps;
% Output layers 
layer7 = LayerS(Wb{19},Wb{20}','purelin');
layer_out = FFNNS(layer7);

%% Part 2. Load data and prepare experiments

noise = noise*255; % noise 1/10 of max pixel value
pixels_attack = randi([1 784],1,pix);
pred = zeros(numT,1);
time = zeros(numT,1);
for i=1:numT
%     img_flat = double(XTest(:,:,:,i));
%     img_flat = extractdata(img_flat);
    img_flat = XTest(:,:,:,i);
    img_flat = reshape(img_flat', [1 784])';
    lb = img_flat;
    ub = img_flat;
    for j=pixels_attack
        ub(j) = min(255, ub(j)+rand*noise);
        lb(j) = max(0, lb(j)-rand*noise);
    end
    % Normalize input (input already normalized)
    lb = lb./255;
    ub = ub./255;
    inpS = Star(lb,ub);
    img_inp = img_flat./255;
    %% Part 3. Reachability and Simulation
    % Divide reachability into steps
    U = [];
    t = tic;
    R1 = net1.reach(inpS,'approx-star');
    R2all = odeblock.simReach('direct',R1,U,reachStep,numSteps); % LinearODE
    R2 = R2all(end);
    R3 = layer_out.reach(R2,'approx-star');
    time(i) = toc(t);
    score = robustScore(R3,YTest(i));
    pred(i) = score;
end

%% Part 3. Robustness results
pred_acc = pred == 1;
timeT = sum(time);
sum_acc = sum(pred_acc);
rob = sum_acc;
acc = sum_acc/numT;
disp(' ');
disp(' ');
disp(' ');
disp('========== Robustness results (NNV) ===========')
disp(' ');
disp('Total images evaluated: '+string(numT));
disp('ATTACK: Random noise, max value = '+string(noise));
disp('Network robust to '+string(sum_acc)+' images.');
disp('Total time to evaluate ' + string(numT) + ' images: ' + string(sum(time)) + ' seconds');
disp('Average time per image: ' + string(sum(time)/numT));

save('ffnn_large_nnv.mat','rob','pred','timeT','pix','numT','noise');

%% Section 2. ODEblock with CORA reachability

%% Part 1. Loading and constructing the NeuralODE

% Convert in form of a linear ODE model
C = eye(16); % Want to get both of the outputs from NeuralODE
odeblockC = LinearODE_cora(Aout,Bout,Cout,D,reachStep,tfinal); % (Non)linear ODE plant 

%% Part 2. Load data and prepare experiments

pred = zeros(numT,1);
timeC = zeros(numT,1);
for i=1:numT
%     img_flat = double(XTest(:,:,:,i));
%     img_flat = extractdata(img_flat);
    img_flat = XTest(:,:,:,i);
    img_flat = reshape(img_flat', [1 784])';
    lb = img_flat;
    ub = img_flat;
    for j=pixels_attack
        ub(j) = min(255, ub(j)+rand*noise);
        lb(j) = max(0, lb(j)-rand*noise);
    end
    % Normalize input (input already normalized)
    lb = lb./255;
    ub = ub./255;
    inpS = Star(lb,ub);
    img_inp = img_flat./255;
    %% Part 3. Reachability and Simulation
    % Divide reachability into steps
    U = Star(0,0);
    t = tic;
    R1 = net1.reach(inpS,'approx-star');
    R2 = odeblockC.stepReachStar(R1,U);
    R3 = layer_out.reach(R2,'approx-star');
    time(i) = toc(t);
    score = robustScore(R3,YTest(i));
    pred(i) = score;
end


%% Robustness results

pred_acc = pred == 1;
timeT = sum(time);
sum_acc = sum(pred_acc);
rob = sum_acc;
acc = sum_acc/numT;
disp(' ');
disp(' ');
disp('========== Robustness results (CORA) ===========')
disp(' ');
disp('Total images evaluated: '+string(numT));
disp('ATTACK: Random noise, max value = '+string(noise));
disp('Network robust to '+string(sum_acc)+' images.');
disp('Total time to evaluate ' + string(numT) + ' images: ' + string(sum(time)) + ' seconds');
disp('Average time per image: ' + string(sum(time)/numT));

save('ffnn_large_cora.mat','rob','pred','timeT','pix','numT','noise');

% Notify finish
sound(tan(1:10000));

end