function dx = robotarm(x,u)
% # 4-dimensional Robotarm
% class Robotarm:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         self.cx = (1.505, 1.505, 0.005, 0.005)
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 0.05
%         # ===================================================
%         self.cx = np.array(self.cx, dtype=float)
%         self.dim = self.cx.size  # dimension of the system
% 
%     def fdyn(self, t=0, x=None):
%         if x is None:
%             x = np.zeros(self.dim, dtype=object)
% 
%         # ============ adapt input and system dynamics ===========
%         x1, x2, x3, x4 = x
% 
%         m = 1
%         l = 3
%         kp1 = 2
%         kp2 = 1
%         kd1 = 2
%         kd2 = 1
% 
%         fx1 = x3
%         fx2 = x4
%         fx3 = (-2 * m * x2 * x3 * x4 - kp1 * x1 - kd1 * x3) / (m * x2 * x2 + l / 3) + (
%             kp1 * kp1
%         ) / (m * x2 * x2 + l / 3)
%         fx4 = x2 * x3 * x3 - kp2 * x2 / m - kd2 * x4 / m + kp2 * kp2 / m
% 
%         system_dynamics = [
%             fx1,
%             fx2,
%             fx3,
%             fx4,
%         ]  # has to be in the same order as the input variables
%         # ===================================================
% 
%         return np.array(system_dynamics)  # return as numpy array

m = 1;
l = 3;
kp1 = 2;
kp2 = 1;
kd1 = 2;
kd2 = 1;

dx(1,1) = x(3);
dx(2,1) = x(4);
dx(3,1) = (-2 * m * x(2) * x(3) * x(4) - kp1 * x(1) - kd1 * x(3)) / (m * x(2) * x(2) + l / 3) + (kp1 * kp1) / (m * x(2) * x(2) + l / 3);
dx(4,1) = x(2) * x(3) * x(3) - kp2 * x(2) / m - kd2 * x(4) / m + kp2 * kp2 / m;

end

