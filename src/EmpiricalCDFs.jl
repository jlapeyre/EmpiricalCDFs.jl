__precompile__()
module EmpiricalCDFs
import Statistics
import Printf

# cdfs.jl
export AbstractEmpiricalCDF, EmpiricalCDF, EmpiricalCDFHi,  linprint, logprint,
    getinverse, getcdfindex, data, counts
export finv

# We probably do not want to import or use these in the package. Let the user do it.
#export mle, KSstatistic, mleKS, scanmle

# io.jl
export CDFfile, save, readcdf, readcdfinfo, header, version, getcdf, data

include("cdfs.jl")
include("io.jl")

end # module
