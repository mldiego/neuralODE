function dx = DubinsCar(x,u)
% # 3-dimensional dubins car
% class DubinsCar:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         self.cx = (0, 0, 0.7854, 0)
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
%         x, y, th, tt = x
% 
%         v = 1
% 
%         fx = v * cos(th)
%         fy = v * sin(th)
%         fth = x * sin(tt)
%         ftt = np.array(1)  # this is needed for lax_numpy to see this as an array
% 
%         system_dynamics = [
%             fx,
%             fy,
%             fth,
%             ftt,
%         ]  # has to be in the same order as the input variables
%         # ===================================================
% 
%         return np.array(system_dynamics)  # return as numpy array

v = 1;

dx(1,1) = v * cos(x(3));
dx(2,1) = v * sin(x(3));
dx(3,1) = x(1) * sin(x(4));
dx(4,1) = 1;

end

