function dx = MitchellSchaeffer(x,u)
% # 2-dimensional Mitchell  Schaeffer  cardiac-cell
% class MitchellSchaeffer:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         self.cx = (0.8, 0.5)
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 0.1
%         # ===================================================
%         self.cx = np.array(self.cx, dtype=float)
%         self.dim = self.cx.size  # dimension of the system
% 
%     def fdyn(self, t=0, x=None):
%         if x is None:
%             x = np.zeros(self.dim, dtype=object)
% 
%         # ============ adapt input and system dynamics ===========
%         x1, x2 = x
% 
%         sig_x1 = 0.5 * (1 + tanh(50 * x1 - 5))
% 
%         fx1 = x2 * x1 ** 2 * (1 - x1) / 0.3 - x1 / 6
%         fx2 = sig_x1 * (-x2 / 150) + (1 - sig_x1) * (1 - x2) / 20
% 
%         system_dynamics = [
%             fx1,
%             fx2,
%         ]  # has to be in the same order as the input variables
%         # ===================================================
% 
%         return np.array(system_dynamics)  # return as numpy array

        sig_x1 = 0.5 * (1 + tanh(50 * x(1) - 5));

        dx(1,1) = x(2) * x(1)^2 * (1 - x(1)) / 0.3 - x(1) / 6;
        dx(2,1) = sig_x1 * (-x(2) / 150) + (1 - sig_x1) * (1 - x(2)) / 20;

end

