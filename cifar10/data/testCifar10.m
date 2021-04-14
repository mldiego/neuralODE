function [acc_tot] =  testCifar10(net)
%TESTCIFAR10 Summary of this function goes here
%   Detailed explanation goes here
try 
    load(net);
catch
    try
        net;
    catch
        disp('Not a valid path to the network. Must be input as a network object.')
    end
end
category = ["airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck"];
result = zeros(1000,10);
acc = zeros(1,10);
tic;
for k=1:length(category)
    categ =char(category(k));
    t = classlabel(categ); %target
    pth = ['/home/manzand/Documents/MATLAB/NeuralODEs/cifar10/data/cifar10Test/' categ '/*.png'];
    images = dir(pth);
    m = length(images);
    for i=1:m
        f = readCifarImage(['/home/manzand/Documents/MATLAB/NeuralODEs/cifar10/data/cifar10Test/' categ '/' images(i).name]);
        result(i,k) = classify(net,f);
    end
    a = result(:,k) == t;
    acc(k) = sum(a)/m; % Accuracy
end
acc_tot = sum(acc)/10; % Accuracy
toc;
end
