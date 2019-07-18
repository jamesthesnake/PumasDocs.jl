# Overview of Pumas

Pumas is a collection of a modules that facilitate workflows related to
data analysis in the pre-clinical and clinical development stages of drug development.
This document provides a general overview of each of these workflows.

## The Pumas NLME Workflow

The core Pumas NLME workflow is:

1. Define a `PumasModel`. This model defines the structure of the NLME model,
   but not necessarily the values.
2. Define a `Subject` and `Population`. These structure specify the dosage
   regimens of the patients, their covariates, and possible observation data
   to fit against. This can be done programmatically or by reading in tabular
   input data.
3. Define a `param` `NamedTuple` for the parameters describing the structure of
   the `PumasModel`. For simulation, these are the parameter values to simulate with.
   For estimation, these are the initial conditions.
4. Call the model API functions (`simobs` and `fit`) to perform the simulations
   and estimation. Both functions act on the pieces defined before.

This workflow directly integrates with usage of the Julia language. For example,
one may define Julia functions and use these functions within the definition
of a `PumasModel`. Additionally, one may write loops that defines `Subject`s
or new random `param`s and use these in simulations via `simobs`. Thus Pumas
gives the core tools for handling NLME models but is a lean system that allows
the user to seamlessly utilize the larger Julia ecosystem to solve their problem.

After fits and simulations are performed, the returned objects have smart defaults
that allow for inspection. Each returned object has a `DataFrame` overload so
that `DataFrame(ret)` displays the simulation or estimation as tabular data.
Additionally, each returned object has a `plot` overload so that

```julia
using Plots
plot(ret)
```

gives a standardized plot (with options) of the simulation or estimation. All of
the internal values are accessible and the fields are documented within the
manual.

## The Pumas NCA Module Workflow

The NCA submodule works by:

1. Defining an `NCASubject` or `NCAPopulation`, either programmatically or by
   reading tabular data in the `PumasNCADF` format.
2. Running NCA functions on the subject or population, such as `NCA.auc`, or
   generating a full `NCA.report`.

Each of the NCA data objects have smart defaults that allow for inspection.
Each of them has a `plot` overload so that:

```julia
using Plots
plot(nca)
```

gives a standardized plot (with options) of the NCA data.
