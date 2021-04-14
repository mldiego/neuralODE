function I = readCifarImage(filename)
% Resize the images to the size required by the network.
I = imread(filename);
I = double(I);
% I = imresize(I, [32 32]);
mean = [0.4914, 0.4822, 0.4465];
std = [0.2023, 0.1994, 0.2010];
for i=1:3
    I(:,:,i) = ((I(:,:,i)./255) - mean(i))./std(i);
end

end

