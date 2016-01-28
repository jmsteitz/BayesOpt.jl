# parameters

# wrapper of C types defined in include/bayesopt/parameters.h

@enum learning_type L_FIXED L_EMPIRICAL L_DISCRETE L_MCMC L_ERROR=-1
@enum score_type SC_MTL SC_ML SC_MAP SC_LOOCV SC_ERROR=-1

immutable kernel_parameters
    name::Cstring
    hp_mean::NTuple{128,Cdouble}
    hp_std::NTuple{128,Cdouble}
    n_hp::Csize_t
end

immutable mean_parameters
    name::Cstring
    coef_mean::NTuple{128,Cdouble}
    coef_std::NTuple{128,Cdouble}
    n_coef::Csize_t
end

type bopt_params
    n_iterations::Csize_t
    n_inner_iterations::Csize_t
    n_init_samples::Csize_t
    n_iter_relearn::Csize_t
    init_method::Csize_t
    random_seed::Cint
    verbose_level::Cint
    log_filename::Cstring
    load_save_flag::Csize_t
    load_filename::Cstring
    save_filename::Cstring
    surr_name::Cstring
    sigma_s::Cdouble
    noise::Cdouble
    alpha::Cdouble
    beta::Cdouble
    sc_type::score_type
    l_type::learning_type
    l_all::Cint
    epsilon::Cdouble
    force_jump::Csize_t
    kernel::kernel_parameters
    mean::mean_parameters
    crit_name::Cstring
    crit_params::NTuple{128,Cdouble}
    n_crit_params::Csize_t
end

function Base.show(io::IO, params::bopt_params)
    print(io, "BayesOpt parameters:")
    width = maximum([length(string(f)) for f in fieldnames(bopt_params)])
    for f in fieldnames(bopt_params)
        val = params.(f)
        if f == :sc_type
            val = score2str(val)
        elseif f == :l_type
            val = learn2str(val)
        elseif f in (:kernel, :mean)
            val = val.name
        end
        if isa(val, Number)
            val = string(val)
        elseif isa(val, Cstring)
            val = bytestring(val)
        else
            # skip
            continue
        end
        println(io)
        print(io, "  ", lpad(f, width), " = ", val)
    end
end

function learn2str(name::learning_type)
    return ccall((:learn2str, libbayesopt), Cstring, (learning_type,), name)
end

function score2str(name::score_type)
    return ccall((:score2str, libbayesopt), Cstring, (score_type,), name)
end

# setters
for f in [
      :set_kernel,
      :set_mean,
      :set_criteria,
      :set_surrogate,
      :set_log_file,
      :set_load_file,
      :set_save_file,
      :set_learning,
      :set_score]
    @eval function $f(params::bopt_params, name::ByteString)
        ccall(
            ($(string(f)), libbayesopt),
            Void,
            (Ref{bopt_params}, Cstring),
            params, name
        )
    end
end

function initialize_parameters_to_default()
    ccall(
        (:initialize_parameters_to_default, libbayesopt),
        bopt_params, ())
end
