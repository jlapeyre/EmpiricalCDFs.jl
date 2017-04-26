"""
    AbstractEmpiricalCDF

Concrete types are `EmpiricalCDF` and `EmpiricalCDFHi`.
"""
abstract AbstractEmpiricalCDF

immutable EmpiricalCDF{T <: Real} <: AbstractEmpiricalCDF
    xdata::Array{T,1}  # death times
end

getdata{T<:AbstractEmpiricalCDF}(cdf::T) = cdf.xdata

# Extend base functions
for f in ( :length, :minimum, :maximum, :mean, :std, :quantile )
    @eval begin
        Base.$(f)(cdf::AbstractEmpiricalCDF,args...) = $(f)(cdf.xdata,args...)
    end
end

# Same as above, but the return value is the cdf
for f in ( :sort!, )
    @eval begin
        Base.$(f)(cdf::AbstractEmpiricalCDF,args...) = ($(f)(cdf.xdata,args...); cdf)
    end
end

getcdfindex(cdf::AbstractEmpiricalCDF, x::Real) = searchsortedlast(cdf.xdata, x)

#Base.getindex(cdf::EmpiricalCDF, x::Real) = searchsortedlast(cdf.xdata, x) / length(cdf.xdata)
Base.getindex(cdf::AbstractEmpiricalCDF, x::Real) = _val_at_index(cdf, getcdfindex(cdf, x))

# With several tests, this is about the same speed or faster than the routine borrowed from StatsBase
function Base.getindex{T <: Real}(cdf::AbstractEmpiricalCDF, v::AbstractArray{T})
    r = Array(eltype(cdf.xdata), size(v)...)
    for (i,x) in enumerate(v)
        r[i] = cdf[x]
    end
    r
end


doc"""
*EmpiricalCDF()*

Return an empirical CDF. The CDF must be sorted after inserting elements with `push!` or
`append!`, and before being accessed using any of the functions below.

`EmpiricalCDF(xmin::Real)`

When using `push!(cdf,x)` and `append!(cdf,a)`, points `x` for `x<xmin` will be rejected.
The CDF will be properly normalized, but will be lower-truncated.
This can be useful when generating too many points to store.

`print(io,cdf)` or `logprint(io,cdf,n=2000)` print (not more than) `n` log spaced points after sorting the data.

`print(io,cdf,a::AbstractArray)`,  `print(cdf,a::AbstractArray, fname::String)`  print cdf at points near those in a.

`push!(cdf,x)`  add a point to `cdf`

`append!(cdf,a)`  add points to `cdf`.

`sort!(cdf)` The data must be sorted before calling `cdf[x]`

`cdf[x::Real]`  return the value of `cdf` at the point `x`.

`cdf[a::AbstractArray]` return the values of `cdf` at the points in `a`.

`length(cdf)`  return the number of data points in `cdf`.

`rand(cdf)`  return a sample from the probability distribution associated with `cdf`.

# Documented functions and objects

`getinverse(cdf,x)`, `linprint(io,cdf,n=2000)`, `logprint(io,cdf,n=2000)`,
`getcdfindex(cdf,x)`
"""
EmpiricalCDF() = EmpiricalCDF(Array(Float64,0))

"""
    EmpiricalCDFHi{T <: Real} <: AbstractEmpiricalCDF

Empirical CDF with lower cutoff. That is, keep only the tail.
"""
immutable EmpiricalCDFHi{T <: Real} <: AbstractEmpiricalCDF
    lowreject::T  # reject counts smaller than this
    rejectcounts::Array{Int,1}  # how many rejections have we done
    xdata::Array{T,1}  # death times
end

function EmpiricalCDFHi(lowreject::Real)
    cdf = EmpiricalCDFHi(lowreject, Array(Int,1), Array(typeof(lowreject),0))
    cdf.rejectcounts[1] = 0
    cdf
end

function EmpiricalCDF(lowreject::Real)
    if isfinite(lowreject)
        EmpiricalCDFHi(lowreject)
    else
        EmpiricalCDF()
    end
end

# Number of points accepted plus number of points rejected
_total_counts(cdf::EmpiricalCDF) = length(cdf.xdata)
_total_counts(cdf::EmpiricalCDFHi) = length(cdf.xdata) + _rejectcounts(cdf)

# Value of the cdf corresponding to index i
_val_at_index(cdf::EmpiricalCDF, i) =  i/_total_counts(cdf)
_val_at_index(cdf::EmpiricalCDFHi, i) =  (i+ _rejectcounts(cdf) )/_total_counts(cdf)

_increment_rejectcounts(cdf::EmpiricalCDFHi) = cdf.rejectcounts[1] += 1

_rejectcounts(cdf::EmpiricalCDFHi) = cdf.rejectcounts[1]


Base.push!(cdf::EmpiricalCDF,x) = (push!(cdf.xdata,x) ; cdf)

function _push!(cdf::EmpiricalCDFHi,x)
    if  x >= cdf.lowreject
        push!(cdf.xdata,x)
    else
        _increment_rejectcounts(cdf)
    end
end

function Base.push!(cdf::EmpiricalCDFHi, x)
    if isinf(cdf.lowreject)
        push!(cdf.xdata,x)
    else
        _push!(cdf,x)
    end
    cdf
end

Base.append!(cdf::EmpiricalCDF, times) =  (append!(cdf.xdata,times); cdf)

function Base.append!(cdf::EmpiricalCDFHi, times)
    if  isinf(cdf.lowreject)
        append!(cdf.xdata,times)
    else
        for x in times
            _push!(cdf,x)
        end
    end
    cdf
end


# Let the user do this by hand
# for f in (:mle, :KSstatistic, :mleKS, :scanmle)
#     @eval begin
#         $(f)(cdf::AbstractEmpiricalCDF,args...) = $(f)(cdf.xdata,args...)
#     end
# end

