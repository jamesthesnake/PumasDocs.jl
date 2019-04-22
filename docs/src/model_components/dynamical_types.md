# Dynamical Problem Types

The dynamical problem types specify the dynamical models that are the nonlinear
transformation of the NLME model. There are two major types of dynamical models:
analytical models and `DEProblem`s. An analytical model is a small differential
equation with an analytical solution. This analytical solution is used by the
solvers to greatly enhance the performance. On the other hand, `DEProblem` is
a specification of a differential equation for numerical solution by
[DifferentialEquations.jl](http://docs.juliadiffeq.org/latest/). This is used
for specifying dynamical equations which do not have an analytical solution,
such as many nonlinear ordinary differential equations (ODEs), or the myriad
of differential equation types supported by DifferentialEquations.jl, such
as delay differential equations (DDEs) and stochastic differential equations
(SDEs).

## Analytical Problems

Analytical problems are a predefined ODE with an analytical solution. While
limited in flexibility, the analytical solutions can be much faster for
simulation and estimation. In the `@model` DSL, an analytical solution
is declared by name. For example:

```julia
@dynamics ImmediateAbsorptionModel
```

declares the use of the `ImmediateAbsorptionModel`. Analytical solutions
have preset names which are used in the internal model. These parameters
must be given values in the `pre` block.

### ImmediateAbsorptionModel

The `ImmediateAbsorptionModel` corresponds to the ODE:

```math
Central' &= -(CL/V)*Central
\end{align}
```

### OneCompartmentModel

The `OneCompartmentModel` corresponds to the ODE:

```math
\begin{align}
Depot'   &= -Ka*Depot
Central' &=  Ka*Depot - (CL/V)*Central
\end{align}
```

### OneCompartmentParallelModel

The `OneCompartmentParallelModel` corresponds to the ODE:

```math
\begin{align}
Depot1'   &= -Ka1*Depot1
Depot2'   &= -Ka2*Depot2
Central'  &=  Ka1*Depot1 + Ka2*Depot2 - (CL/V)*Central
\end{align}
```

## `DEProblem`

`DEProblem`s are types from [DifferentialEquations.jl](http://docs.juliadiffeq.org/latest/)
which are used to specify differential equations to be solved numerically via
the solvers of the package. In the `@model` interface, the `DEProblem` is set
to be an `ODEProblem` defining an ODE. In the function-based interface, any
`DEProblem` can be used, which includes:

- Discrete equations (function maps, discrete stochastic (Gillespie/Markov) simulations)
- Ordinary differential equations (ODEs)
- Split and Partitioned ODEs (Symplectic integrators, IMEX Methods)
- Stochastic ordinary differential equations (SODEs or SDEs)
- Random differential equations (RODEs or RDEs)
- Differential algebraic equations (DAEs)
- Delay differential equations (DDEs)
- Mixed discrete and continuous equations (Hybrid Equations, Jump Diffusions)

The problem type that is given can use sentinel values for the initial condition,
timespan, and parameters which will be overridden by PuMaS during the simulation
chain.
