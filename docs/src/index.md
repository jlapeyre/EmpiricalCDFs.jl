# EmpiricalCDFs

*Empirical cumulative distribution functions*

The source repository is [https://github.com/jlapeyre/EmpiricalCDFs.jl](https://github.com/jlapeyre/EmpiricalCDFs.jl).

Provides [empirical cumulative distribution functions (CDFs)](https://en.wikipedia.org/wiki/Empirical_distribution_function)
(or "empirical distribution functions" as they are know to probabalists).

*EmpiricalCDFs* implements empirical CDFs; building, evaluating, random sampling,
evaluating the inverse, etc.  It is useful especially for examining the tail of the
CDF obtained from streaming a large number of data, more than can be stored in
memory.  For this purpose, you specify a lower cutoff; data points below this value
will be silently rejected, but the resulting CDF will still be properly
normalized. This ability to process and filter data
[online](https://en.wikipedia.org/wiki/Online_algorithm) is absent in
`StatsBase.ecdf`.

```julia
 cdf = EmpiricalCDF()
 append!(cdf, randn(10^5))
 push!(cdf, randn())
 sort!(cdf)

 using Statistics
 mean(cdf)
 std(cdf)

 ...
 print(io,cdf)

# reject points `x < xmin` to use less memory
 cdf = EmpiricalCDF(xmin)
```

### Warning about sorting

Before using the cdf, you must call `sort!(cdf)`. For efficiency data is not sorted as it is inserted.
The exception is `print`, which does sort the cdf before printing.

## Contents

```@contents
```

## Index

```@index
```

## Empirical CDF types

```@docs
AbstractEmpiricalCDF
EmpiricalCDF
EmpiricalCDFHi
```

## Functions

```@docs
push!
append!
sort!
data
counts
rand
finv
```

Methods are defined on `AbstractEmpiricalCDF` for the following functions:
`length`, `minimum`, `maximum`, `extrema`, `mean`, `median`, `std`, `quantile`.

## Text file output

```@docs
print
linprint
logprint
```

## Binary IO

I found available serialization choices to be too slow. So, very simple, very fast, binary
storage and retrieval is provided. By now, or in the future, there will certainly be packages
that provide a sufficient or better replacement.

The type `CDFfile` supports reading and writing `AbstractEmpiricalCDF` objects in binary format. Most functions
that operate on `AbstractEmpiricalCDF` also work with `CDFfile`, with the call being passed to the `cdf` field.

```@docs
EmpiricalCDFs.IOcdf.CDFfile
EmpiricalCDFs.IOcdf.save
EmpiricalCDFs.IOcdf.readcdf
EmpiricalCDFs.IOcdf.readcdfinfo
EmpiricalCDFs.IOcdf.header
EmpiricalCDFs.IOcdf.getcdf
EmpiricalCDFs.IOcdf.version
```

## Comparison with `ecdf`

This package differs from the  [`ecdf` function](https://statsbasejl.readthedocs.io/en/latest/empirical.html#ecdf)
from [`StatsBase.jl`](https://github.com/JuliaStats/StatsBase.jl).

- `ecdf` takes a sorted vector as input and returns a function that looks up the value of the
  CDF. An instance of `EmpiricalCDF`, `cdf`, both stores data, eg via `push!(cdf,x)`, and looks
  up the value of the CDF via `cdf(x)`.
- When computing the CDF at an array of values, `ecdf`, sorts the input and uses an algorithm that scans the
  data. Instead, `EmpiricalCDFs` does a binary search for each element of an input vector. Tests showed that this
  is typically not slower. If the CDF stores a large number of points relative to the size of the input vector,
  the second method, the one used by `EmpiricalCDFs` is faster.
