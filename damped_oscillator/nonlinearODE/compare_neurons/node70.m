function dx = node70(x,u)
    load('/home/manzand/Documents/Python/sonode/experiments/damped_oscillators/node./1_1_70./model.mat');
    fc1 = tanh(double(Wb{1})*x+double(Wb{2}'));
    fc2 = tanh(double(Wb{3})*fc1+double(Wb{4}'));
    dx = double(Wb{5})*fc2+double(Wb{6}');
end
