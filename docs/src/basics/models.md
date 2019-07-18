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
probability distributions. The distributions in Pumas are defined by the
[Distributions.jl](https://juliastats.github.io/Distributions.jl/stable/) library.
All of the Distributions.jl `Distribution` types are able to be used throughout
the Pumas model definitions. Multivariate domains defines values which are
vectors while univariate domains define values which are scalars. For the full
documentation of the `Distribution` types, please see
[the Distributions.jl documentation](https://juliastats.github.io/Distributions.jl/stable/)

## The `@model` DSL

The `@model` DSL allows for simplified NLME definitions. This interface can also
be used to define simpler linear and probability distribution models without
the mixed effects. The components of a model (in order) are as follows:

1. `@param` defines the fixed effects and other parameters of the model, along
   with the domains and constraints on the parameters (for estimation).
2. `@random` (optional) defines the random effects via probability distributions
   on the parameters.
3. `@covariates` (optional) defines the covariates of the model.
4. `@pre` defines the pre-processing collation between the parameters, random
   effects, and covariates for the definition of the dynamical parameters.
5. `@vars` (optional) defines aliases that can be used in the proceeding blocks.
6. `@init` (optional) defines the initial conditions for the dynamical model.
7. `@dynamics` (optional) defines the dynamical model, either by its
   differential equation or its analytical solution.
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
θ ∈ RealDomain(lower=0.0, upper=1.0)
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
if the value of θ is not specified in the parameter list during simulation,
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

or

```julia
@covariates begin
   wt
   sex
   height
end
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
we can define `Ka` as a time-dependent function by using Julia's
[anonymous function syntax]():

```julia
Ka = t -> t*θ[1]
```

`@pre` is defined by a list of such equality statements, for example:

```julia
@pre begin
    Ka     = θ[1]
    CL      = θ[2]*exp(η[1])
    Vc      = t -> t*θ[3]*exp(η[2])
end
```

#### Dosing Control Parameters

Special parameters, such as `lag`, are used to control the internal event
handling (dosing) system. For more information on these parameters, see the
[Dosing Control Parameters]() page.

### `@vars`: Variable Aliases

The `@vars` block defines aliases which can be used in the proceeding blocks.
In the `@init` and `@dynamics` blocks the statement is interpreted to take
place at the current solver time, while in the `@derived` and `@observed` the
values alias the time series along the solution. An alias is defined by an
equality (`=`) statement. For example, to define `conc` as an alias for
the dynamical variable `Central` divided by the parameter `V`, we would write
the equation:

```julia
@vars begin
   conc = Central / V
end
```

Note that the variable `t` for time can be utilized within these expressions.
Inside the `@init` and `@dynamics` blocks it stands for the solver time, while
in the `@derived` and `@observed` blocks it stands for the current time in the
time series. For example,

```julia
@vars begin
   conc_t = conc / t
end
```

is the value of `conc` divided by `t`.

The `@vars` block is defined by a list of such equality statements, such as:

```julia
@vars begin
    conc   = Central / V
    conc_t = conc / t
end
```

Note that the special value `:=` can be used to define intermediate statements
that will not be carried outside of the block.

### `@init`: Initial Conditions

This block defines the initial conditions of the dynamical model in terms of
the parameters, random effects, and pre-processed variables. It is defined
by a series of equality (`=`) statements. For example, to set the initial
condition of the `Response` dynamical variable to be the value of the 5th term
of the parameter θ, we would use the syntax:

```julia
Response = θ[5]
```

The block is then given by a sequence of such statements, such as:

```julia
@init begin
   Response1 = θ[5]
   Response2 = Kin/Kout
end
```

where `Kin` and `Kout` were defined earlier in the `@pre` block.

Any variable omitted from this block is given the default initial condition
of 0. If the block is omitted, then all dynamical variables are initialized
at 0.

Note that the special value `:=` can be used to define intermediate statements
that will not be carried outside of the block.

### `@dynamics`: The Dynamical Model

The `@dynamics` block defines the nonlinear function from the parameters to
the derived variables via a dynamical (differential equation) model. It can
currently be specified either by an analytical solution type or via an
ordinary differential equation (ODE) (for more types of differential equations,
please see the function-based interface).

The analytical solutions are defined in the
[dynamical types]() page and can be invoked via the name. For example,

```julia
@dynamics OneCompartmentModel
```

defines the dynamical model as the `OneCompartmentModel`.

For a system of ODEs, the dynamical variables are defined by their derivative
expression. A derivative expression is given by a variable's derivative
(specified by `'`) and an equality (`=`). For example, the following defines
the value `Depot` by it's ODE:

```julia
Depot' = -Ka*Depot
```

where `Ka` was defined in the `@pre` block. Variable aliases defined in the
`@vars` are accessible in this block. Additionally, the variable `t` is reserved
for the solver time. For example, if `Ka(t)` was defined as a function in the
`@pre` block, then the value of `Ka` at solver time can be utilized in the
derivative expression via:

```julia
Depot' = -Ka(t)*Depot
```

This is utilized for handling constructs such as time-varying covariates.

Note that any Julia function defined outside of the `@model` block can be
invoked in the `@dynamics` block.

### `@derived`: Derived Observables

The `@derived` block defines the derived observables of the NLME model. They
can be defined by any combination of the parameters, random effects, covariates,
preprocessed variables, dynamical variables, and aliases. In this block, the
value `t` is the time series which matches the array given in `subject.time`.
The dynamical variables are an array which matches `t` in size, where `var[i]`
is the value of the dynamical variable at time `t[i]`. Any aliases of a
dynamical variable are also a time series.

Observables can either be defined by equality statements `=` or by a distribution
with `~`. For example, the equality statement

```julia
conc = @. Central / V
```

defines an array `conc` to be output from the model. Notice that we used Julia's
[broadcast syntax]() (`@.`) for specifying that every value of Central is to be divided
by `V`. Note that any standard Julia syntax (and externally defined functions)
are allowed in this block.

Error models are defined by `~` statements to probability distributions. For
example, the following defines a time series of Normal distributions centered
around the value of `conc` with a variance dependent on `conc` and `ϵ`:

```julia
@derived begin
   dv ~ @. Normal(conc,conc*ϵ)
end
```

The likelihood of these distributions are utilized in the maximum likelihood
and Bayesian estimation routines. Additionally, values in the `@observed`
block are sampled from these error models.

The `@derived` block is defined by a list of these expressions, for example:

```julia
@derived begin
   conc = @. Central / V
   dv ~ @. Normal(conc,conc*ϵ)
end
```

Note that the special value `:=` can be used to define intermediate statements
that will not be carried outside of the block.

As a convenience, tie-ins with the included Noncompartmental Analysis (NCA)
suite are given with via the `@nca` macro. For example, we can perform an NCA
analysis via:

```julia
@derived begin
   conc = @. Central / V
   dv ~ @. Normal(conc,conc*ϵ)
   nca := @nca conc
end
```

to build an `NCASubject` using the time series given by the derived or dynamical
variable `conc`. Once defined, the [functionality of the NCA module]() can be
used to define derived variables via NCA diagnostics, for example:

```julia
@derived begin
   conc = @. Central / V
   dv ~ @. Normal(conc,conc*ϵ)
   nca := @nca conc
   auc =  NCA.auc(nca)
   thalf =  NCA.thalf(nca)
   cmax = NCA.cmax(nca)
end
```

Notice that the `@derived` block can mix values of different types (such as
arrays and scalars) in the output.  

### `@observed`: Sampled Observations

The `@observed` block allows one to define output variables based on the
sampled values from the error model. These are given by equality statements
(`=`) which can utilize the parameters, random effects, covariates, dynamical
variables, and any sampled derived variables. For example, if we had defined:

```julia
@derived begin
   dv ~ @. Normal(conc,conc*ϵ)
end
```

then we can add the simulated AUC of the concentration with the error model's
stochasticity (the `dv` values of one simulation) by utilizing the NCA features
from within the `@observed` block as follows:

```julia
@observed begin
   nca := @nca dv
   sampled_auc = NCA.auc(nca)
end
```

If no `@observed` block is specified, then the results of a simulation will
simply be the derived values and the samples from the error models.

## The PumasModel Function-Based Interface

The `PumasModel` function-based interface for defining an NLME model is the most
expressive mechanism for using Pumas and directly utilizes Julia types and
functions. In fact, under the hood the `@model` DSL works by building an
expression for the `PumasModel` interface! A `PumasModel` has the constructor:

```julia
PumasModel(paramset,random,pre,init,prob,derived,observed=(col,sol,obstimes,samples,subject)->samples)
```

Notice that the `observed` function is optional. This section describes the API
of the functions which make up the `PumasModel` type. The structure closely
follows that of the `@model` macro but is more directly Julia syntax.

### The `paramset` ParamSet

The value `paramset` is a `ParamSet` object which takes in a named tuple of `Domain`
types. These `Domain` types are defined [on the Domains page](). For example,
the following is a value `ParamSet` construction:

```julia
paramset = ParamSet((θ = VectorDomain(4, lower=zeros(4)), # parameters
              Ω = PSDDomain(2),
              Σ = RealDomain(lower=0.0),
              a = ConstDomain(0.2)))
```

### The `random` Function

The `random(param)` function is a function on the parameters. It takes in the
values from the `param` input named tuple and outputs a `ParamSet` for the
random effects. For example:

```julia
function random(p)
    ParamSet((η=MvNormal(p.Ω),))
end
```

is a valid `random` function.

### The `pre` Function

The `pre` function takes in the `param` named tuple, the sampled `randeffs`
named tuple, and the `subject` data and defines the named tuple of the collated
preprocessed dynamical parameters. For example, the following is a valid
definition of the `pre` function:

```julia
function pre(param,randeffs,subject)
    (Σ  = param.Σ,
    Ka = param.θ[1],  # pre
    CL = param.θ[2] * ((subject.covariates.wt/70)^0.75) *
         (param.θ[4]^subject.covariates.sex) * exp(randeffs.η[1]),
    V  = param.θ[3] * exp(randeffs.η[2]))
end
```

The output can be any valid Julia type. Notice that the covariates are
specified via the `subject.covariates` field.

#### Dosing Control Parameters

Special parameters in the return of the `pre` function, such as `lag`, are
used to control the internal event handling (dosing) system. For more
information on these parameters, see the [Dosing Control Parameters]() page.

### The `init` Function

The `init` function defines the initial conditions of the dynamical variables
from the collated preprocessed values `col` and the initial time point `t0`.
Note that this follows the [DifferentialEquations.jl](http://docs.juliadiffeq.org/latest/)
convention, in that the initial value type defines the type for the state used
in the evolution equation.

For example, the following defines the initial condition to be a vector of two
zeros:

```julia
function init(col,t0)
   [0.0,0.0]
end
```

### The `prob` DEProblem

The `prob` is a `DEProblem` defined by [DifferentialEquations.jl](http://docs.juliadiffeq.org/latest/).
It can be any `DEProblem`, and the choice of `DEProblem` specifies the type of
dynamical model. For example, if `prob` is an `SDEProblem`, then the NLME
will be defined via a stochastic differential equation, and if `prob` is a
`DDEProblem`, then the NLME will be defined via a delay differential equation.
For details on defining a `DEProblem`, please
[consult the DifferentialEquations.jl documentation](http://docs.juliadiffeq.org/latest/).

Note that the timespan, initial condition, and parameters are sentinels that
will be overridden in the simulation pipeline. Thus, for example, we can
define `prob` as an `ODEProblem` omitting these values as follows:

```julia
function onecompartment_f(du,u,p,t)
    du[1] = -p.Ka*u[1]
    du[2] =  p.Ka*u[1] - (p.CL/p.V)*u[2]
end
prob = ODEProblem(onecompartment_f,nothing,nothing,nothing)
```

Notice that the parameters of the differential equation `p` is the result value
`pre`.

### The `derived` Function

The `derived` function takes in the collated preprocessed values `col`, the
`DESolution` to the differential equation `sol`, the `obstimes` set during
the simulation and estimation, and the full `subject` data. The output can be
any Julia type on which `map(f,x)` is defined (the `map` is utilized for the
subsequent sampling of the error models). For example, the following is a valid
`derived` function which outputs a named tuple:

```julia
function derived(col,sol,obstimes,subject)
    central = sol(obstimes;idxs=2)
    conc = @. central / col.V
    dv = @. Normal(conc, conc*col.Σ)
    (dv=dv,)
end
```

Note that probability distributions in the output have a special meaning in
maximum likelihood and Bayesian estimation, and are automatically sampled
to become observation values during simulation.

### The `observed` Function

The `observed` function takes in the collated preprocessed values `col`,
the `DESolution` `sol`, the `obstimes`, the sampled derived values `samples`,
and the full `subject` data. The output value is the simulation output. It can
be any Julia type. For example, the following is a valid `observed` function:

```julia
function observed(col,sol,obstimes,samples,subject)
    (obs_cmax = maximum(samples.dv),
     T_max = maximum(obstimes),
     dv = samples.dv)
end
```

Note that if the `observed` function is not given to the `PumasModel` constructor,
the default function `(col,sol,obstimes,samples,subject)->samples` which passes
through the sampled derived values is used.
