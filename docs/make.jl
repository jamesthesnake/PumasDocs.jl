using Documenter,PuMaS

makedocs(modules=[PuMaS],
         doctest=false, clean=true,
         format =:html,
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
           "basics/dosage_regimens.md",
           "basics/simulation.md",
           "basics/estimation.md",
           "basics/nca.md",
         ],
         ])

deploydocs(
   repo = "github.com/UMCTM/PuMaSDocs.jl.git",
   target = "build",
   osname = "linux",
   julia = "1.1",
   deps = nothing,
   make = nothing)
