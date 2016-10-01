# EmpiricalCDFs

Create and print empirical cummulative distribution functions (CDFs)

```julia
 cdf = EmpiricalCDF()
 push!(cdf,x)
 ...
 print(ostr,cdf)

 cdf = EmpiricalCDF(xmin) # reject points `x < xmin` to save memory.
```

`push!(cdf,x)` add a datum to the cdf.

`append!(cdf,a)` append data to the cdf.

`sort!(cdf)` The data must be sorted before calling `cdf[x]`

`cdf[x]` return the value of `cdf` at the point `x`

`logprint(ostr,cdf)` or `print(ostr,cdf)` print the cdf.
By default `2000` log spaced points of `cdf` are printed. Six fields are printed for each coordinate `x`:
`log10(x)`, `log10(1-cdf_val)`, `log10(cdf_val)`, `x`, `cdf_val`, `1-cdf_val`.

`linprint(ostr,cdf)` prints linearly spaced points.

`rand(cdf)`  return a sample from the probability distribution associated with `cdf`.

`getinverse(cdf::EmpiricalCDF,x)` return the value of the functional inverse of `cdf` at the point `x`.

Other methods that call a method of the same function on the data are `length`, `minimum`, `maximum`, `mean`, `std`,
  `quantile`.

See the doc strings for more information.

[![Build Status](https://travis-ci.org/jlapeyre/EmpiricalCDFs.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/EmpiricalCDFs.jl)

#[![Coverage Status](https://coveralls.io/repos/jlapeyre/EmpiricalCDFs.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jlapeyre/EmpiricalCDFs.jl?branch=master)

#[![codecov.io](http://codecov.io/github/jlapeyre/EmpiricalCDFs.jl/coverage.svg?branch=master)](http://codecov.io/github/jlapeyre/EmpiricalCDFs.jl?branch=master)
