VERSION >= v"0.4.0-dev+6521" && __precompile__()

module EmpiricalCDFs

import Compat.String

export EmpiricalCDF, EmpiricalCDFHi, CDFfile, linprint, logprint, getinverse, getcdfindex
export getheader, getversion, getcdf

# io.jl
export save, readcdf, readcdfinfo, header, version

include("cdfs.jl")
include("io.jl")
include("mle.jl")

end # module
