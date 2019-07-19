# Noncompartmental Analysis (NCA)

NCA is performed in Pumas by creating `NCASubject` and `NCAPopulation` types
which then preprocess the data to allow for easy generation of all NCA values.
These types come with plotting, `DataFrame`, and `report` overloads to ease the
analysis process.

## The NCA Functions

NCA functions can perform calculations on both `NCAPopulation` and `NCASubject`.
When the input is a `NCAPopulation`, then the output is a `DataFrame`, and when
the input is a `NCASubject`, the output is a number. The keyword argument
`interval` takes a tuple of two numbers like `(1., 10.)` which will compute the
quantity in the time interval, or `nothing` which will compute the quantity in
the entire time span. The keyword argument `normalize` (normalize with respect
to dosage) takes `true` or `false`. The keyword argument `auctype` (types of
AUC) takes `:inf` or `:last`. The keyword argument `method` takes `:linear`,
`:linuplogdown`, or `:linlog`. The keyword arguments `pred` (predicted) takes
`true` or `false`. A description of the NCA output functions with the default
arguments are as follows:

- `n_samples(subj)`: the number of measurements that is above the lower limit of
  quantification.
- `dosetype(subj)`: route.
- `tau(subj)`: dosing interval.
- `doseamt(subj)`: dosage amount.
- `lambdaz(subj)`: terminal elimination rate constant (``λz``).
- `lambdazr2(subj)`: coefficient of determination (``r²``) when calculating
  ``λz``. Note that is quantity must be computed after calculating ``λz``.
- `lambdazadjr2(subj)`: adjusted coefficient of determination (``adjr²``) when
  calculating ``λz``. Note that is quantity must be computed after calculating
  ``λz``.
- `lambdazr(subj)`: correlation coefficient (``r``) when calculating ``λz``.
  Note that is quantity must be computed after calculating ``λz``.
- `lambdaznpoints(subj)`: number of points that is used in the ``λz``
  calculation. Note that is quantity must be computed after calculating ``λz``.
- `lambdazintercept(subj)`: `y`-intercept in the log-linear scale when
  calculating ``λz``. Note that is quantity must be computed after calculating
  ``λz``.
- `lambdaztimefirst(subj)`: the first time point that is used in the ``λz``
  calculation. Note that is quantity must be computed after calculating ``λz``.
- `lambdaztimelast(subj)`: the last time point that is used in the ``λz``
  calculation. Note that is quantity must be computed after calculating ``λz``.
- `thalf(subj)`: half life.
- `span(subj)`: `(lambdaztimelast(subj; kwargs...) - lambdaztimefirst(subj) /
  thalf(subj)`. Note that is quantity must be computed after calculating ``λz``.
- `tmax(subj; interval=nothing)`: time of maximum concentration.
- `cmax(subj; interval=nothing, normalize=false)`: maximum concentration.
- `cmaxss(subj; normalize=false)`: steady-state maximum concentration.
- `tmin(subj)`: time of minimal concentration.
- `cmin(subj; normalize=false)`: minimum concentration.
- `cminss(subj; normalize=false)`: steady-state minimum concentration.
- `ctau(nca::NCASubject; method=:linear)`: concentration at the end of dosing
  interval.
- `cavgss(subj)`: average concentration over one period..
- `c0(subj)`: estimate the concentration at dosing time for an IV bolus dose.
- `tlast(subj)`: time of last measurable concentration.
- `clast(subj; pred=false)`: concentration corresponding to `tlast`.
- `tlag(subj)`: time prior to the first increase in concentration.
- `auc(subj; auctype=:inf, method=:linear, interval=nothing, normalize=false,
  pred=false)`: the area under the curve (AUC).
- `auctau(subj; method=:linear, interval=nothing, normalize=false, pred=false)`:
  the AUC in the dosing interval.
- `aumc(subj; auctype=:inf, method=:linear, interval=nothing, normalize=false,
  pred=false)`: the area under the first moment of the concentration (AUMC).
- `aumctau(subj; method=:linear, interval=nothing, normalize=false,
  pred=false)`: the AUMC in the dosing interval.
