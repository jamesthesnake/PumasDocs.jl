# Defining NLME Models

Nonlinear Mixed Effects (NLME) models are central to pharmacometric modeling.
A model is the structure which includes the dynamical equations, the structure
of the parameters (the names, domains, and constraints), and the observables.
This page documents the two interfaces for defining a NLME model:

1. The `@model` Domain-Specific Language (DSL) is for simplified definitions of
   NLME models with standard naming assumptions.
2. The function-based interface is for defining NLME models via Julia functions,
   allowing for full flexibility and efficiency.

We recommend that all users start with the `@model` DSL, and computationally-inclined
pharmacometricians who are comfortable with more programmatic development
(or those who need the enlarged feature-set) may wish to utilize the
function-based interface. Both interface with the proceeding simulation and
estimation tooling in the same manner.

### Quick Note on Probability Distributions

Many of the NLME model definition portions require the specification of
probability distributions. The distributions in PuMaS are defined by the
[Distributions.jl](https://juliastats.github.io/Distributions.jl/stable/) library.
All of the Distributions.jl `Distribution` types are able to be used throughout
the PuMaS model definitions. Multivariate domains defines values which are
vectors while univariate domains define values which are scalars. For the full
documentation of the `Distribution` types, please see
[the Distributions.jl documentation](https://juliastats.github.io/Distributions.jl/stable/)

## The `@model` DSL

The `@model` DSL allows for simplified NLME definitions. The components of a
model (in order) are as follows:

1. `@param` defines the fixed effects and other parameters of the model, along
   with the domains and constraints on the parameters (for estimation).
2. `@random` (optional) defines the random effects via probability distributions
   on the parameters.
3. `@covariates` (optional) defines the covariates of the model.
4. `@pre` defines the pre-processing collation between the parameters, random
   effects, and covariates for the definition of the dynamical parameters.
5. `@vars` (optional) defines aliases that can be used in the proceeding blocks.
6. `@init` (optional) defines the initial conditions for the dynamical model.
7. `@dynamics` defines the dynamical model, either by its differential equation
   or its analytical solution.
8. `@derived` defines the derived observables from the dynamical model's
   solution, including the error distributions.
9. `@observed` (optional) defines post-processing on the observables sampled
   from the error distributions.

All of these blocks allow the use of Julia functions defined outside of the
macro.

### `@param`: Parameters

This block defines the structure of the parameters within the model. Parameters
are defined by an `in` (or ∈, written via \in) statement specifying the `Domain`
type that the parameter  resides in. For example, to specify θ as a real scalar,
one would write:

```julia
θ in RealDomain()
```

```julia
θ ∈ RealDomain()
```

Many of these domains allow specifying bounds, for example, we can specify
θ as a scalar between 0.0 and 1.0 via:

```julia
θ ∈ RealDomain(lower=0.0,upper=1.0)
```

For the full specifications of the domain types, please the [the Domains page]().
Additionally, parameters can be defined via a probability distributions, in
which case the values are defined via `~`. For example, we can say that θ
comes from a standard normal distribution via:

```julia
θ ~ Normal(0,1)
```

Implicitly, the domain of θ is the support of the probability distributions.
Thus for this example, the domain of θ is the same as `RealDomain()`. However,
if θ the value of θ is not specified in the parameter list during simulation,
θ will automatically be sampled from this distribution. Additionally, this
probability distribution can be thought of as the prior distribution on
θ and is utilized in Bayesian estimation routines.

The parameters block is a list of parameter domain definitions, for example:

```julia
@param begin
    θ ∈ VectorDomain(3, lower=[0.0,0.0,0.0], upper=[20.0,20.0,20.0])
    Ω ∈ PSDDomain(2)
    Σ ∈ ConstDomain(0.1)
end
```

Note that this block is for the structure and not the values of the parameters.
The values are defined when invoking simulation or estimation so that they
can more easily be modified.

### `@random`: Random Effects

This block defines the structure of the random effect sampling process. These
structures are given by `~` statements to probability distributions which
may be defined by parameters. For example, if Ω is a positive-definite matrix,
we can specify that η is defined as a sample from a multivariate normal
distribution with covariance matrix Ω via the statement:

```julia
η ~ MVNormal(Ω)
```

The `@random` block is defined by a list of such statements, like:

```julia
@random begin
   η ~ MVNormal(Ω)
   κ ~ MVNormal(Π)
end
```

### `@covariates`: Covariates

The `@covariates` block defines the names of the covariates. This is a simply
a list of names, such as:

```julia
@covariates wt sex height
```

Covariates in the model match the structures they inherit from the data defined
in the `Subject`.

### `@pre`: Pre-Processing

The `@pre` block defines the pre-processing collation for the definition of
the dynamical parameters from the fixed and random effects. These values are
specified by equality (`=`) statements. For example, one may specify that the
parameter `Ka` is defined by the first value of θ and the first value of η,
we can write the command:

```julia
Ka = θ[1] * exp(η[1])
```

Standard Julia syntax can be used within this block, any externally defined
Julia functions can be used in this block, and the resulting variables can
be any Julia type. One consequence of allowing these values to be any Julia
type is that the pre-processed variables can be Julia functions. For example,
we can define Ka as a time-dependent function by using Julia's
[anonymous function syntax]():

```julia
Ka = t -> t*θ[1]
```

`@pre` is defined by a list of such equality statements, for example:

```julia
@pre begin
    Ka1     = θ[1]
    CL      = θ[2]*exp(η[1])
    Vc      = t -> t*θ[3]*exp(η[2])
end
```

### `@vars`: Variable Aliases

The `@vars` block defines aliases which can be used in the proceeding blocks.
In the `@init` and `@dynamics` blocks the statement is interpreted to take
place at the current solver time, while in the `@derived` and `@observed` the
values alias the time series along the solution. An alias is defined by an
equality (`=`) statement. For example, to define `conc` as an alias for
the dynamical variable `Central` divided by the parameter `V`, we would write
the equation:

```julia
conc = Central / V
```

Note that the variable `t` for time can be utilized within these expressions.
Inside the `@init` and `@dynamics` blocks it stands for the solver time, while
in the `@derived` and `@observed` blocks it stands for the current time in the
time series. For example,

```julia
conc_t = conc / t
```

is the value of `conc` divided by `t`.

The `@vars` block is defined by a list of such equality statements, such as:

```julia
@vars begin
    conc   = Central / V
    conc_t = conc / t
end
```

### `@init`: Initial Conditions

This block defines the initial conditions of the dynamical model in terms of
the parameters, random effects, and pre-processed variables. It is defined
by a series of equality (`=`) statements. For example, to set the initial
condition of the `Central` dynamical variable to be the value of the 5th term
of the parameter θ, we would use the syntax:

```julia
Central = θ[5]
```

The block is then given by a sequence of such statements, such as:

```julia
@init begin
   Central = θ[5]
end
```

Any variable omitted from this block is given the default initial condition
of 0. If the block is omitted, then all dynamical variables are initalized
at 0.

### `@dynamics`: The Dynamical Model

### `@derived`: Derived Observables

### `@observed`: Sampled Observations

## The PuMaSModel Function-Based Interface
