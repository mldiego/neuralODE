function dx = CartPoleLTC(x,u)
% # 12-dimensional cartpole with LTC neural network controller
% class CartpoleLTC:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         self.cx = (0, 0, 0.001, 0, 0, 0, 0, 0, 0, 0, 0, 0)
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 1e-4
%         # ===================================================
%         self.cx = np.array(self.cx, dtype=float)
%         self.dim = self.cx.size  # dimension of the system
% 
    function yt = true_sigmoid( x)
        yt = 0.5 * (tanh(x * 0.5) + 1);
    end
% 
    function ys = sigmoid(v_pre, mu, sigma)
        mues = v_pre - mu;
        yy = sigma * mues;
        ys = true_sigmoid(yy);
    end 

%     def fdyn(self, t=0, x=None):
%         if x is None:
%             x = np.zeros(self.dim, dtype=object)
% 
%         # ============ adapt input and system dynamics ===========
%         x_00, x_01, x_02, x_03, h_00, h_01, h_02, h_03, h_04, h_05, h_06, h_07 = x

x_00 = x(1); x_01 = x(2); x_02 = x(3); x_03 = x(4); h_00 = x(5); h_01 = x(6);
h_02 = x(7); h_03 = x(8); h_04 = x(9); h_05 = x(10); h_06 = x(11); h_07 = x(12);
    
% 
        u_00 = x_00 / 0.1;
        u_01 = x_01 / 0.2;
        u_02 = x_02 / 0.1;
        u_03 = x_03 / 0.1;
