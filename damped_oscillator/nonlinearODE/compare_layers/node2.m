function dx = node2(x,u)
    load('/home/manzand/Documents/Python/sonode/experiments/damped_oscillators/node./1_2_20./model.mat');
    fc1 = tanh(double(Wb{1})*x+double(Wb{2}'));
    fc2 = tanh(double(Wb{3})*fc1+double(Wb{4}'));
    fc3 = tanh(double(Wb{5})*fc2+double(Wb{6}'));
    dx = double(Wb{7})*fc3+double(Wb{8}');
end
