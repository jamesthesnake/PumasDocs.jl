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
