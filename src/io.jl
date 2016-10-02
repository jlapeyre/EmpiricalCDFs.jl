include("readstring.jl")

#### CDFfile type

@enum CDFTYPE EmpiricalCDFtype=1 EmpiricalCDFHitype=2

const CDFfileVersion = v"0.0.1"

"""
    CDFfile(cdf::AbstractEmpiricalCDF, header="")

    immutable CDFfile{T <: AbstractEmpiricalCDF}
        cdf::T
        header::String
    end

Binary data file for `AbstractEmpiricalCDF`

The file format is

- Identifying string
- `n::Int` number of bytes in the header string
- `s::String` The header string
- `t::Int` Type of `AbstractEmpiricalCDF`, 1 or 2. 1 for `EmpiricalCDF`, 2 for `EmpiricalCDFHi`.
- `lowreject::Float64` the lower cutoff, only for `EmpiricalCDFHi`.
- `npts::Int` number of data points in the CDF
- `npts` data points of type `Float64`

`write(fn::String, cdf::AbstractEmpiricalCDF, header::String="")` write `cdf` to file `fn` with header `header`.

## Documented functions

`readcdf(fn::String)`
"""
immutable CDFfile{T <: AbstractEmpiricalCDF}
    cdf::T
    header::String
    vn::VersionNumber
end

CDFfile(cdf) = CDFfile(cdf,"",CDFfileVersion)

"""
    header::String = getheader(cdff::CDFfile)

Return the header from `cdff`.
"""
getheader(cdff::CDFfile) = cdff.header

"""
    cdf::AbstractEmpiricalCDF = getcdf(cdff::CDFfile)

Return the CDF from `cdff`.
"""
getcdf(cdff::CDFfile) = cdff.cdf

"""
    getversion(cdff::CDFfile)

Return the version number of the file format.
"""
getversion(cdff::CDFfile) = cdff.vn

for f in ( :sort!, :push!, :append!, :getindex, :length, :rand, :minimum, :maximum, :mean, :std, :quantile )
    @eval Base.$(f)(cdff::CDFfile, args...) = $(f)(cdff.cdf, args...)
end

for f in ( :getinverse, :getcdfindex, :linprint, :logprint,
           :mle, :KSstatistic, :mleKS, :scanmle)
    @eval $(f)(cdff::CDFfile, args...) = $(f)(cdff.cdf, args...)
end

####

function make_CDFfile_version_string(v)
    nchars = 100
    s = "CDFfile " * string(v)
    s = s * " "^(nchars-length(s))
end

make_CDFfile_version_string() = make_CDFfile_version_string(CDFfileVersion)

function read_CDFfile_version_string(io::IO)
    nchars = 100
    local s
    try
        s = readstring(io,nchars)
    catch
        error("Failed reading version number from CDFfile")
    end
    (filetype,versionstring) = split(s)
    if filetype != "CDFfile"
        error("Failed reading version number from CDFfile")
    end
    local vn
    try
        vn = convert(VersionNumber, versionstring)
    catch
        error("Unable to parses version number string '$versionstring'")
    end
    vn
end

#### Writing CDFfile and CDF

function Base.write(io::IO,cdff::CDFfile)
    write(io, make_CDFfile_version_string())
    write(io,sizeof(cdff.header))
    write(io,cdff.header)
    write(io,cdff.cdf)
end

function Base.write(io::IO,cdf::EmpiricalCDF)
    write(io, convert(Int,EmpiricalCDFtype))
    _writedata(io,cdf)
end

function Base.write(io::IO,cdf::EmpiricalCDFHi)
    write(io, convert(Int,EmpiricalCDFHitype))
    write(io,convert(Float64,cdf.lowreject))
    _writedata(io,cdf)
end

function _writedata(io::IO,cdf::AbstractEmpiricalCDF)
    write(io,convert(Int,length(cdf)))
    for x in cdf.xdata
        write(io,x)
    end
end

function Base.write(fn::String, cdf::AbstractEmpiricalCDF, header::String)
    io = open(fn,"w")
    write(io, CDFfile(cdf,header,CDFfileVersion))
    close(io)
end

Base.write(fn::String, cdf::AbstractEmpiricalCDF) = write(fn,cdf,"")

#### Reading CDFfile and CDF

function readcdfdata(io::IO, cdf::AbstractEmpiricalCDF)
    npts = read(io,Int)
    resize!(cdf.xdata,npts)
    for i in 1:npts
        x = read(io,Float64)
        cdf.xdata[i] = x
    end
end

function readcdf(io::IO)
    vn = read_CDFfile_version_string(io)
    header = readlengthandstring(io)
    cdftype = convert(CDFTYPE,read(io,Int))
    local cdf
    if cdftype == EmpiricalCDFtype
        cdf = EmpiricalCDF()
    elseif cdftype == EmpiricalCDFHitype
        lowreject = read(io,Float64)
        cdf = EmpiricalCDFHi(lowreject)
    else
        error("Uknown cdf type ", cdftype)
    end
    readcdfdata(io,cdf)
    CDFfile(cdf,header,vn)
end

"""
    readcdf(fn::String)

Read an empirical CDF from file `fn`. Return an object
`cdff` of type `CDFfile`. The header is in field `header`.
The cdf is in in field `cdf`.
"""
function readcdf(fn::String)
    io = open(fn,"r")
    cdffile = readcdf(io)
    close(io)
    cdffile
end
