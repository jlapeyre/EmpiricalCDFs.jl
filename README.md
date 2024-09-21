[![Build Status](https://github.com/jlapeyre/EmpiricalCDFs.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jlapeyre/EmpiricalCDFs.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/jlapeyre/EmpiricalCDFs.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jlapeyre/EmpiricalCDFs.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![JET QA](https://img.shields.io/badge/JET.jl-%E2%9C%88%EF%B8%8F-%23aa4444)](https://github.com/aviatesk/JET.jl)

# EmpiricalCDFs.jl

*Empirical cumulative distribution functions*

Provides [empirical cumulative distribution functions (CDFs)](https://en.wikipedia.org/wiki/Empirical_distribution_function)
(or "empirical distribution functions" as they are know to probabalists).

See the documentation [https://jlapeyre.github.io/EmpiricalCDFs.jl/latest](https://jlapeyre.github.io/EmpiricalCDFs.jl/latest).



*EmpiricalCDFs* implements empirical CDFs; building, evaluating, random sampling, evaluating the inverse, etc.
It is useful especially for examining the
tail of the CDF obtained from streaming a large number of data, more than can be stored in memory.
For this purpose, you specify a lower cutoff; data points below this value will be silently rejected, but the
resulting CDF will still be properly normalized. This ability to process and filter data [online](https://en.wikipedia.org/wiki/Online_algorithm)
is absent in `StatsBase.ecdf`.

~~I'm surprised that this module is not more popular (if stars are a good measure) because it's rather generic,
I use it frequently for new projects,
and the functionality is not available elsewhere.~~ In the meantime it's gained some stars.

<!-- LocalWords:  EmpiricalCDFs jl OSX codecov io CDFs probabalists CDF eg -->
<!-- LocalWords:  julia cdf EmpiricalCDF xmin logprint linprint getinverse -->
<!-- LocalWords:  quantile CDFfile AbstractEmpiricalCDF readcdf mle mleKS -->
<!-- LocalWords:  scanmle KSstatistic AbstractArrays ecdf StatsBase -->
