module BayesOpt

#export bayesopt

if isfile(Pkg.dir("BayesOpt", "deps", "deps.jl"))
    include("../deps/deps.jl")
else
    error("BayesOpt was not properly installed. Please run Pkg.build(\"BayesOpt\")")
end

include("params.jl")
include("opt.jl")

#=
This doesn't work since closures aren't c-callable functions.
function bayesopt(f::Function, x0::Vector{Float64}, lb::Vector{Float64}, ub::Vector{Float64})
    function wrapf(n, x, grad, fdata)
        return f(x)
    end
    minf = Ref{Float64}(0)
    params = initialize_parameters_to_default()
    params.verbose_level = 0
    x = copy(x0)
    r = bayes_optimization(length(x), wrapf, C_NULL, lb, ub, x, minf, params)
    if r != 0
        error("optimization failed")
    end
    return minf[], x
end
=#

end # module
