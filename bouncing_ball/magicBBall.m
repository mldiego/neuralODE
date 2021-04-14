function dx = magicBBall(x,u)

% This neural ODE function is a piecewise linear function and can be
% understood as a neural ODE with 4 NNs
% Diagram will be attach to understand the dynamics of it. It is a
% simplification of the hybrid system of the bouncing ball. The neural ODEs
% were manually designed, never trained due to the lack of frameworks that
% could learn a function like this.

% Inputs: 2 (Same as outputs)
%    - Position
%    - Velocity
% States to consider are these 2, the position and velocity
% disp('x = '+string(x));
% NN1 learns the continuous dynamics (A = w1, c = b1)
w1 = [0 1; 0 0];
b1 = [0; -9.81];

% NN2 models the discrete dynamics, the "jump"/discontinuity in the
% velocity (This is partially accomplished with a satlin)

% w2 = -100000000000000000000000; % Only need x2 to be used
% b2 = 0; % No addition to the state variable. 

% NN3 should be the combination of models 1 and 2 
% This one has 3 inputs (x3 being the satlin output)
% w3 = [1 0 0;
%     0 1 1]; % This seems weird
% b3 = [0;0;0]; % No biased

% u = 0, no input :)
% Let's figure out later how to "construct" this neural network

dx = w1*x+b1; % Position and velocity
% disp('dx = '+string(dx));
% % xNN2 = max(min(1,w2*dx(1)),0); % 1 if jump (x < 0), 0 otherwise
% xNN2 = satlin(w2*dx(1));
% disp('xNN2 = '+string(xNN2));
% xNN3 = dx(2)*2*xNN2*0.9;
% disp('xNN3 = '+string(xNN3));
% dx(1,1) = dx(1,1);
% dx(2,1) = dx(2,1)-xNN3;
% disp('x(1) = ' + string(x(1)));
% disp('x(2) = '+ string(x(1)));
% pause;
% disp(' ' );
% disp('*************************************************');
end

