function dx = vanderpol(x,u)
% # 2-dimensional van der pol
% class VanDerPol:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         self.cx = (-1, -1)
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 0.5
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
%         fx = y
%         fy = (x * x - 1) * y - x
% 
%         system_dynamics = [fx, fy]  # has to be in the same order as the input variables
%         # ===================================================
% 
%         return np.array(system_dynamics)  # return as numpy array


dx(1,1) = x(2);
dx(2,1) = (x(1)*x(1)-1)*x(2)-x(1);

end

