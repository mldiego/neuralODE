% Run all 
pix = 1; % pixels per image to attack
numT = 10; % Number of images to evaluate
noise = 0.0; % noise value (adversarial attack)
rng(20); % Set random seed
% Load all test images
[XTest,YTest] = load_cifarTest();
% YTest = processMNISTlabels('t10k-labels.idx1-ubyte');
% YTest = double(YTest);
% % Run smaller network
% cora = false;
% reach_small(pix,numT,noise,XTest,YTest,cora);
% % Run medium network
% reach_medium(pix,numT,noise,XTest,YTest,cora)
% % Run larger network
% reach_tiny(pix,numT,noise,XTest,YTest,cora);
