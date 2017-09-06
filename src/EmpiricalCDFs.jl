VERSION >= v"0.4.0-dev+6521" && __precompile__()
module EmpiricalCDFs
import Compat.String
#using MLEPower  No, let the user do this

# cdfs.jl
export AbstractEmpiricalCDF, EmpiricalCDF, EmpiricalCDFHi,  linprint, logprint, getinverse, getcdfindex, data, counts

# We probably do not want to import or use these in the package. Let the user do it.
#export mle, KSstatistic, mleKS, scanmle

# io.jl
export CDFfile, save, readcdf, readcdfinfo, header, version, getcdf, data

include("cdfs.jl")
include("io.jl")

end # module
