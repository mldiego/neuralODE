# ===================================
# Add description of benchmark
# Source
# ===================================

using ReachabilityAnalysis, Plots

@taylorize function spiralL!(dx, x, p, t)
        x1, x2 = x
        w11 = -0.50525320;   w12 = 0.34800902;   w13 = 0.34015974;   w14 = 0.40054744;   w15 = 0.39193857;
        w16 = 0.59363592;    w17 = 0.56743664;   w18 = 0.33811751;   w19 = 0.36945280;   w110 = 0.46805024;
        w21 = -0.41715327;   w22 = 0.56257814;   w23 = 0.56921810;   w24 = 0.60423535;   w25 = 0.53992182;
        w26 = 0.14412111;    w27 = 0.45906776;   w28 = 0.35295558;   w29 = 0.49238238;   w210 = 0.43526673;

        dx[1] = w11 * (-0.32294768 * x1 + 0.59955627 * x2 + 0.0038923009) + w12 * (0.47014388 * x1 - 0.39748120 * x2 + 0.0037905588) - w13 * (-0.56326932 * x1 + 0.33752987 * x2 + 0.0017197595) - w14 * (0.45147443 * x1 + 0.31528524 * x2 - 0.0033185149) + w15 * (0.41403031 * x1 - 0.47271276 * x2 + 0.0024190384) + w16 * (-0.12952870 * x1 - 0.62095606 * x2 - 0.0013056855) + w17 * (-0.41343114 * x1 - 0.45678866 * x2 + 0.0011365928) - w18 * (-0.33266136 * x1 + 0.29245856 * x2 - 0.00042518601) - w19* (0.50114638 * x1 + 0.39612201 * x2 - 0.0025141449) - w110 * (0.47665390 * x1 + 0.55137879 * x2 + 0.0010660964) - 0.0013696412

        dx[2] = w21*(-0.32294768*x1 + 0.59955627*x2 + 0.0038923009) + w22*(0.47014388*x1 - 0.39748120*x2 + 0.0037905588) -w23*(-0.56326932*x1 + 0.33752987*x2 + 0.0017197595) + w24*(0.45147443*x1 + 0.31528524*x2 - 0.0033185149) + w25*(0.41403031*x1 - 0.47271276*x2 + 0.0024190384) - w26*(-0.12952870*x1 - 0.62095606*x2 - 0.0013056855) - w27*(-0.41343114*x1 - 0.45678866*x2 + 0.0011365928) - w28*(-0.33266136*x1 + 0.29245856*x2 - 0.00042518601) + w29*(0.50114638*x1 + 0.39612201*x2 - 0.0025141449) + w210*(0.47665390*x1 + 0.55137879*x2 + 0.0010660964) + 0.00060380378

        return dx
end


