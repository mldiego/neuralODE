using BenchmarkTools, Plots, Plots.PlotMeasures, LaTeXStrings
using BenchmarkTools: minimum, median

# How to keep track of time
# eltime3 = @elapsed sol3 = solve(prob, T=Tf, alg=alg, params=param3);

#SUITE = BenchmarkGroup()
#model = "DFP"
#cases = ["1"]
#SUITE[model] = BenchmarkGroup()

include("CTRNN_DFP.jl")
include("convert_sets.jl")

# ------------------------
# Case 1 
# ------------------------

prob = CTRNN_DFP()
alg = TMJets(abstol=1e-10, orderT=8, orderQ=1);

time_1 = @elapsed sol_1 = solve(prob, T=2.0, alg=alg);
solz_1 = overapproximate(sol_1, Zonotope);


# ------------------------
# Case 2 
# ------------------------

prob = CTRNN_DFP()
orderT = 10
# alg = TMJets21a(abstol=1e-10, orderT=orderT, orderQ=1, maxsteps=3500)
alg = TMJets(abstol=1e-10, orderT=orderT, orderQ=1);

time_2 = @elapsed sol_2 = solve(prob, T=10.0, alg=alg);
solz_2 = overapproximate(sol_2, Zonotope);


convert_sets(solz_1, 5, 8, "results/dfp1.mat")
convert_sets(solz_2, 5, orderT, "results/dfp2.mat")

matwrite("dfp_time.mat", Dict("time_1" => time_1,"time_2" => time_2); compress = false)
