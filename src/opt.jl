function bayes_optimization(n, f, fdata, lb, ub, x, minf, params)
    cf = cfunction(f, Cdouble, (Cuint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Void}))
    ret = ccall(
        (:bayes_optimization, libbayesopt),
        Cint,
        (Cuint, Ptr{Void}, Ptr{Void},
         Ptr{Cdouble}, Ptr{Cdouble},
         Ptr{Cdouble}, Ptr{Cdouble},
         bopt_params),
        n, cf, fdata, lb, ub, x, minf, params)
    return ret
end
