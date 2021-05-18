function dx = node3(x,u)
    load('/home/manzand/Documents/Python/sonode/experiments/damped_oscillators/anode(3)./5./model.mat');
    fc1 = tanh(double(w1)*x+double(b1)');
    fc2 = tanh(double(w2)*fc1+double(b2)');
    dx = double(w3)*fc2+double(b3)';
end
