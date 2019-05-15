# Bioequivalence

# API

```@docs
BioequivalenceStudy
generate_design
read_be
```

# Setup

Install any package not currently installed through `using Pkg; Pkg.add("PkgName")`.

```@example Main
using CSV, DataFrames, StatsBase, Bioequivalence
```

# Designs

## Nonparametric

Nonparametric designs are included for analysis of endpoints such as Tmax.

```@example Main
PJ31 = CSV.read(string(dirname(pathof(Bioequivalence)),
                       "/../data/Nonparametric/PJ2006_3_1.tsv"))
```

The average bioequivalence analysis can be requested through `BioequivalenceStudy`

```@example Main
Tmax = BioequivalenceStudy(PJ31, :Tmax)
```

Nonparametric analysis uses the Wilcoxon signed rank test.

```@example Main
Tmax.model
```

Other endpoints can potentially be analyzed through a nonparametric method as well

```@example Main
PJ46 = CSV.read(string(dirname(pathof(Bioequivalence)),
                       "/../data/Williams/PJ2006_4_6.tsv"))
```

```@example Main
NP = BioequivalenceStudy(PJ46, nonparametric = true)
```

## Parallel

Consider a parallel design dataset with balance between treatment groups such as Clayton and Leslie ([1981](https://doi.org/10.1177/030006058100900608)).

```@example Main
ClaytonandLeslie1981 = CSV.read(string(dirname(pathof(Bioequivalence)),
                                       "/../data/Parallel/FSL2015_1.tsv"))
```

The bioequivalence analysis can be requested through `BioequivalenceStudy`

```@example Main
# notice it defaults to the AUC endpoint
Parallel = BioequivalenceStudy(ClaytonandLeslie1981)
```

The output shows the design, statistical model, and result.

One can access the statistical model directly through

```@example Main
Parallel.model
```

The results can be accessed through

```@example Main
Parallel.result
```

or calling `coeftable` on the object

```@example Main
coeftable(Parallel)
```

Notice that the results are validated with those reported in Fuglsang, Schütz, and Labes ([2015](https://doi.org/10.1208/s12248-014-9704-6)). The Geometric Means Ratio (GMR) has a point estimate of (48.58) and a 90% confidence interval of (26.78, 88.14). These are the values reported in the study obtained with various statistical packages with the Welch correction.

## Crossover

The most common bioequivalence design is perhaps the 2x2 crossover (RT|TR). Consider a dataset from Schütz, Labes, and Fuglsang ([2014](https://doi.org/10.1208/s12248-014-9661-0)) which has been simulated with an extreme range in raw data, outliers, and imbalance between sequences and a large number of subjects.

```@example Main
SLF2014 = CSV.read(string(dirname(pathof(Bioequivalence)),
                          "/../data/2S2P/SLF2014_8.tsv"))
```

The bioequivalence analysis can be requested through `BioequivalenceStudy`

```@example Main
# notice it defaults to the AUC endpoint
Crossover = BioequivalenceStudy(SLF2014)
```

As with other designs one can access the specific elements of the models use in the analysis.

```@example Main
loglikelihood(Crossover.model.model)
```

The results are obtained through,

```@example Main
Crossover.result
```

Crossover 2x2 designs are validated with Schütz, Labes, and Fuglsang ([2014](https://doi.org/10.1208/s12248-014-9661-0)) and Patterson and Jones (2006). In this example, the estimate for the GMR is (93.42) with a 90% confidence interval of (86.81, 100.55).

## Balaam

The Balaam design (RR|RT|TR|TT) is explored with a dataset from Chow and Liu (2009).

```@example Main
ChowandLiu2009 = CSV.read(string(dirname(pathof(Bioequivalence)),
                                 "/../data/Balaam/CL2009_9_2_1.tsv"))
```

The data has the same specification as other crossover studies.

The analysis follows similarly as well.

```@example Main
# notice it defaults to the AUC endpoint
Balaam = BioequivalenceStudy(ChowandLiu2009)
```

!!! note
    Designs with repeated measures include rescaled parameter estimates and variance analysis.

We can also obtain the results for the assess the intra-subject variabilities through

```@example Main
Balaam.model.σ
```

## Dual

Consider the example 4.1 in Patterson and Jones (2006)

```@example Main
PJ41 = CSV.read(string(dirname(pathof(Bioequivalence)),
                       "/../data/Dual/PJ2006_4_1.tsv"))
```

```@example Main
Dual = BioequivalenceStudy(PJ41, :Cmax)
```

## 2S4P Designs

For 2S4P designs both RRTT|TTRR and RTRT|TRTR are supported

```@example Main
PJ43 = CSV.read(string(dirname(pathof(Bioequivalence)),
                       "/../data/2S4P/PJ2006_4_3.tsv"))
```

```@example Main
Inner = BioequivalenceStudy(PJ43)
```

```@example Main
PJ44 = CSV.read(string(dirname(pathof(Bioequivalence)),
                       "/../data/2S4P/PJ2006_4_4.tsv"))
```

```@example Main
Outer = BioequivalenceStudy(PJ44, :Cmax)
```

## Williams

Consider a 3 formulations Williams design

```@example Main
PJ45 = CSV.read(string(dirname(pathof(Bioequivalence)),
                       "/../data/Williams/PJ2006_4_5.tsv"))
```

```@example Main
W3F = BioequivalenceStudy(PJ45)
```

Imagine for a moment that the reference formulation is actually S instead of R.
One can pass such a parameter as following.

```@example Main
W3F = BioequivalenceStudy(PJ45, reference = 'S')
```

Williams designs for four formulations are available as well

```@example Main
PJ46 = CSV.read(string(dirname(pathof(Bioequivalence)),
                       "/../data/Williams/PJ2006_4_6.tsv"))
```

```@example Main
W4F = BioequivalenceStudy(PJ46)
```

# References

Chow, Shein-Chung, and Jen-pei Liu. 2009. Design and Analysis of Bioavailability and Bioequivalence Studies. 3rd ed. Chapman & Hall/CRC Biostatistics Series 27. Boca Raton: CRC Press.

Clayton, D, and A Leslie. 1981. “The Bioavailability of Erythromycin Stearate versus Enteric-Coated Erythromycin Base When Taken Immediately before and after Food.” Journal of International Medical Research 9 (6): 470–77. [DOI:10.1177/030006058100900608](https://doi.org/10.1177/030006058100900608).

Fuglsang, Anders, Helmut Schütz, and Detlew Labes. 2015. "Reference Datasets for Bioequivalence Trials in a Two-Group Parallel Design." The AAPS Journal 17 (2): 400–404. [DOI:10.1208/s12248-014-9704-6](https://doi.org/10.1208/s12248-014-9704-6).

Patterson, Scott D, and Byron Jones. 2006. Bioequivalence and Statistics in Clinical Pharmacology. Boca Raton: Chapman & Hall/CRC. ISBN: 9781420034936.

Schütz, Helmut, Detlew Labes, and Anders Fuglsang. 2014. "Reference Datasets for 2-Treatment, 2-Sequence, 2-Period Bioequivalence Studies." The AAPS Journal 16 (6): 1292–97. [DOI:10.1208/s12248-014-9661-0](https://doi.org/10.1208/s12248-014-9661-0).