- `vz(subj; pred=false)`: volume of distribution during the terminal phase.
- `cl(subj; pred=false)`: total drug clearance.
- `vss(subj; pred=false)`: apparent volume of distribution at equilibrium for IV
  bolus doses.
- `fluctuation(nca; usetau=false)`: peak trough fluctuation over one dosing
  interval at steady state. It is ``100*(C_{maxss} - C_{minss})/C_{avgss}``
  (usetau=false) or ``100*(C_{maxss} - C_{tau})/C_{avgss}`` (usetau=true).
- `accumulationindex(subj)`: theoretical accumulation ratio.
- `auc_extrap_percent(subj; pred=false)`: the percentage of AUC infinity due to
  extrapolation from `tlast`.
- `auc_back_extrap_percent(subj; pred=false)`: the percentage of AUC infinity
  due to back extrapolation of `c0`.
- `aumc_extrap_percent(subj; pred=false)`: the percentage of AUMC infinity due
  to extrapolation from `tlast`.
- `aumc_back_extrap_percent(subj; pred=false)`: the percentage of AUMC infinity
  due to back extrapolation of `c0`.
- `mrt(subj; auctype=:inf)`: mean residence time from the time of dosing to the
  time of the last measurable concentration.
- `swing(subj; usetau=false)`: swing. It is ``swing =
  (C_{maxss}-C_{minss})/C_{minss}`` (usetau=false) or ``swing =
  (C_{maxss}-C_{tau})/C_{tau}`` (usetau=true).

These functions are all accessed from within the NCA submodule. For example,
to use `auc` on `NCAPopulation`, one would use `NCA.auc(pop)`.

## Analysis Functionality (Plots, Reports, DataFrame)

To plot `NCASubject` or `NCAPopulation`:
```julia
plot(subj; linear=true, loglinear=true, kwargs...)
```
when `linear=true` the plot in linear-linear scale will be shown, and when
`loglinear=true` the plot in linear-logarithmic scale will be shown. Please
consult [Plots.jl's documentation](http://docs.juliaplots.org/latest/) for more
information on the additional arguments and plotting functions.

To report NCA quantities in `DataFrame`:
```julia
report = NCAReport(pop; sigdigits=nothing, kwargs...)
report_df = to_dataframe(report)
```
`sigdigits` defaults to `nothing`, so all reporting quantities are in full
`Float64` precision. To truncate extraneous digits, one can do `sigdigits=4`.
One can put additional arguments (`kwargs...`) to `NCAReport`, and they will be
passed all NCA functions.

## PumasNCADF

The PumasNCADF is a standardized format for tabular data for NCA. The format has
the following columns:

- `id`: The string `id` of the subject.
- `conc`: the concentration time series measurements. Values must be floating
  point numbers or missing.
- `time`: the time at which the concentration was measured.
- `occasion`: the occasion for the observation. Must be an integer value at each time
  point.
- `amt`: the amount of a dose. Must be a floating point value at each dosing
  time, and otherwise missing.
- `route`: the route of administration. Possible choices are `iv` for intravenous,
  `ev` for extravascular, and `inf` for infusion.
- `duration`: the infusion duration. Should be a floating point value or missing.
- Grouping variables: Any additional column may be chosen as for grouping the
  output by.

### Parsing PumasNCADF

The parsing function for the PumasNCADF is as follows:

```julia
read_nca(df; group=nothing, ii=:ii, ss=:ss,
                  concu=true, timeu=true, amtu=true, verbose=true)
```

These arguments are:

- `df`: the required positional argument. This is either a string which is the
  path to a CSV file, or a `DataFrame` of tabular data for use in the NCA.
- `group`: the column to group the output by. Defaults to no grouping.
- `ii`: the interdose interval. Used to specify the interval length for steady
  state dosing.
- `ss`: the steady-state. Used to specify whether a dose is steady-state, a
  steady-state dose takes the value 1 and 0 otherwise. Defaults to the `:ss`
  column.
- `concu`: the units for concentration. Defaults to no units.
- `amtu`: the units for dosing amount. Defaults to no units.
- `timeu`: the units for time. Defaults to no units.
- `verbose`: When true, warnings will be thrown when the output is does not
  match PumasNCADF. Defaults to true.
