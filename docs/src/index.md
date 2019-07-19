# Pumas

Pumas (PharmaceUtical  Modeling And Simulation) is a suite of tools for
developing, simulating, fitting, and analyzing pharmaceutical models. The
purpose of this framework is to bring efficient implementations of all aspects
of pharmaceutical modeling under one cohesive package. **While Pumas is still
in alpha**, the package currently includes:

- Specification of Nonlinear Mixed Effects (NLME) Models
- Automatic parallelization of NLME simulations
- Deep control over the differential equation solvers for high efficiency
- Estimation of NLME parameters via Maximum Likelihood and Bayesian methods
- Integrated Noncompartmental Analysis (NCA)
- Interfacing with global optimizers for more accurate parameter estimates
- Simulation and estimation diagnostics
- Bioequivalence analysis

Additional features are under development, with the central goal being a
complete clinical trial simulation engine which combines efficiency with a
standardized workflow, consistent nomenclature, and automated report generation.
All of this takes place in the high level interactive Julia programming language
and integrates with the other packages in the Julia ecosystem for a robust
user experience.

## License

Pumas is covered by the [Julia Computing EULA](). There are four available
licenses:

(a) FREE LICENSE: If you obtained the Software pursuant to a free download or
    are using the Software pursuant to free online usage, you may use the
    Software as per terms and conditions specified in clause 1. above; provided,
    however, that in all events, Pumas.jl, Miletus.jl, JuliaInXL.jl and
    Bplapi.jl, may be used only for Non-Commercial Purposes (as defined below).
    "Non-Commercial Purposes" means the use of the Software for non-commercial
    academic teaching and research purposes or other non-commercial not-for
    profit scholarly purposes, where " non-commercial" means not involving the
    use of the Software to perform services for a fee or for the production or
    manufacture of software programs for sale or distribution to third parties.
(b) EVALUATION LICENSE: If You obtained the Software pursuant to an evaluation
    license, you may use the Software only for internal evaluation purposes and
    only for the term of the evaluation period, as specified on Julia Computing
    download website or in the documentation related to the distribution.
    NOTWITHSTANDING ANYTHING TO THE CONTRARY ELSEWHERE IN THIS AGREEMENT, YOU
    MAY USE THE SOFTWARE ONLY FOR EVALUATION PURPOSES AND ONLY FOR THE TERM OF
    THE EVALUATION, YOU MAY NOT DISTRIBUTE ANY PORTION OF THE SOFTWARE, AND THE
    APPLICATION AND/OR PRODUCT DEVELOPED BY YOU MAY ONLY BE USED FOR EVALUATION
    PURPOSES AND ONLY FOR THE TERM OF THE EVALUATION. You may install copies of
    the Software on a reasonable number of computers to conduct your evaluation
    provided that you are the only individual using the Software and only one
    copy of the Software is in use at any one time.
(c) EDU LICENSE. If You obtained the Software pursuant to an EDU license, you
    may use the Software only for educational and teaching purposes, as
    specified on Julia Computing download website or in the documentation
    related to the distribution. NOTWITHSTANDING ANYTHING TO THE CONTRARY
    ELSEWHERE IN THIS AGREEMENT, YOU MAY USE THE SOFTWARE ONLY FOR EDUCATIONAL
    PURPOSES, YOU MAY NOT DISTRIBUTE ANY PORTION OF THE SOFTWARE, AND THE
    APPLICATION AND/OR PRODUCT DEVELOPED BY YOU MAY ONLY BE USED FOR EDUCATIONAL
    PURPOSES.
(d) COMMERCIAL LICENSE WITH SUPPORT: If you obtained the Software pursuant to a
    separate Julia Computing License Agreement that includes a commercial
    license and support services, you may use the Software as per terms and
    conditions specified in the applicable Julia Computing License Agreement
    and if no terms are specified in the Julia Computing License Agreement,
    then subject to the terms of Section 6(a) above. Any support services shall
    be provided as set forth herein and pursuant to the terms of the Julia
    Computing License Agreement.

## Getting Started: Installation and First Steps

Pumas is distributed via JuliaPro from Julia Computing Inc. Please
[install the current stable release of JuliaPro](https://juliacomputing.com/products/juliapro.html).

To add the `Pumas` package, use the following commands inside the JuliaPro REPL:

```julia
using Pkg
Pkg.add("Pumas")
```

To verify that the package has been correctly installed, you can run the command
`Pkg.test("Pumas")` which will run an internal verification suite to ensure
accuracy. When installed, use the command:

```julia
using Pumas
```

to bring the functionality of Pumas into your REPL. Once done, you are ready
to start using Pumas!

To start understanding the package in more detail, please checkout the tutorials
at the start of this manual. **We highly suggest that all new users start with
the Introduction to Pumas tutorial!** If you find any example where there seems
to be an error, please open an issue.

For the most up to date information on using the package, please join the Slack channel.

### Jupyter Notebook Tutorials

Extra tutorials are provided with the installation of Pumas. These tutorials
are delivered in an interactive Jupyter notebook that allows you to follow
along and tweak values to gain a better understanding. To install these
tutorials and open the Jupyter notebooks in the browser, run the following
commands:

```julia
using Pkg
pkg"add https://github.com/UMCTM/PumasTutorials.jl"
using PumasTutorials
PumasTutorials.open_notebooks()
```

## Annotated Table Of Contents

Below is an annotated table of contents with summaries to help guide you to the
appropriate page. The materials shown here are links to the same materials
in the sidebar. Additionally, you may use the search bar provided on the left
to directly find the manual pages with the appropriate terms.

### Tutorials

These tutorials give an "example first" approach to learning Pumas and establish
the standardized nomenclature for the package. Additionally, ways of interfacing
with the rest of the Julia ecosystem for visualization and statistics are
demonstrated. Thus we highly recommend new users check out these tutorials
before continuing into the manual. More tutorials can be found in the
PumasTutorials.jl repository.

```@contents
Pages = [
    "tutorials/introduction.md",
]
```

### Basics

The basics are the core principles of using Pumas. An overview introduces the
user to the basic design tenants, and manual pages proceed to give details on
the central functions and types used throughout Pumas.

```@contents
Pages = [
    "basics/overview.md",
    "basics/models.md",
    "basics/doses_subjects_populations.md",
    "basics/simulation.md",
    "basics/estimation.md",
    "basics/nca.md",
    "basics/faq.md",
]
```

### Model Components

This section of the documentation goes into more detail on the model components,
specifying the possible domain types, dosage control parameters (DCP), and
the various differential equation types for specifying problems with
analytical solutions and alternative differential equations such as delay
differential equations (DDEs), stochastic differential equations (SDEs), etc.

```@contents
Pages = [
    "model_components/domains.md",
    "model_components/dosing_control.md",
    "model_components/dynamical_types.md",
]
```

### Analysis

This section of the documentation defines the analysis tooling. Essential
tools such as diagnostics, plotting, report generation, and sensitivity
analysis are discussed in detail in this portion.

```@contents
Pages = [
    "analysis/diagnostics.md",
]
```

## Pumas Development Team

The Pumas team is supported by the
[University of Maryland, Baltimore Center for Translational Medicine (CTM)](https://www.pharmacy.umaryland.edu/centers/ctm/).
Vijay Ivaturi is the project lead and Chris Rackauckas is the lead developer.
For information on developing and supporting Pumas, please consult Vijay Ivaturi.
