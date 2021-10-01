classdef neuralOdeLayer < nnet.layer.Layer & nnet.layer.Formattable
% neuralOdeLayer Custom Neural ODE layer
    % 
    % This custom layer learns the trainable parameters of an internal
    % dlnetwork object by backpropagating through the operations of an
    % explicit 4th-order Runge-Kutta numerical solver.
    
    %   Copyright 2021 The MathWorks, Inc.

    properties
        % Computational grid for RK-4 method
        Timesteps
    end
    
    properties (Learnable)
        % Learnable property
        InternalDlnet
    end
    
    methods
        % Constructor
        function this = neuralOdeLayer(dlnet,Nt,h,name)
            % Declare layer timesteps
            this.Timesteps = (1:Nt)*h;
            
            this.Name = name;
            this.InternalDlnet= dlnet;
        end

        function dlnetModelFcn = getInternalDlnetAsFcn(this)
            % Create a function dlnetModelFcn which can be given to an ODE
            % solver of the form x' = fcn( t, x ).
            dlnetModelFcn = @(t,x)this.InternalDlnet.forward(x);
        end

        function x = evaluateODE(this,x)
            x = dlarray(x,'CB');
            x = this.InternalDlnet.predict(x);
            x = extractdata(x);
            x = cast(x,'double');
        end

        function h = predict(this, X)
            dlnetModelFcn = this.getInternalDlnetAsFcn();
            h = iRungeKutta4Batch(dlnetModelFcn, this.Timesteps, X);
            h = dlarray(h, 'CBT');
        end
    end
end

function x = iRungeKutta4Batch(fcn, t, x0)
% 4th order Runge-Kutta ODE solver for batched inputs
%
%   x' =  fcn( t, x )
%
% Inputs:
%   fcn     = function handle in (t, x)
%   t       = vector of timesteps   (1 x T)
%   x0      = initial condition     (C x B)
%
% Outputs:
%   x       = solution              (C x B x T)

% Find the step sizes
h = t(2:end) - t(1:end-1);

% Initialize x
[C, N] = size(x0);
T = numel(t);
x = cat(3, x0, zeros(C, N, T - 1));

% Time stepping
for ii = 1:(T - 1)
    % Update coefficients
    k1 = fcn( t(ii), x(:, :, ii) );
    k2 = fcn( t(ii) + 0.5*h(ii), x(:, :, ii) + 0.5*h(ii)*k1 );
    k3 = fcn( t(ii) + 0.5*h(ii), x(:, :, ii) + 0.5*h(ii)*k2 );
    k4 = fcn( t(ii) + h(ii), x(:, :, ii) + k3*h(ii) );
    
    % Update x
    x(:, :, ii + 1) = x(:, :, ii) + (1/6)*(k1 + 2*k2 + 2*k3 + k4)*h(ii);
end
end