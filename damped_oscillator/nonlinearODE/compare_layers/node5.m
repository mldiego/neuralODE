function dx = node5(x,u)
    load('/home/manzand/Documents/Python/sonode/experiments/damped_oscillators/node./1_5_20./model.mat');
    fc1 = tanh(double(Wb{1})*x+double(Wb{2}'));
    fc2 = tanh(double(Wb{3})*fc1+double(Wb{4}'));
    fc3 = tanh(double(Wb{5})*fc2+double(Wb{6}'));
    fc4 = tanh(double(Wb{7})*fc3+double(Wb{8}'));
    fc5 = tanh(double(Wb{9})*fc4+double(Wb{10}'));
    fc6 = tanh(double(Wb{11})*fc5+double(Wb{12}'));
    dx = double(Wb{13})*fc6+double(Wb{14}');
end