function spiralL1()
	# initial state
	X0 = (1.99 .. 2.01) × (-0.01 .. 0.01)
	return @ivp(x' = spiralL!(x), dim:2, x(0) ∈ X0)
end

function spiralL2()
	# initial state
	X0 = (1.95 .. 2.05) × (-0.05 .. 0.05)
	return @ivp(x' = spiralL!(x), dim:2, x(0) ∈ X0)
end

function spiralL3()
	# initial state
	X0 = (1.9 .. 2.1) × (-0.1 .. 0.1)
	return @ivp(x' = spiralL!(x), dim:2, x(0) ∈ X0)
end

@taylorize function spiralNL!(dx, x, p, t)
        x1, x2 = x
	w1 = 0.2911133    ;  w2 = 0.12008807;
        w3 = -0.24582624  ;  w4 = 0.23181419;
        w5 = -0.25797904  ;  w6 = 0.21687193;
        w7 = -0.19282854  ;  w8 = -0.2602416;
        w9 = 0.26780415   ;  w10 = -0.20697702;
        w11 = 0.23462369  ;  w12 = 0.2294843;
        w13 = -0.2583547  ;  w14 = 0.21444395;
        w15 = -0.04514714 ;  w16 = 0.29514763;
        w17 = -0.15318371 ;  w18 = -0.275755;
        w19 = 0.24873598  ;  w20 = 0.21018365;
        b1 = 0.0038677    ;  b2 = -0.00026365  ; b3 = -0.007168970 ; b4 = 0.02469357 ;  b5 = 0.01338706 ; b6 = 0.00856025;  b7 = -0.00888401; b8 = 0.00516089; b9 = -0.00634514; b10 = -0.01914518;
        W11 = -0.58693904 ;  W12 = -0.814841   ; W13 = -0.8175157 ;  W14 = 0.97060364 ; W15 = 0.6908913;
        W16 = -0.92446184 ;  W17 = -0.79249185 ; W18 = -1.1507587 ;  W19 = 1.2072723 ;  W110 = -0.7983982;
        W21 = 1.1564877   ;  W22 = -0.8991244  ; W23 = -1.0774536;   W24 = -0.6731967 ; W25 = 1.0154784 ;
        W26 = 0.8984464   ;  W27 = -1.0766245   ;W28 = -0.238209 ;   W29 = -0.5233613 ; W210 = 0.8886671;
        b21 = -0.04129209 ;  b22 = -0.01508532;

        dx[1] = W11*tanh(w1*x1+w2*x2+b1) + W12*tanh(w3*x1+w4*x2+b2) + W13*tanh(w5*x1+w6*x2+b3) + W14*tanh(w7*x1+w8*x2+b4) + W15*tanh(w9*x1+w10*x2+b5) + W16*tanh(w11*x1+w12*x2+b6) + W17*tanh(w13*x1+w14*x2+b7) + W18*tanh(w15*x1+w16*x2+b8) + W19*tanh(w17*x1+w18*x2+b9) + W110*tanh(w19*x1+w20*x2+b10) + b21

        dx[2] = W21*tanh(w1*x1+w2*x2+b1) + W22*tanh(w3*x1+w4*x2+b2) + W23*tanh(w5*x1+w6*x2+b3) + W24*tanh(w7*x1+w8*x2+b4) + W25*tanh(w9*x1+w10*x2+b5) + W26*tanh(w11*x1+w12*x2+b6) + W27*tanh(w13*x1+w14*x2+b7) + W28*tanh(w15*x1+w16*x2+b8) + W29*tanh(w17*x1+w18*x2+b9) + W210*tanh(w19*x1+w20*x2+b10) + b22

        return dx 
end

function spiralNL1()
	# initial state
	X0 = (1.99 .. 2.01) × (-0.01 .. 0.01)
	return @ivp(x' = spiralNL!(x), dim:2, x(0) ∈ X0)
end

function spiralNL2()
	# initial state
	X0 = (1.95 .. 2.05) × (-0.05 .. 0.05)
	return @ivp(x' = spiralNL!(x), dim:2, x(0) ∈ X0)
end

function spiralNL3()
	# initial state
	X0 = (1.9 .. 2.1) × (-0.1 .. 0.1)
	return @ivp(x' = spiralNL!(x), dim:2, x(0) ∈ X0)
end

# ## Try other ways of running the linear models
# function spiralL_1()
#         # Calculated matrices first in matlab, equivalent system
#         A = [[-0.10743442, -1.9987571] [1.9962779, -0.099565357]]
#         B = [0.00011873094, -0.0015227959]
#         X0 = (1.99 .. 2.01) × (-0.01 .. 0.01)
#         probSPL1 = @ivp(x' = A*x+B, x(0) ∈ X0)
# end

# function spiralL_2()
#         # Calculated matrices first in matlab, equivalent system
#         A = [[-0.10743442, -1.9987571] [1.9962779, -0.099565357]]
#         B = [0.00011873094, -0.0015227959]
#         X0 = (1.95 .. 2.05) × (-0.05 .. 0.05)
#         probSPL2 = @ivp(x' = A*x+B, x(0) ∈ X0)
# end

# function spiralL_3()
#         # Calculated matrices first in matlab, equivalent system
#         A = [[-0.10743442, -1.9987571] [1.9962779, -0.099565357]]
#         B = [0.00011873094, -0.0015227959]
#         X0 = (1.9 .. 2.1) × (-0.1 .. 0.1)
#         probSPL3 = @ivp(x' = A*x+B, x(0) ∈ X0)
# end