% 
        swa_00 = (...
            (-3.337809 - h_00) * 0.000100 * sigmoid(u_00, -1.822089, 4.920430)...
            + (-3.793303 - h_00) * 0.217915 * sigmoid(u_01, 0.589409, 4.212314)...
            + (1.074355 - h_00) * 0.000100 * sigmoid(u_02, -1.301882, 1.045275)...
            + (-1.837527 - h_00) * 0.784721 * sigmoid(u_03, 0.061974, 9.342714)...
        );
        swa_01 = (...
            (1.922444 - h_01) * 0.048898 * sigmoid(u_00, 0.069332, 4.315088)...
            + (-2.419416 - h_01) * 0.627589 * sigmoid(u_01, 2.746536, 3.680750)...
            + (3.581162 - h_01) * 0.165919 * sigmoid(u_02, -1.045852, 3.066419)...
            + (1.778340 - h_01) * 0.120764 * sigmoid(u_03, 1.837324, 3.448219)...
        );
        swa_02 = (...
            (2.205145 - h_02) * 0.304337 * sigmoid(u_00, 0.031854, 4.853640)...
            + (-3.098629 - h_02) * 0.084116 * sigmoid(u_01, 0.441696, 3.296364)...
            + (-1.226080 - h_02) * 0.177806 * sigmoid(u_02, 2.182991, 1.098078)...
            + (-2.913366 - h_02) * 0.491636 * sigmoid(u_03, 2.224604, 1.728117)...
        );
        swa_03 = (...
            (0.960911 - h_03) * 0.364263 * sigmoid(u_00, -1.053052, 1.971431)...
            + (-1.638120 - h_03) * 0.162840 * sigmoid(u_01, 7.642996, 2.541498)...
            + (-1.138980 - h_03) * 0.746401 * sigmoid(u_02, 1.725237, 0.663583)...
            + (1.642858 - h_03) * 0.299424 * sigmoid(u_03, 0.687038, -0.347229)...
        );
        swa_04 = (...
            (-0.752243 - h_04) * 0.649805 * sigmoid(u_00, 5.850876, 4.392767)...
            + (0.135855 - h_04) * 0.018294 * sigmoid(u_01, 3.993045, 2.950581)...
            + (-0.291421 - h_04) * 0.404132 * sigmoid(u_02, -0.929036, 3.571369)...
            + (-3.123502 - h_04) * 0.521996 * sigmoid(u_03, -0.641402, 7.249665)...
        );
        swa_05 = (...
            (-0.472946 - h_05) * 0.359657 * sigmoid(u_00, 1.851295, 6.572009)...
            + (-0.733541 - h_05) * 0.382768 * sigmoid(u_01, 2.120606, 3.201269)...
            + (1.819771 - h_05) * 0.223484 * sigmoid(u_02, 2.934255, 4.131283)...
            + (0.080200 - h_05) * 0.108734 * sigmoid(u_03, -2.828882, 1.771147)...
        );
        swa_06 = (...
            (2.596139 - h_06) * 0.233149 * sigmoid(u_00, 1.404586, 5.493755)...
            + (-0.948662 - h_06) * 0.297568 * sigmoid(u_01, -5.682380, 3.978102)...
            + (4.558042 - h_06) * 0.736431 * sigmoid(u_02, -0.067011, 3.915714)...
            + (1.514289 - h_06) * 0.226179 * sigmoid(u_03, -1.101492, 5.705000)...
        );
        swa_07 = (...
            (0.907580 - h_07) * 0.077591 * sigmoid(u_00, 0.822831, 2.474382)...
            + (-2.282039 - h_07) * 0.161999 * sigmoid(u_01, -0.241190, 6.074738)...
            + (0.294892 - h_07) * 0.202664 * sigmoid(u_02, -0.289602, 8.727577)...
            + (-2.329513 - h_07) * 0.242021 * sigmoid(u_03, -0.960229, 4.780694)...
        );
        wa_00 = (...
            (0.425183 - h_00) * 0.580120 * sigmoid(h_00, 1.888106, 5.698736)...
            + (-0.026397 - h_00) * 0.422325 * sigmoid(h_01, 0.322996, 3.287380)...
            + (0.232258 - h_00) * 0.234096 * sigmoid(h_02, 1.988594, 5.637971)...
            + (0.325219 - h_00) * 0.822936 * sigmoid(h_03, 1.430856, 1.847167)...
            + (-3.234136 - h_00) * 0.143390 * sigmoid(h_04, 1.693733, 1.529007)...
            + (-0.446780 - h_00) * 0.000010 * sigmoid(h_05, 4.226530, 1.182250)...
            + (-1.355023 - h_00) * 0.605004 * sigmoid(h_06, 1.083694, 2.011393)...
            + (-3.184705 - h_00) * 0.338830 * sigmoid(h_07, 5.826199, 2.559444)...
        );
        wa_01 = (...
            (-1.902008 - h_01) * 0.151651 * sigmoid(h_00, 1.296603, 3.500569)...
            + (-0.865412 - h_01) * 0.042350 * sigmoid(h_01, 1.769154, 10.179186)...
            + (-3.485676 - h_01) * 0.259284 * sigmoid(h_02, 1.534717, 3.293725)...
            + (-1.715340 - h_01) * 0.197946 * sigmoid(h_03, 0.264122, 5.787919)...
            + (-3.960100 - h_01) * 0.346343 * sigmoid(h_04, 4.226974, 5.074825)...
            + (-1.888838 - h_01) * 0.167991 * sigmoid(h_05, -0.192584, 4.463276)...
            + (3.343740 - h_01) * 0.407932 * sigmoid(h_06, -2.019538, 2.096939)...
            + (-3.828055 - h_01) * 0.392470 * sigmoid(h_07, -1.217940, 3.255837)...
        );
        wa_02 = (...
            (-0.149339 - h_02) * 0.274537 * sigmoid(h_00, -0.229752, 0.488301)...
            + (0.411455 - h_02) * 0.026122 * sigmoid(h_01, 4.011376, 4.030908)...
            + (3.896320 - h_02) * 0.157079 * sigmoid(h_02, 2.459823, 3.892246)...
            + (0.530434 - h_02) * 0.059498 * sigmoid(h_03, 1.132183, 1.906741)...
            + (-0.194996 - h_02) * 0.087192 * sigmoid(h_04, 0.000571, 0.949683)...
            + (-0.407292 - h_02) * 0.194082 * sigmoid(h_05, -0.997799, 1.219973)...
            + (-6.620962 - h_02) * 0.398726 * sigmoid(h_06, 0.469706, 5.065333)...
            + (1.787329 - h_02) * 1.050713 * sigmoid(h_07, 4.342476, -0.298296)...
        );
        wa_03 = (...
            (-5.372879 - h_03) * 0.027963 * sigmoid(h_00, 2.814907, 7.856180)...
            + (-0.646331 - h_03) * 0.149699 * sigmoid(h_01, 0.987782, 2.744861)...
            + (0.116237 - h_03) * 0.135569 * sigmoid(h_02, 4.085198, 3.937947)...
            + (-2.523393 - h_03) * 0.165372 * sigmoid(h_03, 0.703319, 5.054082)...
            + (0.815988 - h_03) * 0.189418 * sigmoid(h_04, 3.352685, 7.961621)...
            + (-1.706797 - h_03) * 0.502507 * sigmoid(h_05, -0.760482, 5.458648)...
            + (-2.023418 - h_03) * 0.026645 * sigmoid(h_06, 4.557816, 2.245746)...
            + (-0.889180 - h_03) * 0.468236 * sigmoid(h_07, -2.680705, 7.208436)...
        );
        wa_04 = (...
            (1.343493 - h_04) * 0.603259 * sigmoid(h_00, -0.901840, 3.872216)...
            + (0.831619 - h_04) * 0.426593 * sigmoid(h_01, -3.089995, 5.196197)...
            + (0.421409 - h_04) * 0.068839 * sigmoid(h_02, 3.991761, 0.784316)...
            + (2.355011 - h_04) * 0.018658 * sigmoid(h_03, -0.024262, 7.865137)...
            + (0.593414 - h_04) * 0.252146 * sigmoid(h_04, -1.463303, 3.132787)...
            + (-0.637192 - h_04) * 0.118786 * sigmoid(h_05, -1.024096, 4.974855)...
            + (-0.732044 - h_04) * 0.588030 * sigmoid(h_06, 1.033544, 6.298468)...
            + (-0.194411 - h_04) * 0.679828 * sigmoid(h_07, 0.410277, 8.185476)...
        );
        wa_05 = (...
            (0.495678 - h_05) * 0.338934 * sigmoid(h_00, 1.896829, 3.323362)...
            + (0.680690 - h_05) * 0.558593 * sigmoid(h_01, -0.032828, 3.472205)...
            + (1.564447 - h_05) * 0.416106 * sigmoid(h_02, -0.448733, 4.371096)...
            + (0.896225 - h_05) * 0.102958 * sigmoid(h_03, -1.402512, 7.281286)...
            + (3.866403 - h_05) * 0.388992 * sigmoid(h_04, -1.392615, 1.017738)...
            + (-1.880220 - h_05) * 0.075561 * sigmoid(h_05, 0.562915, 6.004653)...
            + (-5.541122 - h_05) * 0.279411 * sigmoid(h_06, -0.679593, 2.001722)...
            + (-0.065618 - h_05) * 0.475569 * sigmoid(h_07, -1.229657, 3.177203)...
        );
        wa_06 = (...
            (-1.465561 - h_06) * 0.122170 * sigmoid(h_00, 0.706757, 2.401071)...
            + (-2.485563 - h_06) * 0.091596 * sigmoid(h_01, 0.335557, 3.252133)...
            + (1.158366 - h_06) * 0.519633 * sigmoid(h_02, -1.169937, 3.588379)...
            + (1.955986 - h_06) * 0.252199 * sigmoid(h_03, -1.974608, 2.870511)...
            + (0.743124 - h_06) * 0.651011 * sigmoid(h_04, -0.210935, 7.228260)...
            + (3.452268 - h_06) * 0.019733 * sigmoid(h_05, 3.515318, 3.879946)...
            + (0.604325 - h_06) * 0.191627 * sigmoid(h_06, -3.070420, 4.221974)...
            + (2.465013 - h_06) * 0.143574 * sigmoid(h_07, -0.961958, 3.002333)...
        );
        wa_07 = (...
            (-2.135510 - h_07) * 0.082957 * sigmoid(h_00, 0.857560, 4.560907)...
            + (-0.719410 - h_07) * 0.121560 * sigmoid(h_01, 2.004791, 7.674825)...
            + (-0.095160 - h_07) * 0.085265 * sigmoid(h_02, 0.915076, 3.384454)...
            + (-6.402920 - h_07) * 0.017902 * sigmoid(h_03, 1.900790, 3.606339)...
            + (0.911732 - h_07) * 0.018167 * sigmoid(h_04, 0.001252, 7.378105)...
            + (-0.876065 - h_07) * 0.119567 * sigmoid(h_05, 2.130298, 7.560087)...
            + (-1.520981 - h_07) * 0.012488 * sigmoid(h_06, -0.275924, 2.646271)...
            + (0.734387 - h_07) * 0.088953 * sigmoid(h_07, -1.333799, 3.340692)...
        );
        h_00_prime = 10000000.000000 * (0.663909 * (4.880308 - h_00) + swa_00 + wa_00);
        h_01_prime = 0.897653 * (2.666445 * (-0.506661 - h_01) + swa_01 + wa_01);
        h_02_prime = 0.513291 * (4.721010 * (-1.314806 - h_02) + swa_02 + wa_02);
        h_03_prime = 0.301197 * (0.073180 * (0.044130 - h_03) + swa_03 + wa_03);
        h_04_prime = 0.404649 * (1.368898 * (-1.209986 - h_04) + swa_04 + wa_04);
        h_05_prime = 1.131324 * (0.000010 * (-2.630356 - h_05) + swa_05 + wa_05);
        h_06_prime = 10000000.000000 * (0.539536 * (-0.529881 - h_06) + swa_06 + wa_06);
        h_07_prime = 0.525138 * (0.507019 * (0.567584 - h_07) + swa_07 + wa_07);
