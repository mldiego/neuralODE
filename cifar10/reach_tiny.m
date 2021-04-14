function reach_tiny(pix,numT,noise,XTest,YTest,cora)
%% Reachability analysis of an image classification ODE_FFNN (CIFAR)
% Architecture of first ffnn mnist model:
%  - Inputs = 32X32 images 
%  - Outputs = 10 (One hot vector)
%  - layer1: convolutional (3,4,3,1)
%  - layer2: batchnorm (4)
%  - layer3: relu (no weights)
%  - layer4: convolutioanl (4,4,3,1)
%  - layer5: batchnorm (4)
%  - layer6: relu (no weights)
%  - layer7: convolutioanl (4,4,3,1)
%  - layer8: batchnorm (4)
%  - layer9: relu (no weights)
%  - layer10: flatten()
%  - layer11: ODEBlock{
%     -linear (16)
%     -linear (196)
%     }
%  - layer12: linear (10)

%% Section 1. odeblock with NNV reachability

%% Part 1. Loading and constructing the NeuralODE

% Load network parameters
file_path = '/home/manzand/Documents/Python/neuralODE_examples/cifar/odecnn_mnist_tiny.mat';
load(file_path); % Load neuralODe parameters 
% Contruct NeuralODE
w1 = permute(Wb{1},[4 3 2 1]);
b1 = reshape(Wb{2},[1,1,4]);
layer1 = Conv2DLayer(w1,b1,[0,0,0,0],[1,1],[1,1]);
w2 = reshape(Wb{3},[1 1 4]);
b2 = reshape(Wb{4},[1 1 4]);
m2 = reshape(Wb{19},[1 1 4]);
v2 = reshape(Wb{20},[1 1 4]);
layer2 = BatchNormalizationLayer('Offset',b2,'Scale',w2,'TrainedMean',m2,'TrainedVariance',v2,'NumChannels',4,'Epsilon',4);
layer3 = ReluLayer;
w4 = permute(Wb{5},[4 3 2 1]);
b4 = reshape(Wb{6},[1,1,4]);
layer4 = Conv2DLayer(w4,b4,[1,1,1,1],[2,2],[1,1]);
w5 = reshape(Wb{7},[1 1 4]);
b5 = reshape(Wb{8},[1 1 4]);
m5 = reshape(Wb{21},[1 1 4]);
v5 = reshape(Wb{22},[1 1 4]);
layer5 = BatchNormalizationLayer('Offset',b5,'Scale',w5,'TrainedMean',m5,'TrainedVariance',v5,'NumChannels',4,'Epsilon',4);
layer6 = ReluLayer;
w7 = permute(Wb{9},[4 3 2 1]);
b7 = reshape(Wb{10},[1,1,4]);
layer7 = Conv2DLayer(w7,b7,[1,1,1,1],[2,2],[1,1]);
w8 = reshape(Wb{11},[1 1 4]);
b8 = reshape(Wb{12},[1 1 4]);
m8 = reshape(Wb{23},[1 1 4]);
v8 = reshape(Wb{24},[1 1 4]);
layer8 = BatchNormalizationLayer('Offset',b8,'Scale',w8,'TrainedMean',m8,'TrainedVariance',v8,'NumChannels',4,'Epsilon',4);
layer9 = ReluLayer;
layer10 = FlattenLayer;
layer10.Type = 'nnet.cnn.layer.FlattenLayer';
layers = {layer1, layer2, layer3, layer4, layer5, layer6, layer7, layer8, layer9, layer10};
net1 = CNN('cnn',layers,1,1); % neural network controller
% ODEBlock only linear layers
% Convert in form of a linear ODE model
states = 196;
outputs = 196;
w1 = Wb{13};
b1 = Wb{14}';
w2 = Wb{15};
b2 = Wb{16}';
Aout = w2*w1;
Bout = w2*b1+b2;
Cout = eye(states);
D = zeros(outputs,1);
tfinal = 1;
numSteps = 20;
odeblock = LinearODE(Aout,Bout,Cout,D,tfinal,numSteps);
reachStep = tfinal/numSteps;
% Output layers 
layerout = LayerS(Wb{17},Wb{18}','purelin');
layer_out = FFNNS(layerout);

odelayer = ODEblockLayer(odeblock,1);
neuralLayers = {layer1, layer2, layer3, layer4, layer5, layer6, layer7, layer8, layer9, layer10, odelayer, layerout};
neuralode = NeuralODE(neuralLayers);

%% Part 2. Load data and prepare experiments

noise = noise*255; % noise 1/10 of max pixel value
pixels_attack = randi([32 32],1,pix);
pred = zeros(numT,1);
time = zeros(numT,1);
pred_ode = zeros(numT,1);
time_ode = zeros(numT,1);
% InpSS = []; % Array of input sets
rob_ode = zeros(numT,1);
for i=1:numT
    img_flat = double(XTest(:,:,:,i));
    img_flat = extractdata(img_flat)';
%     img_flat = reshape(img_flat', [1 784])';
    lb = img_flat;
    ub = img_flat;
    for j=pixels_attack
        ub(j) = min(255, ub(j)+rand*noise);
        lb(j) = max(0, lb(j)-rand*noise);
    end
    % Normalize input (input already normalized)
    lb = lb./255;
    ub = ub./255;
    inpS = ImageStar(lb,ub);
    img_inp = img_flat./255;
    %% Part 3. Reachability and Simulation
    % Divide reachability into steps
%     U = [];
%     t = tic;
%     R1 = net1.reach(inpS,'approx-star');
%     R1 = R1.toStar;
%     R2all = odeblock.simReach('direct',R1,U,reachStep,numSteps); % LinearODE
%     R2 = R2all(end);
%     R3 = layer_out.reach(R2,'approx-star');
%     time(i) = toc(t);
%     [lb_out,ub_out] = R3.getRanges;
%     [maxO,max_idx] = max(ub_out);
%     pred(i) = max_idx;
    t = tic;
    Rode = neuralode.reach(inpS);
    time_ode(i) = toc(t);
    [rv,~] = neuralode.checkRobust(Rode,YTest(i));
%     [lb_out,ub_out] = Rode.getRanges;
%     [maxO,max_idx] = max(ub_out);
%     pred_ode(i) = max_idx;
    rob_ode(i) = rv;
%     InpSS = [InpSS inpS];
end

rob = sum(rob_ode == 1);
unk = sum(rob_ode == 0);
notr = sum(rob_ode == 2);
disp(' ');
disp('Robust images: '+string(rob));
disp('Unknown images: '+string(unk));
disp('Not robust images: '+string(notr));

% Notify finish
sound(tan(1:3000));
% 
% %% Part 3. Robustness results
% pred_acc = pred == YTest(1:numT);
% sum_acc = sum(pred_acc);
% acc = sum_acc/numT;
% disp(' ');
% disp(' ');
% disp(' ');
% disp('========== Robustness results (NNV) ===========')
% disp(' ');
% disp('Total images evaluated: '+string(numT));
% disp('ATTACK: Random noise, max value = '+string(noise));
% disp('Network robust to '+string(sum_acc)+' images.');
% disp('Total time to evaluate ' + string(numT) + ' images: ' + string(sum(time)) + ' seconds');
% disp('Average time per image: ' + string(sum(time)/numT));
% 
% %%%%% Neural ODE results %%%%%%%
% pred_acc = pred_ode == YTest(1:numT);
% sum_acc = sum(pred_acc);
% acc = sum_acc/numT;
% disp(' ');
% disp(' ');
% disp(' ');
% disp('========== Robustness results (NNV) ===========')
% disp(' ');
% disp('Total images evaluated: '+string(numT));
% disp('ATTACK: Random noise, max value = '+string(noise));
% disp('Network robust to '+string(sum_acc)+' images.');
% disp('Total time to evaluate ' + string(numT) + ' images: ' + string(sum(time_ode)) + ' seconds');
% disp('Average time per image: ' + string(sum(time_ode)/numT));


%% Section 2. ODEblock with CORA reachability
if cora
    %% Part 1. Loading and constructing the NeuralODE

    % Convert in form of a linear ODE model
    % C = eye(states); % Want to get both of the outputs from NeuralODE
    odeblockC = LinearODE_cora(Aout,Bout,Cout,D,reachStep,tfinal); % (Non)linear ODE plant 

    %% Part 2. Load data and prepare experiments

    pred = zeros(numT,1);
    timeC = zeros(numT,1);
    for i=1:numT
        img_flat = double(XTest(:,:,:,i));
        img_flat = extractdata(img_flat)';
    %     img_flat = reshape(img_flat', [1 784])';
        lb = img_flat;
        ub = img_flat;
        for j=pixels_attack
            ub(j) = min(255, ub(j)+rand*noise);
            lb(j) = max(0, lb(j)-rand*noise);
        end
        % Normalize input (input already normalized)
        lb = lb./255;
        ub = ub./255;
        inpS = ImageStar(lb,ub);
        img_inp = img_flat./255;
        %% Part 3. Reachability and Simulation
        % Divide reachability into steps
        U = Star(0,0);
        t = tic;
        R1 = net1.reach(inpS,'approx-star');
        R1 = R1.toStar;
        R2 = odeblockC.stepReachStar(R1,U);
        R3 = layer_out.reach(R2,'approx-star');
        time(i) = toc(t);
        [lb_out,ub_out] = R3.getRanges;
        [maxO,max_idx] = max(ub_out);
        pred(i) = max_idx;
    end


    %% Robustness results

    pred_acc = pred == YTest(1:numT);
    sum_acc = sum(pred_acc);
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
end

% Notify finish
sound(tan(1:3000));
end