module EmpiricalCDFs
import Statistics
import Printf

"""
    module EmpiricalCDFs

Build and use empirical cumulative distribution functions.

Types/constructors: `AbstractEmpiricalCDF`, `EmpiricalCDF`, `EmpiricalCDFHi`

Functions/methods: Many of the methods defined for `AbstractEmpiricalCDF` are forwarded to the underlying
array.

`logprint`, `linprint`,
`length`, `counts`, `sort!`, `issorted`,
`empty!`, `mean`, `median`, `middle`,
`minimum`, `maximum`, `extrema`,
`std`, `stdm`, `var`, `varm`, `quantile`,
`iterate`

The statistical methods extend functions in `Statistics`. One way to use them with
`EmpiricalCDFs` is `using Statistics`.

Binary IO is supported by the submodule `EmpiricalCDFs.IOcdf`.
"""
EmpiricalCDFs

# cdfs.jl
export AbstractEmpiricalCDF, EmpiricalCDF, EmpiricalCDFHi,  linprint, logprint,
       getcdfindex, data, counts
export finv

include("cdfs.jl")

include("IOcdf.jl")
using .IOcdf

end # module
