# Simulation and Estimation Diagnostics

## The `infer` Function

## The `inspect` Function

## Individual Diagnostic Functions

### Population Residuals

- `npde(model, subject, param, randeffs, simulations_count)` : Normalized Prediction Distribution Errors
- `wres(model, subject, param[, rfx])` : Weighted Residuals
- `cwres(model, subject, param[, rfx])` : Conditional Weighted Residuals
- `cwresi(model, subject, param[, rfx])` : Conditional Weighted Residuals with Interaction

### Individual Residuals

- `iwres(model, subject, param[, rfx])` : Individual Weighted Residuals
- `icwres(model, subject, param[, rfx])` : Individual Conditional Weighted Residuals
- `icwresi(model, subject, param[, rfx])` : Individual Conditional Weighted Residuals with Interaction
- `eiwres(model, subject, param[, rfx], simulations_count)` : Expected Simulation based Individual Weighted Residuals

### Model Metrics

- `aic(model, population, param, approximation)` : Akaike information criterion
- `bic(model, population, param, approximation)` : Bayesian information criterion

### Random Effects

- `ηshrinkage(model, population, param, approximation)`
- `ϵshrinkage(model, population, param, approximation[, rfx])`

If the observations for an individual is informative, η-shrinkage will be low.
If, on the other hand, the observations are non-informative, the individual
estimates (EBEs) will shrink towards the population mean. Hence, the variance
of the EBEs will also shrink and η-shrinkage will be high.

When data gets sparse the IWRES distribution also shrink towards it’s mean
(zero). This is often called overfitting or ϵ-shrinkage.

## The Visual Predictive Check (`vpc`) Function

- `vpc(m::PumasModel, data::Population, fixeffs::NamedTuple, reps::Integer;quantiles = [0.05,0.5,0.95], idv = :time, dv = [:dv], stratify_on = nothing)`

Computes the quantiles for VPC. The default quantiles are the 5th, 50th and 95th percentiles.
Takes in a `PumasModel`, `Population`, parameters, and an integer number of
repetitions.

The `vpc` function returns a `VPC` object which can then be used for plotting. 

```julia
vpc_nonstrat = vpc(m, data, param, 200)
plot(vpc_nonstrat)
```
The `VPC` object stores the quantiles and the simulations which 
can be used for recalculating the VPC quantiles witha different combination of arguments.

```julia
vpc_stratwt = vpc(vpc_nonstrat.Simulations, data; stratify_on = [:wt])
plot(vpc_stratwt)
```

Note that instead of the model a FittedPumasModel can be also be used.

Keyword arguments:

- `quantiles`: Takes an array of quantiles to be calculated. The first three indices are used for plotting.
- `idv`: The idv to be used, defaults to time.
- `dv`: Takes an array of symbols of the dvs for which the quantiles are computed.
- `stratify_on`: Takes an array of symbols of covariates which the VPC is stratified on.
