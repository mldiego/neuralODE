function dx = node19(x,u)
    load('/home/manzand/Documents/Python/sonode/experiments/damped_oscillators/anode(19)./5./model.mat');
    fc1 = tanh(double(Wb{1})*x+double(Wb{2}'));
    fc2 = tanh(double(Wb{3})*fc1+double(Wb{4}'));
    dx = double(Wb{5})*fc2+double(Wb{6})';
end
