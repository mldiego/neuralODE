function dx = TestNODE(x,u)
% class TestNODE:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         self.cx = (0, 0)
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 1e-4
%         # ===================================================
%         self.cx = np.array(self.cx, dtype=float)
%         self.dim = self.cx.size  # dimension of the system
% 
%     def fdyn(self, t=0, x=None):
%         if x is None:
%             x = np.zeros(self.dim, dtype=object)
% 
%         # ============ adapt input and system dynamics ===========
%         x0, x1 = x
%         x0 = 0.5889 * tanh(0.4256 * x0 + 0.5061 * x1 + 0.1773) - 0.1000 * x0
%         x1 = 0.3857 * tanh(-0.5563 * x0 + -0.1262 * x1 + -0.2136) - 0.1000 * x1
%         system_dynamics = [x0, x1]
%         # ===================================================
%         return np.array(system_dynamics)  # return as numpy array
end

