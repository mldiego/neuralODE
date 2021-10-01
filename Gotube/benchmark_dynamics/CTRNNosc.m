function dx = CTRNNosc(x,u)
% class CTRNNosc:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 0.1
%         # ===================================================
%         self.cx = np.zeros(16)
%         self.dim = self.cx.size  # dimension of the system
%         arr = np.load("rl/ctrnn_osc.npz")
%         self.params = {k: arr[k] for k in arr.files}
% 
%     def fdyn(self, t=0, x=None):
%         if x is None:
%             x = np.zeros(self.dim, dtype=object)
% 
%         hidden = np.tanh(np.dot(x, self.params["w1"]) + self.params["b1"])
%         dhdt = np.dot(hidden, self.params["w2"]) + self.params["b2"]
%         return dhdt
end

