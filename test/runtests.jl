using BayesOpt
using Base.Test

# simple quadratic function
function testfunc(n, x, grad, fdata)
    f = 0.0
    let x = pointer_to_array(x, n)
        for i in 1:n
            f += (x[i] - .53)^2
        end
    end
    return f::Cdouble
end

# low-level interfaces (not exported)
let
    n = 10
    fdata = C_NULL
    lb = ones(n) * 0
    ub = ones(n) * 1
    xmin = similar(lb)
    fmin = similar(lb)
    params = BayesOpt.initialize_parameters_to_default()
    @test isa(params, BayesOpt.bopt_params)
    params.verbose_level = 0
    r = BayesOpt.bayes_optimization(n, testfunc, fdata, lb, ub, xmin, fmin, params)
    @test r == 0
    @test vecnorm(xmin - 0.53) < 0.1
end

# high-level interfaces (exported)
#let
#    n = 10
#    x0 = rand(n)
#    lb = ones(n) * 0
#    ub = ones(n) * 1
#    fmin, xmin = bayesopt(testfunc, x0, lb, ub)
#    @show fmin xmin
#    @test fmin < 0.1
#    @test vecnorm(xmin - 0.53) < 0.1
#end
