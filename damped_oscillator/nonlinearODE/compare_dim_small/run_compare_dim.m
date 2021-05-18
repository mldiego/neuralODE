% Set parameters
unc = 0.01;
unc_all = false;
models = {@node1,@node2,@node3,@node4,@node5,@node6,@node7,@node8,@node9,@node10,...
    @node11,@node12,@node13,@node14,@node15,@node16,@node17,@node18,@node19,@node20};
for dim=3:1:20
        reach_nlanode_small(models{dim},dim, unc, unc_all);
end