module EmpiricalCDFs
import Statistics
import Printf

"""
    module EmpiricalCDFs

Build and use empirical cumulative distribution functions.

Types/constructors: `AbstractEmpiricalCDF`, `EmpiricalCDF`, `EmpiricalCDFHi`

Functions/methods: Many of the methods defined for `AbstractEmpiricalCDF` are forwarded to the underlying
array.

`length`, `sort!`, `issorted`,
 `empty!`, `mean`, `median`, `middle`, `minimum`, `maximum`, `extrema`,
 `std`, `stdm`, `var`, `varm`, `quantile`

The statistical methods extend functions in `Statistics`. One way to use them with
`EmpiricalCDFs` is `using Statistics`.
"""
EmpiricalCDFs

# cdfs.jl
export AbstractEmpiricalCDF, EmpiricalCDF, EmpiricalCDFHi,  linprint, logprint,
       getinverse, getcdfindex, data, counts
export finv

# We probably do not want to import or use these in the package. Let the user do it.
#export mle, KSstatistic, mleKS, scanmle

# io.jl
# export CDFfile, save, readcdf, readcdfinfo, header, version, getcdf, data

include("cdfs.jl")

include("IOcdf.jl")
using .IOcdf

end # module
