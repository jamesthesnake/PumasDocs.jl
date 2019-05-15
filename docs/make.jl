using Documenter#=, PuMaS=#

makedocs(
  modules=Module[#=PuMaS=#],
  doctest=false,
  clean=true,
  format =Documenter.HTML(),
  sitename="PuMaS",
  authors="Chris Rackauckas, Yingbo Ma, Joga Gobburu, Vijay Ivaturi",
  pages = Any[
    "Home" => "index.md",
    "Tutorials" => Any[
      "tutorials/introduction.md",
    ],
    "Basics" => Any[
      "basics/overview.md",
      "basics/models.md",
      "basics/doses_subjects_populations.md",
      "basics/simulation.md",
      "basics/estimation.md",
      "basics/nca.md",
      "basics/faq.md",
    ],
    "Model Components" => Any[
      "model_components/domains.md",
      "model_components/dosing_control.md",
      "model_components/dynamical_types.md",
    ],
    "Diagnostics" => Any[
      "analysis/diagnostics.md",
      "analysis/sensitivity.md",
    ],
    "Bioequivalence" => Any[
      "bioequivalence/introduction.md"
    ],
  ]
)

deploydocs(
   repo = "github.com/UMCTM/PuMaSDocs.jl.git",
)
