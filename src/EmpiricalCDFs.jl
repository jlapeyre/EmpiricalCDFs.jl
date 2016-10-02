module EmpiricalCDFs

import Compat: String

export EmpiricalCDF, EmpiricalCDFHi, CDFfile, linprint, logprint, getinverse, getcdfindex, readcdf
export getheader, getversion, getcdf

include("cdfs.jl")
include("io.jl")
include("mle.jl")

end # module
