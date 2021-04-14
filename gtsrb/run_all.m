% Run all 
pix = 100; % pixels per image to attack
numT = 100; % Number of images to evaluate
noise = 0.05; % noise value (adversarial attack)
rng(2021); % Set random seed
% Load all test images
[XTest,YTest] = load_gtsrb();
% Run smaller network
cora = false;
reach_small(pix,numT,noise,XTest,YTest,cora);
% Run medium network
reach_medium(pix,numT,noise,XTest,YTest,cora)
% Run larger network
reach_tiny(pix,numT,noise,XTest,YTest,cora);
