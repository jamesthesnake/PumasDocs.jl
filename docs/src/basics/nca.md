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
           id=1, group=nothing, dose::T=nothing, llq=nothing, clean=true,
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

- `id`: The `id` of the subject.
- `conc`: the concentration time series measurements.
- `time`: the time at which the concentration was measured.

The parsing function for the PuMaSNCADF is as follows:

```julia
parse_ncadata(df; id=:ID, group=nothing, time=:time, conc=:conc, occasion=nothing,
              amt=nothing, formulation=nothing, route=nothing,# rate=nothing,
              duration=nothing, ii=nothing, concu=true, timeu=true, amtu=true, warn=true, kwargs...)
```

The required positional argument is either a string which is the path to a CSV
file, or a `DataFrame` of tabular data for use in the NCA.
