function label = classlabel(class)
%CLASSLABEL Summary of this function goes here
%   Detailed explanation goes here
class = string(class);
if class == 'airplane'
    label = 1;
elseif class == 'automobile'
    label = 2;
elseif class == 'bird'
    label = 3;
elseif class == 'cat'
    label = 4;
elseif class == 'deer'
    label = 5;
elseif class == 'dog'
    label = 6;
elseif class == 'frog'
    label = 7;
elseif class == 'horse'
    label = 8;
elseif class == 'ship'
    label = 9;
elseif class == 'truck'
    label = 10;
else
    error('Incorrect class');
end
end

