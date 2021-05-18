function dx = node0(x,u)
    load('/home/manzand/Documents/Python/sonode/experiments/damped_oscillators/node./1_0_20./model.mat');
    fc1 = tanh(double(Wb{1})*x+double(Wb{2}'));
    dx = double(Wb{3})*fc1+double(Wb{4}');
end
