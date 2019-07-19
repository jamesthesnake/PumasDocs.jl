# Dosage Regimens, Subjects, and Populations

The data is passed to a Pumas model via the `Population` type. A `Population` is
a collection of `Subject`s. In this section we will specify the methods used
for defining `Subject`s and `Population`s. These types can either be defined
programmatically using the `Subject` and `Population` constructors on Julia types
or by using the Pumas NLME Data format (named PumasNDF).

## Dosage Regimen Terminology

Both the `DosageRegimen` and the `PumasNDF` utilize the same terminology for
describing a dose. The definition of the values are as follows:

- `amt`: the amount of the dose. This is the only required value.
- `time`: the time at which the dose is given. Defaults to 0.
- `evid`: the event id. `1` specifies a normal event. `3` means it's a reset event,
  meaning that the value of the dynamical variable is reset to the `amt` at the
  dosing event. If `4`, then the value is reset (to the steady state), and then
  a final dose is given. Defaults to `1`.
- `ii`: the interdose interval. For steady state events, this is the length of
  time between successive doses. When `addl` is specified, this is the length
  of time to the next dose. Defaults to `0`.
- `addl`: the number of additional events of the same types, spaced by `ii`.
  Defaults to 0.
- `rate`: the rate of administration. If `0`, then the dose is instantaneous.
  Otherwise the dose is administrated at a constant rate for a duration equal
  to `amt/rate`.
- `ss`: an indicator for whether the dose is a steady state dose. A steady state
  dose is defined as the result of having applied the dose with the interval `ii`
  infinitely many successive times. `0` indicates that the dose is not a steady
  state dose. 1 indicates that the dose is a steady state dose. 2 indicates that
  it is a steady state dose that is added to the previous amount. The default
  is 0.

## The Subject Constructor

A `Subject` can be constructed using the following constructor:

```julia
Subject(;id = 1,
         obs = nothing,
         cvs = nothing,
         evs = Event[],
         time = obs isa AbstractDataFrame ? obs.time : nothing
         )
```

The definitions of the arguments are as follows:

- `id` is the id of the subject. Defaults to `1`.
- `obs` is a Julia type which holds the observational data. When using the
  `@model` interface, this must be a `NamedTuple` whose names match those
  of the derived variables.
- `cvs` are the covariates for the subject. It can be any Julia type when working
  with the function-based interface, but must be a `NamedTuple` for the `@model`
  interface. Defaults to `nothing`, meaning no covariates.
- `evs` is a `DosageRegimen`. Defaults to an empty event list.
- `time` is the list of times associated with the observations.

### `DosageRegimen`

The `DosageRegimen` type is a specification of a regimen. Its constructor is:

```julia
DosageRegimen(amt;
              time = 0,
              cmt  = 1,
              evid = 1,
              ii   = zero.(time),
              addl = 0,
              rate = zero.(amt)./oneunit.(time),
              ss   = 0)
```

Each of the values can either be `AbstractVector`s or scalars. All vectors must
be of the same length, and the elementwise combinations each define an event
(with scalars being repeated).

Additionally, multiple `DosageRegimen`s can be combined to form a `DosageRegimen`.
For example, if we have:

```julia
dr1 = DosageRegimen(100, ii = 24, addl = 6)
dr2 = DosageRegimen(50,  ii = 12, addl = 13)
dr3 = DosageRegimen(200, ii = 24, addl = 2)
```

then the following is the `DosageRegimen` for the combination of all doses:

```julia
dr = DosageRegimen(e1, e2, e3)
```

The current `DosageRegimen` can be viewed in its tabular form using the
`DataFrame` function: `DataFrame(dr)`.

## The Population Constructor

The `Population` constructor is simply `Population(subjects)`, where
`subjects` is a collection of `Subject`s.

## PumasNDF

The PumasNDF is a specification for building a `Population` from
tabular data. Generally this tabular data is given by a database like a CSV.
The CSV has columns described as follows:

- `id`: the ID of the individual. Each individual should have a unique integer,
  or string.
- `time`: the time corresponding to the row. Should be unique per id, i.e. no
  duplicate time values for a given subject.
- `evid`: the event id. `1` specifies a normal event. `3` means it's a reset event,
  meaning that the value of the dynamical variable is reset to the `amt` at the
  dosing event. If `4`, then the value is reset (to the steady state), and then
  a final dose is given. Defaults to `0` if amt is `0` or missing, and 1 otherwise.
- `amt`: the amount of the dose. If the `evid` column exists and is non-zero,
  this value should be non-zero. Defaults to `0`.
- `ii`: the interdose interval. When `addl` is specified, this is the length
  of time to the next dose. For steady state events, this is the length of
  time between successive doses. Defaults to `0`, and is required to be non-zero on
  rows where a steady-state event is specified.  
- `addl`: the number of additional doses of the same time to give. Defaults to 0.
- `rate`: the rate of administration. If `0`, then the dose is instantaneous.
  Otherwise the dose is administrated at a constant rate for a duration equal
  to `amt/rate`. A `rate=-2` allows the `rate` to be determined by a
  [Dosing Control Parameters (DCP)](@ref). Defaults to `0`.
- `ss`: an indicator for whether the dose is a steady state dose. A steady state
  dose is defined as the result of having applied the dose with the interval `ii`
  infinitely many successive times. `0` indicates that the dose is not a steady
  state dose. `1` indicates that the dose is a steady state dose. `2` indicates that
  it is a steady state dose that is added to the previous amount. The default
  is `0`.
- `cmt`: the compartment being dosed. Defaults to `1`.
- `duration`: the duration of administration. If `0`, then the dose is instantaneous.
  Otherwise the dose is administered at a constant rate equal to `amt/duration`.
  Defaults to `0`.
- Observation and covariate columns should be given as a time series of values
  of matching type. Constant covariates should be constant through the full
  column. Time points without a measurement should be denoted by a `.`.

If a column does not exists, its values are imputed to be the defaults.
Special notes:

- If `rate` and `duration` exist, then it is enforced that `amt=rate*duration`
- All values and header names are interpreted as lower case.

### PumasNDF Parsing

```julia
read_Pumas(data;vs=Symbol[],dvs=Symbol[:dv]
                        id=:id, time=:time, evid=:evid, amt=:amt, addl=:addl,
                        ii=:ii, cmt=:cmt, rate=:rate, ss=:ss)
```

The arguments are as follows:

- `data` is the tabular data source. If a string path to a CSV is given, then
  it will read the CSV file from that location in the file system. If a Julia-based
  tabular data structure is given, such as a
  [DataFrame](http://juliadata.github.io/DataFrames.jl/stable/), then that
  structure will be used as the data source.
- `cvs` is the list of symbols for the header names of the covariate columns.
- `dvs` is the list of symbols for the header names of the observation data columns.

The other arguments are optional and allow changing the column names from their
default.

### NMTRAN Parsing

Additionally, there exist a parsing function `process_nmtran` for parsing
general NONMEM files. This function is a work-in-progress.

```julia
process_nmtran(data,cvs=Symbol[],dvs=Symbol[:dv];
                        id=:id, time=:time, evid=:evid, amt=:amt, addl=:addl,
                        ii=:ii, cmt=:cmt, rate=:rate, ss=:ss)
```
