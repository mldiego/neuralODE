function dx = LDSwithCTRNN(x,u)
% class LDSwithCTRNN:
%     def __init__(self, radius):
%         # ============ adapt initial values ===========
%         if radius is not None:
%             self.rad = radius
%         else:
%             self.rad = 0.5
%         # ===================================================
%         self.cx = np.zeros(10)
%         self.dim = self.cx.size  # dimension of the system
%         arr = np.load("rl/lds_ctrnn.npz")
%         self.params = {k: arr[k] for k in arr.files}
% 
%     def fdyn(self, t=0, x=None):
%         if x is None:
%             x = np.zeros(self.dim, dtype=object)
% 
%         hidden = np.tanh(np.dot(x, self.params["w1"]) + self.params["b1"])
%         dhdt = np.dot(hidden, self.params["w2"]) + self.params["b2"]
% 
%         action = np.tanh(np.dot(hidden, self.params["wa"]) + self.params["ba"])
%         x, y = x[-2:]
% 
%         dxdt = y
%         dydt = 0.2 + 0.4 * action
% 
%         dxdt = np.array([dxdt]).reshape((1,))
%         dydt = np.array([dydt]).reshape((1,))
%         dfdt = np.concatenate([dhdt, dxdt, dydt], axis=0)
%         return dfdt
end

