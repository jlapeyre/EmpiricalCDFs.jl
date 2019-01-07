module IOcdf

"""
    module EmpiricalCDFS.IOcdf

Binary IO functions for `EmpiricalCDFs`.

Types: `CDFfile`

Functions: `save`, `save`, `readcdf`, `readcdfinfo`, `header`, `version`, `getcdf`, `data`

`CDFfile` contains an `AbstractEmpiricalCDF` as a field. Many functions on the latter are forwarded to
the former.
"""
IOcdf

export CDFfile, save, readcdf, readcdfinfo, header, version, getcdf, data

import Statistics
using ..EmpiricalCDFs: AbstractEmpiricalCDF, EmpiricalCDF, EmpiricalCDFHi

import ..EmpiricalCDFs: data, linprint, logprint, getindex, getcdfindex, counts

include("readstring.jl")

#### CDFfile type

@enum CDFTYPE EmpiricalCDFtype=1 EmpiricalCDFHitype=2

const CDFfileVersion = v"0.0.2"

"""
    CDFfile(cdf::AbstractEmpiricalCDF, header="")

    struct CDFfile{T <: AbstractEmpiricalCDF}
        cdf::T
        header::String
    end

Binary data file for `AbstractEmpiricalCDF`

The file format is

- Identifying string
- `n::Int64` number of bytes in the header string
- `s::String` The header string
- `t::Int64` Type of `AbstractEmpiricalCDF`, 1 or 2. 1 for `EmpiricalCDF`, 2 for `EmpiricalCDFHi`.
- `lowreject::Float64` the lower cutoff, only for `EmpiricalCDFHi`.
- `npts::Int64` number of data points in the CDF
- `npts` data points of type `Float64`
"""
struct CDFfile{T <: AbstractEmpiricalCDF}
    cdf::T
    header::String
    vn::VersionNumber
end

CDFfile(cdf) = CDFfile(cdf,"",CDFfileVersion)

data(cdff::CDFfile) = data(cdff.cdf)

function Base.show(io::IO, cdff::CDFfile)
    print(io, string(typeof(cdff)), "(")
    show(io,cdff.cdf)
    print(io, ",")
    print(io, "v", cdff.vn)
    print(io, ")")
    nothing
end

"""
    header::String = header(cdff::CDFfile)

Return the header from `cdff`.
"""
header(cdff::CDFfile) = cdff.header

"""
    cdf::AbstractEmpiricalCDF = getcdf(cdff::CDFfile)

Return the CDF from `cdff`.
"""
getcdf(cdff::CDFfile) = cdff.cdf

"""
    version(cdff::CDFfile)

Return the version number of the file format.
"""
version(cdff::CDFfile) = cdff.vn

for f in (:sort!, :push!, :append!, :getindex, :length, :size, :firstindex, :lastindex, :rand, :minimum, :maximum)
    @eval Base.$(f)(cdff::CDFfile, args...) = $(f)(cdff.cdf, args...)
end

for f in (:mean, :std, :quantile )
    @eval Statistics.$(f)(cdff::CDFfile, args...) = $(f)(cdff.cdf, args...)
end

for f in (:getcdfindex, :counts)
#           :mle, :KSstatistic, :mleKS, :scanmle)
    @eval $(f)(cdff::CDFfile, args...) = $(f)(cdff.cdf, args...)
end

for f in (:linprint, :logprint )
    @eval $(f)(ioorfile, cdff::CDFfile, args...) = $(f)(ioorfile, cdff.cdf, args...)
end

(cdff::CDFfile)(x::Real) = getcdf(cdff)(x)
(cdff::CDFfile)(v::AbstractArray) = getcdf(cdff)(v)

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
        error("Failed reading identifying string and version number from CDFfile")
    end
    (filetype,versionstring) = split(s)
    if filetype != "CDFfile"
        error("Failed reading version number from CDFfile")
    end
    local vn
    try
        vn = VersionNumber(versionstring)
    catch
        error("Unable to parse version number string '$versionstring'")
    end
    vn
end

#### Writing CDFfile and CDF

function save(io::IO,cdff::CDFfile)
    write(io, make_CDFfile_version_string())
    write(io,sizeof(cdff.header))
    write(io,cdff.header)
    save(io,cdff.cdf)
end

function save(io::IO,cdf::EmpiricalCDF)
    write(io, convert(Int64,EmpiricalCDFtype))
    _writedata(io,cdf)
end

function save(io::IO,cdf::EmpiricalCDFHi)
    write(io, convert(Int64,EmpiricalCDFHitype))
    write(io,convert(Float64,cdf.lowreject))
    _writedata(io,cdf)
end

function _writedata(io::IO,cdf::AbstractEmpiricalCDF)
    write(io,convert(Int64,length(cdf)))
    for x in cdf.xdata
        write(io,x)
    end
end

"""
    save(fn::String, cdf::AbstractEmpiricalCDF, header::String="")

write `cdf` to file `fn` in a fast binary format.
"""
function save(fn::String, cdf::AbstractEmpiricalCDF, header::String="")
    io = open(fn,"w")
    save(io, CDFfile(cdf,header,CDFfileVersion))
    close(io)
end

#save(fn::String, cdf::AbstractEmpiricalCDF) = save(fn,cdf,"")

#### Reading CDFfile and CDF

function readcdfdata(io::IO, cdf::AbstractEmpiricalCDF)
    npts = read(io,Int64)
    resize!(cdf.xdata,npts)
@inbounds for i in 1:npts
        x = read(io,Float64)
        cdf.xdata[i] = x
    end
end

function readcdf(io::IO)
    info = readcdfinfo(io)
    (vn,header) = (info.vn,info.header)
    cdf = typeof(info) == CDFInfo ?  EmpiricalCDF() : EmpiricalCDFHi(info.lowreject)
    readcdfdata(io,cdf)
    CDFfile(cdf,header,vn)
end

struct CDFInfo
    vn::VersionNumber
    header::String
    npts::Int
end

function Base.show(io::IO, i::CDFInfo)
    print(io,typeof(i),"(")
    print(io,"length(header)=", length(i.header))
    print(io,",vn=v", i.vn)
    print(io,",npts=",i.npts,")")
end

struct CDFHiInfo
    vn::VersionNumber
    header::String
    npts::Int
    lowreject::Float64
end

function Base.show(io::IO, i::CDFHiInfo)
    print(io,typeof(i),"(")
    print(io,"length(header)=", length(i.header))
    print(io,",vn=v", i.vn)
    print(io,",npts=",i.npts)
    print(io,",lowreject=",i.lowreject,")")
end

function readcdfinfo(io::IO)
    vn = read_CDFfile_version_string(io)
    header = readlengthandstring(io)
    cdftype = CDFTYPE(read(io,Int64))
    local lowreject
    if cdftype == EmpiricalCDFtype
        npts = peektype(io,Int64)
        CDFInfo(vn,header,npts)
    elseif cdftype == EmpiricalCDFHitype
        lowreject = read(io,Float64)
        npts = peektype(io,Int64)
        CDFHiInfo(vn,header,npts,lowreject)
    else
        error("Uknown cdf type ", cdftype)
    end
end

"""
    readcdfinfo(fn::String)

Return an object containing information about the cdf saved in the binary
file `fn`. The data itself is not read.
"""
function readcdfinfo(fn::String)
    io = open(fn,"r")
    info = readcdfinfo(io)
    close(io)
    info
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

end # module IO
