# Dosage Regimens

Dosage regimens can be defined in two ways, either via the `DosageRegimen`
constructor or the PuMaS NLME Data format (named PuMaSNDF).

## `DosageRegimen`

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

The definition of the values are as follows:

- `amt`: the amount of the dose. This is the only required value.
- `time`: the time at which the dose is given. Defaults to 0.
- `evid`: the event id. 1 specifies a normal event. 3 means it's a reset event,
  meaning that the value of the dynamical variable is reset to the `amt` at the
  dosing event. If 4, then the value is reset (to the steady state), and then
  a final dose is given. Defaults to 1.
- `ii`: the interdose interval. For steady state events, this is the length of
  time between successive doses. When `addl` is specified, this is the length
  of time to the next dose. Defaults to 0.
- `addl`: the number of additional doses of the same time to give. Defaults to 0.
- `rate`: the rate of administration. If 0, then the dose is instantaneous.
  Otherwise the dose is administrated at a constant rate for a duration equal
  to `amt/rate`.
- `ss`: an indicator for whether the dose is a steady state dose. A steady state
  dose is defined as the result of having applied the dose with the interval `ii`
  infinitely many successive times. 0 indicates that the dose is not a steady
  state dose. 1 indicates that the dose is a steady state dose. 2 indicates that
  it is a steady state dose that is added to the previous amount. The default
  is 0.

## PuMaSNDF
