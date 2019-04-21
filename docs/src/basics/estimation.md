# Estimating Parameters of PuMaS Models

PuMaS can use the observational data of a `Subject` or `Population` to estimate
the parameters of an NLME model. This is done by two classes of methods.
Maximum likelihood methods find the parameters such that the observational
data has the highest probability of occurring according to the chosen error
distributions. Bayesian methods find a posterior probability distribution for
the parameters to describe the chance that a parameter has a given value given
the data. The following section describes how to fit an NLME model in PuMaS
via the two methods.

## Maximum Likelihood Estimation

Maximum Likelihood Estimation (MLE) is performed using the `fit` function. This
function's signature is:

```julia
```
