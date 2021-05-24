% Run all 
pix = 100; % pixels per image to attack
numT = 200; % Number of images to evaluate
noise = [0.1,0.05]; % noise value (adversarial attack)
rng(2021); % Set random seed
% Load all test images
Xall = processMNISTimages('t10k-images.idx3-ubyte');
Yall = processMNISTlabels('t10k-labels.idx1-ubyte');
Xall = extractdata(Xall);
Yall = double(Yall);
% For a fair comparison, let's evaluate an equal number of image categories
cat_max = numT/10; % Max images per category
cnt_cat = zeros(10,1); % Keep track of images added
XTest = zeros(28,28,1,numT);
YTest = zeros(numT,1);
ck = 1; % Image check
adImg = 1; % Number of images added
while sum(cnt_cat) < numT
    idx = Yall(ck);
    if cnt_cat(idx) < cat_max
        YTest(adImg) = Yall(ck);
        XTest(:,:,:,adImg) = double(Xall(:,:,:,ck));
        cnt_cat(idx) = cnt_cat(idx)+1;
        adImg = adImg + 1;
    end
    ck = ck+1;
end
% Run smaller network
cora = false;
for noiseT = noise
    reach_small(pix,numT,noiseT,XTest,YTest,cora);
    % Run medium network
    reach_medium(pix,numT,noiseT,XTest,YTest,cora)
    % Run larger network
    reach_tiny(pix,numT,noiseT,XTest,YTest,cora);
end
