# EmpiricalCDFs

Create and print empirical cummulative distribution functions (CDFs)


```julia
 cdf = EmpiricalCDF()
 push!(cdf,x)
 ...
 print(ostr,cdf)

 cdf = EmpiricalCDF(n,xmin) # use `n` points when printing and reject points `x < xmin` to save memory.
```

`push!(cdf,x)` adds a datum to the cdf.

`append!(cdf,a)` appends data to the cdf.

`logprint(ostr,cdf)` or `print(ostr,cdf)` prints the cdf.
By default `2000` log spaced points of `cdf` are printed. Six fields are printed for each coordinate `x`:
`log10(x)`, `log10(1-cdf_val)`, `log10(cdf_val)`, `x`, `cdf_val`, `1-cdf_val`.

`linprint(ostr,cdf)` prints linearly spaced points.

See the doc strings for more information.

For general use, an iterator for points in the cdf would be useful. But, this is not implemented.

[![Build Status](https://travis-ci.org/jlapeyre/EmpiricalCDFs.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/EmpiricalCDFs.jl)

#[![Coverage Status](https://coveralls.io/repos/jlapeyre/EmpiricalCDFs.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jlapeyre/EmpiricalCDFs.jl?branch=master)

#[![codecov.io](http://codecov.io/github/jlapeyre/EmpiricalCDFs.jl/coverage.svg?branch=master)](http://codecov.io/github/jlapeyre/EmpiricalCDFs.jl?branch=master)
