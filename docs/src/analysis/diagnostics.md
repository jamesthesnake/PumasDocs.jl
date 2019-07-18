# Simulation and Estimation Diagnostics

## The `infer` Function

## The `inspect` Function

## Individual Diagnostic Functions

### Population Residuals

- `npde` :

 `npde(model, subject, param, randeffs, simulations_count)`

To calculate the Normalised Prediction Distribution Errors (NPDE).

- `wres` : 

  `wres(model, subject, param[, rfx])`

To calculate the Weighted Residuals (WRES).
- `cwres` : 

  `cwres(model, subject, param[, rfx])`

To calculate the Conditional Weighted Residuals (CWRES).

- `cwresi` :
  
  `cwresi(model, subject, param[, rfx])`

To calculate the Conditional Weighted Residuals with Interaction (CWRESI).

### Individual Residuals

- `iwres`

  `iwres(model, subject, param[, rfx])`

To calculate the Individual Weighted Residuals (IWRES).
- `icwres`

  `icwres(model, subject, param[, rfx])`

To calculate the Individual Conditional Weighted Residuals (ICWRES).
- `icwresi`

  `icwresi(model, subject, param[, rfx])`

To calculate the Individual Conditional Weighted Residuals with Interaction (ICWRESI).
- `eiwres`

  `eiwres(model, subject, param[, rfx], simulations_count)`

To calculate the Expected Simulation based Individual Weighted Residuals (EIWRES).


### Model Metrics

- `AIC` :

  `aic(model, population, param, approximation)`

The Akaike information criterion (AIC) is an estimator of the relative quality of the model for a given set of data.

- `BIC`

  `bic(model, population, param, approximation)`

The Bayesian information criterion (BIC) 

### Random Effects

- `ηshrinkage` :

  `ηshrinkage(model, population, param, approximation)`

If the observations for an individual is informative, η-shrinkage will be low. If, onthe other hand, the observations are non-informative, the individual estimates(EBEs) will shrink towards the population mean. Hence, the variance of theEBEs will also shrink. This phenomenon is called η-shrinkage.
- `ϵshrinkage` :

  `ϵshrinkage(model, population, param, approximation[, rfx])`

When data gets sparse the IWRES distribution also shrink towards it’s mean (zero). This is often called overfitting or ϵ-shrinkage.

## The Visual Predictive Check (`vpc`) Function

`vpc(m::PumasModel, data::Population, fixeffs::NamedTuple, reps::Integer;quantiles = [0.05,0.5,0.95], idv = :time, dv = [:dv], stratify_on = nothing)`

Computes the quantiles for VPC. The default quantiles are the 5th, 50th and 95th percentiles. 

  args: PumasModel, Population, Parameters and Number of Repetitions  
        
  Instead of the model, simulations from a previous vpc run (obtained from VPC.Simulations) or a FittedPumasModel can be used.

  kwargs: quantiles - Takes an array of quantiles to be calculated. The first three indices are used for plotting. 
          idv - The idv to be used, defaults to time. 
          dv - Takes an array of symbols of the dvs for which the quantiles are computed.
          stratify_on - Takes an array of symbols of covariates which the VPC is stratified on.
