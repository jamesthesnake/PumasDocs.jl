# Simulation and Estimation Diagnostics

## The `infer` Function

`infer(fpm::FittedPumasModel)` 

`infer` computes the `vcov` matrix (the covariance matrix of the population parameters) and returns 
a `FittedPumasModelInference` object used for inference based on the fitted model `fpm`. It gives the 
95% confidence intervals and the relative standard errors for the parameter estimates

## The `inspect` Function

`inspect(fpm::FittedPumasModel)`

`inspect` returns a `FittedPumasModelInspection` object with the model predictions, residuals and Empirical Bayes estimates.

## Model Diagnostic Functions

Model diagnostics are used to check if the model fits the data well. A numberof residual diagnostics are available as well as shrinkage estimators.

### Population Residuals

Populations residuals take the inter-individual variability into account as opposed to individual residuals which are correlated due to the lack of accounting for inter-individual variability.

- `npde(model, subject, param, randeffs, simulations_count)` : Normalized Prediction Distribution Errors

The null hypothesis is that the validation data can be described by a given model. This null hypothesis can be tested with NPDEs by checking that they follow a standard normal distribution and that the NPDEs are uncorrelated.

The normalized prediction distribution error (NPDE), for subject $i$ and observation $j$, is calculated as follows:

\begin{equation}
npde_{ij} = \Phi^{-1}(pde_{ij})
\end{equation}
where $\Phi^{-1}$ is the inverse of the standard normal cumulative density function and the prediction distribution errors ($pde_{ij}$) are defined as: 

\begin{equation}
pde_{ij} = \frac{1}{N_{sim}}\sum_{n=1}^{N_{sim}}{\phi_{ijn}}
\end{equation}
where $N_{sim}$ is the total number of simulated datasets and $\phi_{ijn}$ is 1 if the $n$ simulated decorrelated observation is below the actual decorrelated observation, i.e. $y_{ij,decorr}^{n} < y_{ij,decorr}$, otherwise $\phi_{ijn}$ is 0. The decorrelated observations and decorrelated simulated observations are calculated as:

\begin{equation} \label{eq:npde_decorr}
y_{i,decorr} = \mathbf{V}[y_i]^{-1/2}(y_i-\mathbf{E}[y_i])
\end{equation}
\begin{equation} \label{eq:npde_decorr_sim}
y_{i,decorr}^n = \mathbf{V}[y_i]^{-1/2}(y_i^n-\mathbf{E}[y_i])
\end{equation}

where $\mathbf{E}[y_i]$ and $\mathbf{V}[y_i]$ are the empirical mean and variance of the data respectively. The empirical mean and variance are calculated as:

\begin{equation} \label{eq:npde_mean}
\mathbf{E}[y_i] = \frac{1}{N_{sim}}\sum_{n=1}^{N_{sim}}y_i^n
\end{equation}
and 

\begin{equation}
\mathbf{V}[y_i] = \frac{1}{N_{sim}-1}\sum_{n=1}^{N_{sim}}(y_i^n-\mathbf{E}[y_i])(y_i^n-\mathbf{E}[y_i])^T
\end{equation}

- `wres(model, subject, param[, rfx])` : Weighted Residuals

The simplest population weighted residuals are the WRES which are, for subject $i$, calculated as:

\begin{equation} \label{eq:wres}
WRES_i = \mathbf{V}[y_i]^{-1/2}(y_i-\mathbf{E}[y_i])
\end{equation}
where the variance is the FO variance, see \eqref{eq:fovar} and the mean is the FO mean, $\mathbf{E}[y_i] = f_i(\theta,\eta_i^*=0,Z_i,t_i)$. 


- `cwres(model, subject, param[, rfx])` : Conditional Weighted Residuals

When the model starts to get non-linear with respect to the random effects the WRES might not be accurate enough. In such situations, other residuals based on linearization can be utilized. These residuals are conditioned on the EBEs and are therefore a better approximation of the true residuals. The CWRES, for subject $i$, are defined as:

\begin{equation} \label{eq:cwres}
CWRES_i = \mathbf{V}[y_i]^{-1/2}(y_i-\mathbf{E}[y_i])
\end{equation}
where the variance is the FOCE variance and the mean is the FOCE mean, $\mathbf{E}[y_i] = f_i(...,\eta_i^* =\hat{\eta}_i^* )-F_i\hat{\eta}_i^{*T}$. 

- `cwresi(model, subject, param[, rfx])` : Conditional Weighted Residuals with Interaction

