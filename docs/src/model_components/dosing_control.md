# Dosing Control Parameters (DCP)

The `pre` part of a `PumasModel` allows for specifying special preprocessed
parameters known as the Dosing Control Parameters (DCP). Unlike standard parameters
which are for use in the proceeding blocks, the DCP are used to modify the
internal event handling of the Pumas. The DCP are defined as follows:

- `lags`: the lag of the dose. A dose with a lag will take place at time
  `t = dosetime + lag`. Default is zero.
- `bioav`: the bioavailability of the dose. The true dose is equal to `bioav*amt`
  where `amt` is the dose amount from the dosage regimen. Default is `1`.
- `rate`: the rate of the dosing.
- `duration`: the duration of the dose.

`rate` and `duration` handling are intertwined and always satisfy the relation
`amt = rate*duration`. Any two of the values are given, the third is automatically
defined. If both `rate` and `duration` are specified, then an error will be
given unless `amt = rate*duration` is satisfied.

## Input Definition

If a DCP is defined as a scalar, then it applies to all doses. For example,
if a `pre` block contains the definition:

```julia
lags = θ
```

and θ is a scalar, then every dose will be lagged by the parameter θ. Likewise,
if a DCP is defined as a collection, then the value of the collection corresponding
to the `cmt` of the dose specifies the DCP. For example:

```julia
lags = [2,0]
```

implies that any dose into `cmt=1` will have a lag of 2, while any dose into
`cmt=2` will have a lag of 0.

**Note: the ability to specify a DCP by a NamedTuple with names matching the
dynamical parameters is in development**
