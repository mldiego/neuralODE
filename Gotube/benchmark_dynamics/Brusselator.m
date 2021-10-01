function dx = Brusselator(x,u)
%2-dimensional brusselator
%
% class Brusselator:
%     def __init__(self, radius=None):
%         # ============ adapt initial values ===========
%         self.cx = (1, 1)
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 0.01
%         # ===================================================
%         self.cx = np.array(self.cx, dtype=float)
%         self.dim = self.cx.size  # dimension of the system
% 
%     def fdyn(self, t=0, x=None):
%         if x is None:
%             x = np.zeros(self.dim, dtype=object)
% 
%         # ============ adapt input and system dynamics ===========
%         x, y = x
% 
%         a = 1
%         b = 1.5
% 
%         fx = a + x ** 2 * y - (b + 1) * x
%         fy = b * x - x ** 2 * y
% 
%         system_dynamics = [fx, fy]  # has to be in the same order as the input variables
%         # ===================================================
% 
%         return np.array(system_dynamics)  # return as numpy array

a = 1;
b = 1.5;

dx(1,1) = a + x(1)^2 * x(2) - (b + 1) * x(1);
dx(2,1) = b * x(1) - x(1)^2 * x(2);

end

