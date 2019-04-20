using Documenter,PuMaS

makedocs(modules=[PuMaS],
         doctest=false, clean=true,
         format =:html,
         sitename="PuMaS.jl",
         authors="Chris Rackauckas, Yingbo Ma, Joga Gobburu, Vijay Ivaturi",
         pages = Any[
         "Home" => "index.md",
         "Tutorials" => Any[
           "tutorials/introduction.md",
         ],
         "Basics" => Any[
           "basics/overview.md",
         ],
         "Analytical Solution Types" => Any[
           "types/discrete_types.md",
         ],
         "Noncompartmental Analysis (NCA)" => Any[
           "nca/overview.md",
         ],
         ])

deploydocs(
   repo = "github.com/UMCTM/PuMaSDocs.jl.git",
   target = "build",
   osname = "linux",
   julia = "1.1",
   deps = nothing,
   make = nothing)
