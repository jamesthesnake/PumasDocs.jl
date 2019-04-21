# Simulation of PuMaS Models

## The `simobs` Function

Simulation of PuMaS models are performed via the `simobs` function. The function
is given by the values:

```julia
simobs(m,data,param,[randeffs];kwargs...)
```

The terms in the function call are:

- `m`: the `PuMaSModel`, either defined via the `@model` DSL or the function-based
  interface.
- `data`: either a `Subject` or a `Population`.
- `param`: a `NamedTuple` of parameters which conform to the `ParamSet` of the
  model.
- `randeffs`: an optional argument for the random effects for the simulation.
  If the random effects are not given, they are sampled as described in the
  model.
- `kwargs`: extra keyword arguments.

Additionally, the following keyword arguments can be used:

- `alg`: the type for which differential
  equation solver method to use. For example, `alg=Rodas5()` specifies the usage
  of the 5th order Rosenbrock method for ODEs described in the
  [DifferentialEquations.jl solver documentation page](http://docs.juliadiffeq.org/latest/solvers/ode_solve.html#Rosenbrock-Methods-1). Defaults to an automatic stiffness
  detection algorithm for ODEs.
- `parallel_type`: the type of parallelism to use internally for simulating
  a `Population`. The options are:
  - `PuMaS.Serial`: No parallelism.
  - `PuMaS.Threads`: Shared memory multithreading.
  - `PuMaS.Distributed`: Distributed (multinode, multi-computer) parallelism.
  The default is `PuMaS.Threads`.
- Any keyword argument in the DifferentialEquations.jl common solver arguments.
  These are documented on the [DifferentialEquations.jl common solver options page](http://docs.juliadiffeq.org/latest/basics/common_solver_opts.html).

The result of `simobs` function is a `SimulatedObservation` if the `data` was
`Subject` and a `SimulatedPopulation` if the `data` was a `Population`.

## Handling Simulated Returns

A `SimulatedObservation` can be accessed via its fields which are:

- `subject`: the `Subject` used to generate the observation
- `times`: the times associated with the observations
- `observed`: the resulting observations of the simulation

If the `@model` DSL is used, then `observed` is a `NamedTuple` where the names
give the associated values. From the function-based interface, `observed` is
the chosen return type of the `observed` function in the model specification.

A `SimulatedPopulation` is a collection of `SimulatedObservation`s, and when
indexed like `sim[i]` it returns the `SimulatedObservation` of the `i`th
simulation subject.

## Visualizing Simulated Returns

These objects have automatic plotting and dataframe visualization. To plot
a simulation return, simply call plot on the output using
[Plots.jl](https://github.com/JuliaPlots/Plots.jl). For example, the following
will run a simulation and plot the observed variabes:

```julia
obs = simobs(m,data,param)
using Plots
plot(obs)
```

All of the [Plots.jl attributes](http://docs.juliaplots.org/latest/attributes/)
can be used on this command. For more information on using Plots.jl, please
see [the Plots.jl tutorial](http://docs.juliaplots.org/latest/tutorial/).
Note that if the simulated return is a `SimulatedPopulation`, then the plots
overly the results of the various subjects.

To generate the DataFrame associated with the observed outputs, simply call
`DataFrame` on the simulated return. For example, the following builds the
tabular output from the returned object:

```julia
obs = simobs(m,data,param)
df = DataFrame(obs)
```
