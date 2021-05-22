function dx = spiral_non_time(x,u)
% Neural ODE from example
% Parameters of neural ode (10 neurons)
load('odeffnn_spiral_non.mat');
w1 = double(Wb{3});
w1 = [w1 zeros(10,1)];
b1 = double(Wb{4}');
w2 = [double(Wb{5});zeros(1,10)];
b2 = [double(Wb{6}');1];

% Function
% u = x.^3;
u = x;
% dx = tanh(w1*u+b1); %layer 1
dx = w2*tanh(w1*u+b1)+b2; % Full dynamics in one line (Add time for plotting)

end

