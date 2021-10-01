function dx = Quadcopter(x,u)
% # 17-dimensional Quadcopter
% class Quadcopter:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         self.cx = (
%             -0.995,
%             -0.995,
%             9.005,
%             -0.995,
%             -0.995,
%             -0.995,
%             -0.995,
%             -0.995,
%             -0.995,
%             0,
%             0,
%             0,
%             1,
%             0,
%             0,
%             0,
%             0,
%         )
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 0.005
%         # ===================================================
%         self.cx = np.array(self.cx, dtype=float)
%         self.dim = self.cx.size  # dimension of the system
% 
%     def fdyn(self, t=0, x=None):
%         if x is None:
%             x = np.zeros(self.dim, dtype=object)
% 
%         # ============ adapt input and system dynamics ===========
%         pn, pe, h, u, v, w, p, q, r, q0, q1, q2, q3, pI, qI, rI, hI = x
% 
%         pr = 0
%         qr = 0
%         rr = 0
%         hr = 0
% 
%         pn_ = (
%             2 * u * (q0 * q0 + q1 * q1 - 0.5)
%             - 2 * v * (q0 * q3 - q1 * q2)
%             + 2 * w * (q0 * q2 + q1 * q3)
%         )
%         pe_ = (
%             2 * v * (q0 * q0 + q2 * q2 - 0.5)
%             + 2 * u * (q0 * q3 + q1 * q2)
%             - 2 * w * (q0 * q1 - q2 * q3)
%         )
%         h_ = (
%             2 * w * (q0 * q0 + q3 * q3 - 0.5)
%             - 2 * u * (q0 * q2 - q1 * q3)
%             + 2 * v * (q0 * q1 + q2 * q3)
%         )
% 
%         u_ = r * v - q * w - 11.62 * (q0 * q2 - q1 * q3)
%         v_ = p * w - r * u + 11.62 * (q0 * q1 + q2 * q3)
%         w_ = q * u - p * v + 11.62 * (q0 * q0 + q3 * q3 - 0.5)
% 
%         q0_ = -0.5 * q1 * p - 0.5 * q2 * q - 0.5 * q3 * r
%         q1_ = 0.5 * q0 * p - 0.5 * q3 * q + 0.5 * q2 * r
%         q2_ = 0.5 * q3 * p + 0.5 * q0 * q - 0.5 * q1 * r
%         q3_ = 0.5 * q1 * q - 0.5 * q2 * p + 0.5 * q0 * r
% 
%         p_ = (
%             -40.00063258437631 * pI - 2.8283979829540325 * p
%         ) - 1.133407423682400 * q * r
%         q_ = (
%             -39.99980452524146 * qI - 2.8283752541008109 * q
%         ) + 1.132078179613602 * p * r
%         r_ = (
%             -39.99978909742505 * rI - 2.8284134223281210 * r
%         ) - 0.004695219977601 * p * q
% 
%         pI_ = p - pr
%         qI_ = q - qr
%         rI_ = r - rr
%         hI_ = h - hr
% 
%         system_dynamics = [
%             pn_,
%             pe_,
%             h_,
%             u_,
%             v_,
%             w_,
%             p_,
%             q_,
%             r_,
%             q0_,
%             q1_,
%             q2_,
%             q3_,
%             pI_,
%             qI_,
%             rI_,
%             hI_,
%         ]  # has to be in the same order as the input variables
%         # ===================================================
% 
%         return np.array(system_dynamics)  # return as numpy array

%         pn, pe, h, u, v, w, p, q, r, q0, q1, q2, q3, pI, qI, rI, hI = x

pn = x(1); pe = x(2); h = x(3); u = x(4); v = x(5); w = x(6); 
p = x(7); q = x(8);r = x(9); q0 = x(10); q1 = x(11); q2 = x(12); 
q3 = x(13); pI = x(14); qI = x(15); rI = x(16); hI = x(17);

pr = 0;
qr = 0;
rr = 0;
hr = 0;

dx(1,1) = (2 * u * (q0 * q0 + q1 * q1 - 0.5) - 2 * v * (q0 * q3 - q1 * q2) + 2 * w * (q0 * q2 + q1 * q3));
dx(2,1) = (2 * v * (q0 * q0 + q2 * q2 - 0.5) + 2 * u * (q0 * q3 + q1 * q2) - 2 * w * (q0 * q1 - q2 * q3));
dx(3,1) = (2 * w * (q0 * q0 + q3 * q3 - 0.5)- 2 * u * (q0 * q2 - q1 * q3)+ 2 * v * (q0 * q1 + q2 * q3));

dx(4,1) = r * v - q * w - 11.62 * (q0 * q2 - q1 * q3);
dx(5,1) = p * w - r * u + 11.62 * (q0 * q1 + q2 * q3);
dx(6,1) = q * u - p * v + 11.62 * (q0 * q0 + q3 * q3 - 0.5);

dx(7,1) = (-40.00063258437631 * pI - 2.8283979829540325 * p) - 1.133407423682400 * q * r;
dx(8,1) = (-39.99980452524146 * qI - 2.8283752541008109 * q) + 1.132078179613602 * p * r;
dx(9,1) = (-39.99978909742505 * rI - 2.8284134223281210 * r) - 0.004695219977601 * p * q;

dx(10,1) = -0.5 * q1 * p - 0.5 * q2 * q - 0.5 * q3 * r;
dx(11,1) = 0.5 * q0 * p - 0.5 * q3 * q + 0.5 * q2 * r;
dx(12,1) = 0.5 * q3 * p + 0.5 * q0 * q - 0.5 * q1 * r;
dx(13,1) = 0.5 * q1 * q - 0.5 * q2 * p + 0.5 * q0 * r;

dx(14,1) = p - pr;
dx(15,1) = q - qr;
dx(16,1) = r - rr;
dx(17,1) = h - hr;

end

