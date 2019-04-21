# PuMaS

PuMaS (PharmascUtical Modeling And Simulation) is a suite of tools for
developing, simulating, fitting, and analyzing pharmaceutical models. The
purpose of this framework is to bring efficient implementations of all aspects
of pharmaceutical modeling under one cohesive package. **While PuMaS is still
in beta**, the package currently includes:

- Specification of Nonlinear Mixed Effects (NLME) Models
- Automatic parallelization of NLME simulations
- Deep control over the differential equation solvers for high efficiency
- Estimation of NLME parameters via Maximum Likelihood and Bayesian methods
- Integrated Noncompartmental Analysis (NCA)
- Symbolic tooling for automatic calculation of system Jacobians
- Interfacing with global optimizers for more accurate parameter estimates
- Simulation and estimation diagnostics
- Global and local sensitivity analysis (Morris, Sobol, etc.)
- Fisher Information Matrix (FIM) calculations for Optimal Design
- Bioequivalence analysis and IVIVC

Additional features are under development, with the central goal being a
complete clinical trial simulation engine which combines efficiency with a
standardized workflow, consistent nomenclature, and automated report generation.
All of this takes place in the high level interactive Julia programming language
and integrates with the other packages in the Julia ecosystem for a robust
user experience.

### Supporting and Citing

The software in this ecosystem was developed as part of academic research. If
you would like to help support PuMaS, please star the repository as such metrics
may help us secure funding in the future. If you use PuMaS software as part of
your research, teaching, or other activities, we would be grateful if you could
cite our work. Our suggested citation is:

## Getting Started: Installation and First Steps

To install the package, use the following commands inside the Julia REPL:

```julia
using Pkg
Pkg.add("PuMaS")
```

To verify that the package has been correctly installed, you can run the command
`Pkg.test("PuMaS")` which will run an internal verification suite to ensure
accuracy. When installed, use the command:

```julia
using PuMaS
```

to bring the functionality of PuMaS into your REPL. Once done, you are ready
to start using PuMaS!

To start understanding the package in more detail, please checkout the tutorials
at the start of this manual. **We highly suggest that all new users start with
the Introduction to PuMaS tutorial!** If you find any example where there seems
to be an error, please open an issue.

For the most up to date information on using the package, please join the Slack channel.

### Jupyter Notebook Tutorials

Extra tutorials are provided with the installation of PuMaS. These tutorials
are delivered in an interactive Jupyter notebook that allows you to follow
along and tweak values to gain a better understanding. To install these
tutorials and open the Jupyter notebooks in the browser, run the following
commands:

```julia
using Pkg
pkg"add https://github.com/UMCTM/PuMaSTutorials.jl"
using PuMaSTutorials
PuMaSTutorials.open_notebooks()
```

# Annotated Table Of Contents

Below is an annotated table of contents with summaries to help guide you to the
appropriate page. The materials shown here are links to the same materials
in the sidebar. Additionally, you may use the search bar provided on the left
to directly find the manual pages with the appropriate terms.

## Tutorials

These tutorials give an "example first" approach to learning PuMaS and establish
the standardized nomenclature for the package. Additionally, ways of interfacing
with the rest of the Julia ecosystem for visualization and statistics are
demonstrated. Thus we highly recommend new users check out these tutorials
before continuing into the manual. More tutorials can be found in the
PuMaSTutorials.jl repository.

```@contents
Pages = [
    "tutorials/introduction.md",
]
```

## Basics

The basics are the core principles of using PuMaS. An overview introduces the
user to the basic design tenants, and manual pages proceed to give details on
the central functions and types used throughout PuMaS.

```@contents
Pages = [
    "basics/overview.md",
    "basics/models.md",
    "basics/dosage_regimens.md",
    "basics/simulation.md",
    "basics/estimation.md",
    "basics/nca.md",
]
```

## PuMaS Development Team

The PuMaS team is supported by the
[University of Maryland, Baltimore Center for Translational Medicine (CTM)](https://www.pharmacy.umaryland.edu/centers/ctm/).
Vijay Ivaturi is the project lead and Chris Rackauckas is the lead developer.
For information on developing and supporting PuMaS, please consult Vijay Ivaturi.
