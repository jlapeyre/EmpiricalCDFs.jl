# EmpiricalCDFs.jl
### Empirical cumulative distribution functions

Linux, OSX: [![Build Status](https://travis-ci.org/jlapeyre/EmpiricalCDFs.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/EmpiricalCDFs.jl)
&nbsp;
Windows: [![Build Status](https://ci.appveyor.com/api/projects/status/github/jlapeyre/EmpiricalCDFs.jl?branch=master&svg=true)](https://ci.appveyor.com/project/jlapeyre/empiricalcdfs-jl)
&nbsp; &nbsp; &nbsp;
[![Coverage Status](https://coveralls.io/repos/jlapeyre/EmpiricalCDFs.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jlapeyre/EmpiricalCDFs.jl?branch=master)
[![codecov.io](http://codecov.io/github/jlapeyre/EmpiricalCDFs.jl/coverage.svg?branch=master)](http://codecov.io/github/jlapeyre/EmpiricalCDFs.jl?branch=master)

Create and print [empirical cumulative distribution functions (CDFs)](https://en.wikipedia.org/wiki/Empirical_distribution_function)
(or "empirical distribution functions" as they are know to probabalists).

The main application of this package has been for building empirical CDFs obtained from
Monte Carlo simulations, in particular for examining the tail. For this purpose, you can
specify a lower cutoff; data points below this value will be silently rejected, but the
resulting CDF will still be properly normalized. This is important when generating more
points, e.g `10^9` or `10^10`, than can be stored in memory.

```julia
 cdf = EmpiricalCDF()
 push!(cdf,x)
 ...
 print(io,cdf)

# reject points `x < xmin` to save memory.
 cdf = EmpiricalCDF(xmin)
```

### Functions

`push!(cdf,x)` add a datum to the cdf.

`append!(cdf,a)` append data to the cdf.

`sort!(cdf)` The data must be sorted before calling `cdf[x]`

`cdf[x]` return the value of `cdf` at the point `x`.

`logprint(io,cdf)` or `print(io,cdf)` print the cdf.
By default `2000` log-spaced points of `cdf` are printed, unless any samples are `< = 0`, in which case
they are linearly spaced. Six fields are printed for each coordinate `x`:
`log10(x)`, `log10(1-cdf_val)`, `log10(cdf_val)`, `x`, `cdf_val`, `1-cdf_val`.

`linprint(io,cdf)` print linearly spaced points.

`rand(cdf)`  return a sample from the empirical probability distribution associated with `cdf`.

`getinverse(cdf::EmpiricalCDF,x)` return the value of the functional inverse of `cdf` at the point `x`.

Other methods that call a method of the same function on the data are `length`, `minimum`, `maximum`, `mean`, `std`,
`quantile`.

See the doc strings for more information.

### `CDFfile` and io

The type `CDFfile` supports reading and writing `AbstractEmpiricalCDF` objects in binary format. Most functions
that operate on `AbstractEmpiricalCDF` also work with `CDFfile`, with the call being passed to the `cdf` field.
`saves(fn::String, cdf, header="")` writes a binary file. See documentation for `readcdf`.

### Maximum likelihood estimate of a power law

Functions for estimating the exponent of a power law are provided.
See documentation for the following functions, which are not exported: `mle`, `scanmle`, `mleKS`, `KSstatistic`.
These operate on `AbstractArrays` of data. They are also mapped to types `AbstractEmpiricalCDF`
and `CDFfile`.

### Comparison with `ecdf`

This package differs from the  [`ecdf` function](https://statsbasejl.readthedocs.io/en/latest/empirical.html#ecdf)
from [`StatsBase.jl`](https://github.com/JuliaStats/StatsBase.jl).

- `ecdf` takes a sorted vector as input and returns a function that looks up the value of the
   CDF. An instance of `EmpiricalCDF`, `cdf` both stores data, eg via `push!(cdf,x)`, and looks
up the value of the CDF via `cdf[x]`.
- When computing the CDF at an array of values, `ecdf`, sorts the input and uses and algorithm that scans the
  data. Instead, `EmpiricalCDF` does a binary search for each element of an input vector. Tests showed that this
  is typically not slower. If the CDF stores a large number of points relative to the size of the input vector,
  the second method is faster.

<!-- LocalWords:  EmpiricalCDFs jl OSX codecov io CDFs probabalists CDF eg -->
<!-- LocalWords:  julia cdf EmpiricalCDF xmin logprint linprint getinverse -->
<!-- LocalWords:  quantile CDFfile AbstractEmpiricalCDF readcdf mle mleKS -->
<!-- LocalWords:  scanmle KSstatistic AbstractArrays ecdf StatsBase -->
