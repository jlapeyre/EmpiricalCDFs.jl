# EmpiricalCDFs.jl

*Empirical cumulative distribution functions*

[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://jlapeyre.github.io/EmpiricalCDFs.jl/latest)
Linux, OSX: [![Build Status](https://travis-ci.org/jlapeyre/EmpiricalCDFs.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/EmpiricalCDFs.jl)
&nbsp;
Windows: [![Build Status](https://ci.appveyor.com/api/projects/status/github/jlapeyre/EmpiricalCDFs.jl?branch=master&svg=true)](https://ci.appveyor.com/project/jlapeyre/empiricalcdfs-jl)
&nbsp; &nbsp; &nbsp;
[![Coverage Status](https://coveralls.io/repos/jlapeyre/EmpiricalCDFs.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jlapeyre/EmpiricalCDFs.jl?branch=master)
[![codecov.io](http://codecov.io/github/jlapeyre/EmpiricalCDFs.jl/coverage.svg?branch=master)](http://codecov.io/github/jlapeyre/EmpiricalCDFs.jl?branch=master)

Provides [empirical cumulative distribution functions (CDFs)](https://en.wikipedia.org/wiki/Empirical_distribution_function)
(or "empirical distribution functions" as they are know to probabalists).

See the documentation [https://jlapeyre.github.io/EmpiricalCDFs.jl/latest](https://jlapeyre.github.io/EmpiricalCDFs.jl/latest).

I'm surprised that this module is not more popular (if stars are a good measure) because it's rather generic,
I use it frequently for new projects,
and the functionality is not available elsewhere.

*EmpiricalCDFs* implements empirical CDFs; building, evaluating, random sampling, evaluating the inverse, etc.
It is useful especially for examining the
tail of the CDF obtained from streaming a large number of data, more than can be stored in memory.
For this purpose, you specify a lower cutoff; data points below this value will be silently rejected, but the
resulting CDF will still be properly normalized. This ability to process and filter data [online](https://en.wikipedia.org/wiki/Online_algorithm)
is absent in `StatsBase.ecdf`.

<!-- LocalWords:  EmpiricalCDFs jl OSX codecov io CDFs probabalists CDF eg -->
<!-- LocalWords:  julia cdf EmpiricalCDF xmin logprint linprint getinverse -->
<!-- LocalWords:  quantile CDFfile AbstractEmpiricalCDF readcdf mle mleKS -->
<!-- LocalWords:  scanmle KSstatistic AbstractArrays ecdf StatsBase -->
