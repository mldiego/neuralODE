function dx = node_demoCORA(x,u)
% Neural ODE from example
% Parameters of neural ode
w1 = [0.37770063, -0.27597833;
       0.44799867,  0.12567079;
       0.0992068 ,  0.20535783;
       -0.4449692 , -0.2764816 ];
b1 = [0.00673377,  0.0004014 ,  0.01828578, -0.01719386]';
% Layer 2
w2 = [0.28885743, -0.20345624, -0.24574696,  0.30131853;
      0.5042236 ,  0.3248701 ,  0.07584415, -0.2828761];
b2 = [-1.1456777e-02,  5.8001031e-05]';

% Function
u = x.^3;
% dx = tanh(w1*u+b1); %layer 1
dx = w2*tanh(w1*u+b1)+b2; % Full dynamics in one line

end

