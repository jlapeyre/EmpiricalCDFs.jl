module EmpiricalCDFs

## TODO FIXME: Most routines do not work with `lowreject`. Only printing works.

export EmpiricalCDF, linprint, logprint, getinverse

doc"""
*EmpiricalCDF()*

Return an empirical CDF. The CDF must be sorted after inserting elements with `push!` or
`append!`, and before being accessed using any of the functions below.

`EmpiricalCDF(xmin)`

When using `push!(cdf,x)` and `append!(cdf,a)`, points `x` for `x<xmin` will be rejected.
The CDF will be properly normalized, but will be lower-truncated.
This can be useful when generating too many points to store.

`print(ostr,cdf)` or `logprint(ostr,cdf,n=2000)` print (not more than) `n` log spaced points after sorting the data.

`linprint(ostr,cdf,n=2000)` print (not more than) `n` linearly spaced points after sorting the data.

`push!(cdf,x)`  add a point to `cdf`

`append!(cdf,a)`  add points to `cdf`.

`sort!(cdf)` The data must be sorted before calling `cdf[x]`

`cdf[x::Real]`  return the value of `cdf` at the point `x`.

`cdf[a::Array]` return the values of `cdf` at the points in `a`.

`length(cdf)`  return the number of data points in `cdf`.

`rand(cdf)`  return a sample from the probability distribution associated with `cdf`.

`getinverse(cdf::EmpiricalCDF,x)` return the value of the functional inverse of `cdf` at the point `x`.
"""

immutable EmpiricalCDF{T <: Real}
    lowreject::T  # reject counts smaller than this
    rejectcounts::Array{Int,1}  # how many rejections have we done
    xdata::Array{T,1}  # death times
end

function EmpiricalCDF(lowreject::Real)
    cdf = EmpiricalCDF(lowreject, Array(Int,1), Array(Float64,0))
    cdf.rejectcounts[1] = 0
    cdf
end

EmpiricalCDF() = EmpiricalCDF(-Inf)

# Number of points accepted plus number of points rejected
_total_counts(cdf::EmpiricalCDF) = length(cdf.xdata) + _rejectcounts(cdf)

# Value of the cdf corresponding to index i
_val_at_index(cdf::EmpiricalCDF, i) =  (i+ _rejectcounts(cdf) )/_total_counts(cdf)

_increment_rejectcounts(cdf::EmpiricalCDF) = cdf.rejectcounts[1] += 1

_rejectcounts(cdf::EmpiricalCDF) = cdf.rejectcounts[1]

function _maybepush!(cdf::EmpiricalCDF,x)
    if  x >= cdf.lowreject
        push!(cdf.xdata,x)
    else
        _increment_rejectcounts(cdf)
    end
end

function Base.push!(cdf::EmpiricalCDF, x)
    if isinf(cdf.lowreject)
        push!(cdf.xdata,x)
    else
        _maybepush!(cdf,x)
    end
end

function Base.append!(cdf::EmpiricalCDF, times)
    if  isinf(cdf.lowreject)
        append!(cdf.xdata,times)
    else
        for x in times
            _maybepush!(cdf,x)
        end
    end
end

for f in ( :length, :sort!, :minimum, :maximum, :mean, :std, :quantile )
    @eval begin
        Base.$(f)(cdf::EmpiricalCDF,args...) = $(f)(cdf.xdata,args...)
    end
end

function _inverse(cdf::EmpiricalCDF, x)
    x < cdf.lowreject && throw(DomainError())
    ind = floor(Int, _total_counts(cdf)*x) + 1 - _rejectcounts(cdf)
    cdf.xdata[ind]
end

Base.rand(cdf::EmpiricalCDF) = _inverse(cdf,rand())

"`getinverse(cdf::EmpiricalCDF,x)` return the value of the functional inverse of `cdf` at the point `x`."
function getinverse(cdf::EmpiricalCDF,x)
    (x < 0 || x >= 1) && throw(DomainError())
    _inverse(cdf,x)
end

#Base.getindex(cdf::EmpiricalCDF, x::Real) = searchsortedlast(cdf.xdata, x) / length(cdf.xdata)
Base.getindex(cdf::EmpiricalCDF, x::Real) = _val_at_index(cdf, searchsortedlast(cdf.xdata, x))

# With several tests, this is about the same speed or faster than the routine borrowed from StatsBase
function Base.getindex{T <: Real}(cdf::EmpiricalCDF, v::Array{T})in
    r = Array(eltype(cdf.xdata), size(v)...)
    for (i,x) in enumerate(v)
        r[i] = cdf[x]
    end
    r
end

function Base.show(io::IO, cdf::EmpiricalCDF)
    print(io, string(typeof(cdf)))
    print(io, "(n=")
    print(io,length(cdf))
    print(io,')')
end

function Base.print(cdf::EmpiricalCDF,fn::String)
    ostr = open(fn,"w")
    print(ostr,cdf)
    close(ostr)
end


"`linprint(ostr::IO ,cdf::EmpiricalCDF, n=2000)` print (not more than) `n` linearly spaced points after sorting the data."
linprint(ostr::IOStream, cdf::EmpiricalCDF) = _printcdf(ostr,cdf,false, 2000)
linprint(ostr::IOStream, cdf::EmpiricalCDF, nprint_pts) = _printcdf(ostr,cdf,false, nprint_pts)

Base.print(ostr::IOStream, cdf::EmpiricalCDF) = logprint(ostr,cdf)
logprint(ostr::IOStream, cdf::EmpiricalCDF) = _printcdf(ostr,cdf,true, 2000)

"`logprint(ostr::IO, cdf::EmpiricalCDF, n=2000)` print (not more than) `n` log spaced points after sorting the data."
logprint(ostr::IOStream, cdf::EmpiricalCDF, nprint_pts) = _printcdf(ostr,cdf,true, nprint_pts)

# Note that we sort in place
function _printcdf(ostr::IOStream, cdf::EmpiricalCDF, logprint::Bool, nprint_pts)
    x = cdf.xdata
    sort!(x)
    n = length(x)
    if n == 0
        error("Trying to print empty cdf")
    end
    xmin = x[1]
    xmax = x[end]
    local prpts
    nreject = _rejectcounts(cdf)
    println(ostr, "# cdf of survival times")
    println(ostr, "# cdf: lowreject = ", cdf.lowreject)
    println(ostr, "# cdf: lowreject counts = ", nreject)
    println(ostr, "# cdf: total     counts = ", n + nreject)
    @printf(ostr, "# cdf: fraction kept = %f\n", n/(n+nreject))
    if logprint
        println(ostr, "# cdf: log spacing of coordinate")
        prpts = logspace(log10(xmin),log10(xmax), nprint_pts)
    else
        println(ostr, "# cdf: linear spacing of coordinate")
        prpts = linspace(xmin,xmax, nprint_pts)
    end
    println(ostr, "# cdf: number of points in cdf: $n")
    println(ostr, "# log10(t)  log10(P(t))  log10(1-P(t))  t  1-P(t)   P(t)")
    j = 1
    ntotal = n + nreject
    for i in 1:n-1  # don't print ordinate value of 1
        xp = x[i]
        if xp >= prpts[j]
            j += 1
            _val_at_index(cdf,i)
#            cdf_val = (i+nreject)/ntotal
            @printf(ostr,"%e\t%e\t%e\t%e\t%e\t%e\n", log10(xp),  log10(1-cdf_val), log10(cdf_val), xp, cdf_val, 1-cdf_val)
        end
    end
end

end # module