function _inverse(cdf::EmpiricalCDF, x)
    ind = floor(Int, _total_counts(cdf)*x) + 1
    cdf.xdata[ind]
end

function _inverse(cdf::EmpiricalCDFHi, x)
    ind = floor(Int, _total_counts(cdf)*x) + 1 - _rejectcounts(cdf)
    cdf.xdata[ind]
end

Base.rand(cdf::EmpiricalCDF) = _inverse(cdf,rand())

"`getinverse(cdf::EmpiricalCDF,x)` return the value of the functional inverse of `cdf` at the point `x`."
function getinverse(cdf::EmpiricalCDF,x)
    (x < 0 || x >= 1) && throw(DomainError())
    _inverse(cdf,x)
end

function getinverse(cdf::EmpiricalCDFHi,x)
    (x < cdf.lowreject || x >= 1) && throw(DomainError())
    _inverse(cdf,x)
end


function Base.show(io::IO, cdf::EmpiricalCDF)
    print(io, string(typeof(cdf)))
    print(io, "(n=")
    print(io,length(cdf))
    print(io,')')
end

function Base.show(io::IO, cdf::EmpiricalCDFHi)
    print(io, string(typeof(cdf)))
    print(io, "(n=")
    print(io,length(cdf))
    print(io,",lowreject=")
    print(io,cdf.lowreject)
    print(io,')')
end

function Base.print(cdf::AbstractEmpiricalCDF,fn::String)
    io = open(fn,"w")
    print(io,cdf)
    close(io)
end

Base.print(io::IO, cdf::AbstractEmpiricalCDF) = logprint(io,cdf)

"`linprint(io::IO ,cdf::EmpiricalCDF, n=2000)` print (not more than) `n` linearly spaced points after sorting the data."
linprint(io::IO, cdf::AbstractEmpiricalCDF) = _printcdf(io,cdf,false, 2000)
linprint(io::IO, cdf::AbstractEmpiricalCDF, nprint_pts::Int) = _printcdf(io,cdf,false, nprint_pts)

"`logprint(io::IO, cdf::EmpiricalCDF, n=2000)` print (not more than) `n` log spaced points after sorting the data."
logprint(io::IO, cdf::AbstractEmpiricalCDF, nprint_pts::Int) = _printcdf(io,cdf,true, nprint_pts)
logprint(io::IO, cdf::AbstractEmpiricalCDF) = _printcdf(io,cdf,true, 2000)

Base.print(io::IO, cdf::AbstractEmpiricalCDF, nprint_pts::Int) = logprint(io,cdf,nprint_pts)

Base.print(io::IO, cdf::AbstractEmpiricalCDF, prpts::AbstractArray) = _printcdf(io,cdf,prpts)

function Base.print(cdf::AbstractEmpiricalCDF, prpts::AbstractArray, fname::String)
    io = open(fname,"w")
    print(io,cdf,prpts)
    close(io)
end

function linprint(fn::String, cdf::AbstractEmpiricalCDF)
    io = open(fn,"w")
    linprint(io,cdf)
    close(io)
end

function logprint(fn::String, cdf::AbstractEmpiricalCDF)
    io = open(fn,"w")
    logprint(io,cdf)
    close(io)
end

# print many fields, prpts is iterable
function _printfull(io, cdf::AbstractEmpiricalCDF, prpts)
    n = length(cdf)
    println(io, "# log10(t)  log10(P(t))  log10(1-P(t))  t  1-P(t)   P(t)")
    state = start(prpts)
    (p,state) = next(prpts,state)                
    for i in 1:n-1  # don't print ordinate value of 1
        xp = cdf.xdata[i]
        if done(prpts,state)
            break
        end
        if xp >= p
            (p,state) = next(prpts,state)            
            cdf_val = _val_at_index(cdf,i)
            @printf(io,"%e\t%e\t%e\t%e\t%e\t%e\n", log10(abs(xp)),  log10(abs(1-cdf_val)), log10(abs(cdf_val)), xp, cdf_val, 1-cdf_val)
        end
    end
end

function _printextraheader(io,cdf::AbstractEmpiricalCDF)
end
function _printextraheader(io,cdf::EmpiricalCDFHi)
    nreject = _rejectcounts(cdf)
    n = length(cdf)
    println(io, "# cdf: lowreject = ", cdf.lowreject)
    println(io, "# cdf: lowreject counts = ", nreject)
    @printf(io, "# cdf: fraction kept = %f\n", n/(n+nreject))
end

# Note that we sort in place
function _printcdf(io::IO, cdf::AbstractEmpiricalCDF, logprint::Bool, nprint_pts::Integer)
    if length(cdf) == 0
        error("Trying to print empty cdf")
    end    
    x = cdf.xdata
    sort!(x)    
    xmin = x[1]
    xmax = x[end]
    local prpts
    if logprint && xmin > 0
        println(io, "# cdf: log spacing of coordinate")
        prpts = logspace(log10(xmin),log10(xmax), nprint_pts)
    else
        println(io, "# cdf: linear spacing of coordinate")
        prpts = linspace(xmin,xmax, nprint_pts)
    end
    _printcdf(io, cdf, prpts)    
end

# FIXME We need to avoid resorting
function _printcdf(io::IO, cdf::AbstractEmpiricalCDF, prpts::AbstractArray)
    x = cdf.xdata
    sort!(x)
    n = length(x)
    if n == 0
        error("Trying to print empty cdf")
    end
    println(io, "# cdf of survival times")
    println(io, "# cdf: total     counts = ", _total_counts(cdf))
    _printextraheader(io,cdf)
    println(io, "# cdf: number of points in cdf: $n")
    _printfull(io,cdf,prpts)
end
