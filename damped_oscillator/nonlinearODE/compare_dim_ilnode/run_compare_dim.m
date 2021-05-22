% Set parameters
unc = 0.01;
nnpath = "C:\Users\diego\Documents\GitHub\Python\sonode\experiments\damped_oscillators\ilnode(";
models = {@node0,@node1,@node2,@node3,@node4,@node5};
% for dim=0:1:5
%     path_node = nnpath + string(dim) + ")/5/model.mat";
%     reach_ilnode_small(path_node,models{dim+1},dim, unc, false);
% end
% run longer example
dim = 1; % augmented dimension
path_node = nnpath + string(dim) + ")/5/model.mat";
reach_ilnode_small(path_node,models{dim+1},dim, unc, true);