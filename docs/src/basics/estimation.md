# Estimating Parameters of Pumas Models

Pumas can use the observational data of a `Subject` or `Population` to estimate
the parameters of an NLME model. This is done by two classes of methods.
Maximum likelihood methods find the parameters such that the observational
data has the highest probability of occurring according to the chosen error
distributions. Bayesian methods find a posterior probability distribution for
the parameters to describe the chance that a parameter has a given value given
the data. The following section describes how to fit an NLME model in Pumas
via the two methods.

## Defining Data for Estimation

Estimation is done by looking at the likelihood of likewise names. Thus, for
example if `subject.observations` is a `NamedTuple` with names `dv` and
`resp`, the likelihood calculation will be between values from `derived` named
`dv` and `resp`. If `dv` is a scalar in the observation data, then `dv`
from `derived` should also be a scalar. Likewise, if `dv` is an array like
a time series, then `dv` should be a size-matching time series when returned
from `derived`. Note that likelihoods are calculated between the probability
distribution from `derived` and the matching observation from
`subject.observations`. If no likelihood is associated with a `derived` value,
then the value has an implicit standard normal interpretation, which amounts
to having the L2 Euclidian distance taken as the likelihood during fitting
procedures.

**Note: Currently only `BayesMCMC` and `LaplaceI` support multiple output series.
all other likelihood approximations must have the derived and observation data
under the name `dv`**

**Note: Currently the estimation procedures require that there only exists a
single random effect (vector), and this vector must be named η (\eta)**

## Maximum Likelihood Estimation

Maximum Likelihood Estimation (MLE) is performed using the `fit` function. This
function's signature is:

```julia
Distributions.fit(m::PumasModel,
                  data::Population,
                  param::NamedTuple,
                  approx::LikelihoodApproximation,
                  args...;
                  optimize_fn = DEFAULT_OPTIMIZE_FN,
                  kwargs...)
```

The arguments are:

- `m`: a `PumasModel`, either defined by the `@model` DSL or the function-based
  interface.
- `data`: a `Population`.
- `param`: a named tuple of parameters. Used as the initial condition for the
  optimizer.
- `approx`: the marginal loglikelihood approximation to use for the maximum
  likelihood procedure.
- Extra `args` and `kwargs` are passed on to the internal `simobs` call and
  thus control the behavior of the differential equation solvers.
- `optimize_fn`: a function of two arguments `(cost,p)` where `cost` is the
  cost function and `p` is the initial parameters as a vector. This function
  defines the optimization routine that is used to find the maximum of the
  likelihood. The default optimization function uses the
  [Optim.jl](http://julianlsolvers.github.io/Optim.jl/stable/) library and is
  defined as follows:

```julia
function DEFAULT_OPTIMIZE_FN(cost,p)
  Optim.optimize(cost,p,BFGS(linesearch=Optim.LineSearches.BackTracking()),
                 Optim.Options(show_trace=verbose, # Print progress
                               store_trace=true,
                               extended_trace=true,
                               g_tol=1e-3),
                  autodiff=:finite)
end
```

The return type of `fit` is a `FittedPumasModel`.

### Marginal Likelihood Approximations

The following choices are available for the likelihood approximations:

- `FO()`: first order approximation.
- `FOI()`: first order approximation with interaction. Not complete.
- `FOCE()`: first order conditional estimation.
- `FOCEI()`: first order conditional estimation with interaction.
- `Laplace()`: second order Laplace approximation
- `LaplaceI()`: second order Laplace approximation with interaction.

### FittedPumasModel

The relevant fields of a `FittedPumasModel` are:

- `model`: the `model` used in the estimation process.
- `data`: the `Population` that was estimated.
- `approx`: the marginal likelihood approximation that was used.
- `param`: the optimal parameters.

Additionally, the following functions help interpret the fit:

- `vcov(fpm)` returns the covariance matrix between the population parameters
  for the `FittedPumasModel`
- `stderror(fpm)` returns the standard errors for the population parameters
  for the `FittedPumasModel`

Additionally the function:

```julia
predict(fpm::FittedPumasModel, approx=fpm.approx;
        nsim=nothing, timegrid=false, newdata=false, useEBEs=true)
```

Returns a `FittedPumasPrediction` which contains the solution of all population
diagnostics in the field `population` and all individual diagnostics in the
field `individual`. For more information on the diagnostics, please see the
[Simulation and Estimation Diagnostics](@ref)

## Bayesian Estimation

Bayesian parameter estimation is performed by using the `fit` function as follows:

```julia
fit(model::PumasModel, data::Population, ::BayesMCMC,
                       args...; nsamples=5000, kwargs...)
```

The arguments are:

- `m`: a `PumasModel`, either defined by the `@model` DSL or the function-based
  interface.
- `data`: a `Population`.
- The `approx` must be `BayesMCMC()`.
- `nsamples` determines the number of samples taken along each chain.
- Extra `args` and `kwargs` are passed on to the internal `simobs` call and
  thus control the behavior of the differential equation solvers.

The result is a `BayesMCMCResults` type. Notice that initial parameter values
are not utilized in Bayesian estimation.

### BayesMCMCResults

The MCMC chain is stored in the `chain` field of the returned `BayesMCMCResults`.
The following functions help with querying common results on the Bayesian
posterior:

- `param_mean(br)`: returns a named tuple of parameters which represents the
  mean of each parameter's posterior distribution
- `param_var(br)`: returns a named tuple of parameters which represents the
  variance of each parameter's posterior distribution
- `param_std(br)`: returns a named tuple of parameters which represents the
  standard deviation of each parameter's posterior distribution