% 
        action_00 = tanh(...
            h_00 * -0.895448...
            + h_01 * -0.795233...
            + h_02 * 0.209421...
            + h_03 * 0.143533...
            + h_04 * -0.084270...
            + h_05 * -0.342232...
            + h_06 * 0.333434...
            + h_07 * -0.032306...
            + 0.757913...
        );
% 
        gravity = 9.8;
        masscart = 1;
        masspole = 0.1;
        total_mass = masscart + masspole;
        length = 0.5;
        polemass_length = masspole * length;
        force_mag = 10;

        force = force_mag * action_00;
        costheta = cos(x_02);
        sintheta = sin(x_02);
        x_dot = x_01;
        theta_dot = x_03;
% 
        temp = (force + polemass_length * theta_dot * theta_dot * sintheta) / total_mass;
        thetaacc = (gravity * sintheta - costheta * temp) / (...
            length * (4.0 / 3.0 - masspole * costheta * costheta / total_mass)...
        );
        xacc = temp - polemass_length * thetaacc * costheta / total_mass;
% 
        x_00_prime = x_dot;
        x_01_prime = xacc;
        x_02_prime = theta_dot;
        x_03_prime = thetaacc;
% 
       dx = [
            x_00_prime;
            x_01_prime;
            x_02_prime;
            x_03_prime;
            h_00_prime;
            h_01_prime;
            h_02_prime;
            h_03_prime;
            h_04_prime;
            h_05_prime;
            h_06_prime;
            h_07_prime;
        ];  % has to be in the same order as the input variables
%         # ===================================================
% 
%         return np.array(system_dynamics)  # return as numpy array
end

