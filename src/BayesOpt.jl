module BayesOpt

export bayesopt

if isfile(joinpath(dirname(@__FILE__), "..", "deps", "deps.jl"))
    include("../deps/deps.jl")
else
    error("BayesOpt was not properly installed. Please run Pkg.build(\"BayesOpt\")")
end

include("params.jl")
include("opt.jl")

# This doesn't work on v0.4 since closures aren't c-callable functions.
function bayesopt(
        f::Function,
        x0::Vector{Float64},
        lb::Vector{Float64},
        ub::Vector{Float64};
        n_iterations::Integer=190,
        verbose_level::Integer=1)
    # wrap the function f (assumed to take an argument of Vector{Float64}) with a closure
    function f′(n, x, grad, fdata)
        return f(pointer_to_array(x, n))
    end
    params = initialize_parameters_to_default()
    params.n_iterations = n_iterations
    params.verbose_level = verbose_level
    minf = Ref{Float64}(0)
    x = copy(x0)
    r = bayes_optimization(length(x), f′, C_NULL, lb, ub, x, minf, params)
    if r != 0
        error("optimization failed")
    end
    return minf[], x
end

end # module
