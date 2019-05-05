# Noncompartmental Analysis (NCA)

NCA is performed in PuMaS by creating `NCASubject` and `NCAPopulation` types
which then preprocess the data to allow for easy generation of all NCA values.
These types come with plotting, `DataFrame`, and `report` overloads to ease the
analysis process.

## The NCASubject and NCAPopulation constructors

The `NCASubject` constructor is as follows:

```julia
NCASubject(conc, time;
           concu=true, timeu=true,
           id=1, group=nothing, dose=nothing, llq=nothing, clean=true,
           lambdaz=nothing, ii=nothing, kwargs...)
```

`conc` is the timeseries of concentrations to analyze and `time` is the time
points which correspond to the time series. The keyword arguments are:

- ii: the inter-dose interval between doses (for multiple doses)

An `NCAPopulation` takes in a vector of `NCASubject` and allows for the
analysis on multiple subjects at once.

## The NCA Functions

A description of the NCA output functions are as follows:

- `auc`: the area under the curve.

These functions are all accessed from within the NCA submodule. For example,
to use `auc` on `NCAPopulation`, one would use `NCA.auc(ncapop)`.

## Analysis Functionality (Plots, Reports, DataFrame)

## PuMaSNCADF

The PuMaSNCADF is a standardized format for tabular data for NCA. The format has
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

### Parsing PuMaSNCADF

The parsing function for the PuMaSNCADF is as follows:

```julia
read_nca(df; group=nothing, ii=nothing,
                  concu=true, timeu=true, amtu=true, verbose=true)
```

These arguments are:

- `df`: the required positional argument. This is either a string which is the
  path to a CSV file, or a `DataFrame` of tabular data for use in the NCA.
- `group`: the column to group the output by. Defaults to no grouping.
- `ii`: the interdose interval. Used to specify the interval length for steady
  state dosing.
- `concu`: the units for concentration. Defaults to no units.
- `amtu`: the units for dosing amount. Defaults to no units.
- `timeu`: the units for time. Defaults to no units.
- `verbose`: When true, warnings will be thrown when the output is does not
  match PuMaSNCADF. Defaults to true.