A further improvement of the CWRES residuals can be made when interaction in the residual error model is present. The CWRESI, for subject $i$, are defined as:

\begin{equation} \label{eq:cwresi}
CWRESI_i = \mathbf{V}[y_i]^{-1/2}(y_i-\mathbf{E}[y_i])
\end{equation}
where the variance is the FOCE variance but evaluated at $\eta_i^* =\hat{\eta}_i^* $ instead of $\eta_i^* =0$, see \eqref{eq:focevar} and the mean is the FOCE mean, $\mathbf{E}[y_i] = f_i(...,\eta_i^* =\hat{\eta}_i^* )-F_i\hat{\eta}_i^{*T}$.

### Individual Residuals

- `iwres(model, subject, param[, rfx])` : Individual Weighted Residuals

The individual weighted residual are similar as the WRES but without acknowledge the inter-individual variability, i.e. the individual weighted residuals for subject $i$, are defined as:
\begin{equation}\label{eq:IWRES}
IWRES_i=R_i^{-1/2}(y_i-f_i(\theta,\eta_i^*=0,Z_i,t_i))
\end{equation}
where $R_i$ is the residual variance for subject $i$

- `icwres(model, subject, param[, rfx])` : Individual Conditional Weighted Residuals

As between the FO estimation method and FOCE estimation method, residuals can be evaluated at the EBEs or at 0. For the ICWRES, the model is evaluated at the estimated EBEs: 
\begin{equation} \label{eq:ICWRES}
ICWRES_i=R_i^{-1/2}(y_i-f_i(\theta,\eta_i^* =\hat{\eta}_i^*,Z_i,t_i))
\end{equation}
where $R_i$ is the residual variance for subject $i$, see \eqref{eq:res_var}. Note that the residual variance of ICWRES are evaluated at $\eta_i^*=0$

- `icwresi(model, subject, param[, rfx])` : Individual Conditional Weighted Residuals with Interaction

The ICWRESI is very similar to the ICWRES, except that the residual variance is evaluated at the EBEs:

\begin{equation} \label{eq:ICWRESI}
ICWRESI_i=R_i^{-1/2}(y_i-f_i(\theta,\eta_i^* =\hat{\eta}_i^*,Z_i,t_i))
\end{equation}
where $R_i$ is the residual variance for subject $i$, see \eqref{eq:res_var}. Note that the residual variance of ICWRESI are evaluated at $\eta_i^* =\hat{\eta}_i^*$

- `eiwres(model, subject, param[, rfx], simulations_count)` : Expected Simulation based Individual Weighted Residuals

These residual are calculated similarly as the population residuals in the NPDE calculations but instead of decorrelating the population residuals, the expectation of the individual weighted residuals are taken with respect to the omega distribution, i.e.:

\begin{equation}  \label{eq:EIWRES}
EIWRES_i=\frac{1}{N_{sim}}\sum_{k=1}^{N_{sim}}\mathbf{V}[y_i|\eta^k]^{-1/2}(y_i-\mathbf{E}[y_i|\eta^k])
\end{equation}

where $\mathbf{E}[y_i|\eta^k]$ is the individual mean given $\eta^k$ and $\mathbf{V}[y_i|\eta^k]$ is the individual variance given $\eta^k$. 

### Population Predictions

The populations residuals are defined as the difference between the observations and the model expectation for subject $i$, i.e. $y_i-\mathbf{E}[y_i]$, where the $\mathbf{E}[y_i]$ are the population predictions. The population predictions, EPRED, PRED, CPRED and CPREDI  are defined as the $\mathbf{E}[y_i]$ from equations of NPDE, WRES, CWRES and CWRESI respectively.

### Individual Predictions

The individual residuals are defined as the difference between the observations and the model prediction for subject $i$, i.e. $y_i-f_i(\theta,\eta_i^* ,Z_i,t_i)$, where the $f_i(\theta,\eta_i^* ,Z_i,t_i)$ are the individual predictions. The individual predictions IPRED, CIPRED and CIPREDI are defined as the $f_i(\theta,\eta_i^*,Z_i,t_i)$ from equations of IWRES, ICWRES and ICWRESI. The individual expected prediction (EIPRED) is defined as the individual mean conditioned on $\eta_k$, i.e. $\mathbf{E}[y_i|\eta^k]$, from equation of EIWRES.

### Model Metrics

- `aic(model, population, param, approximation)` : Akaike information criterion
- `bic(model, population, param, approximation)` : Bayesian information criterion

### Shrinkage

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
can be used for recalculating the VPC quantiles with a different combination of arguments.

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
