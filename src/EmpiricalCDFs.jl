module EmpiricalCDFs

export EmpiricalCDF

doc"""
*EmpiricalCDF()*

Return an empirical CDF.

`EmpiricalCDF(n)`, `EmpiricalCDF(n,true)`,

`print(ostr,cdf)` will print (not more than) `n` log spaced points after sorting the data.

`EmpiricalCDF(n,false)` will print linearly spaced points, when printed.

`push!(cdf,x)`  add a point to `cdf`

`append!(cdf,a)`  add points to `cdf`.
"""

immutable EmpiricalCDF{T <: Real}
    nprint_pts::Int
    lowreject::T  # reject counts smaller than this
    rejectcounts::Array{Int,1}
    xdata::Array{T,1}  # death times    
end



function EmpiricalCDF(nprint_pts::Int, lowreject::Real)
    cdf = EmpiricalCDF(nprint_pts, lowreject, Array(Int,1), Array(Float64,0))
    cdf.rejectcounts[0] = 0
    cdf
end

EmpiricalCDF(nprint_pts::Int) = EmpiricalCDF(nprint_pts, -Inf)

EmpiricalCDF() = EmpiricalCDF(2000)

increment_rejectcounts(cdf::EmpiricalCDF) = cdf.rejectcounts[0] += 1

reject_counts(cdf::EmpiricalCDF) = cdf.rejectcounts[0]

function Base.push!(cdf::EmpiricalCDF, x)
    if ! isinf(cdf.lowreject)
        if  x >= cdf.lowreject
            push!(cdf.xdata,x)
        end
    end
end

function Base.append!(cdf::EmpiricalCDF, times)
    if  isinf(cdf.lowreject)    
        append!(cdf.xdata,times)
    else
        for x in times
            if x >= cdf.lowreject
                push!(cdf,x)
            end
        end
    end
end

Base.sort!(cdf::EmpiricalCDF) = sort!(cdf.data)

function Base.print(cdf::EmpiricalCDF,fn::String)
    ostr = open(fn,"w")
    print(ostr,cdf)
    close(ostr)
end

Base.print(ostr::IOStream, cdf::EmpiricalCDF) = logprint(ostr,cdf)
logprint(ostr::IOStream, cdf::EmpiricalCDF) = printcdf(ostr,cdf,true)
linprint(ostr::IOStream, cdf::EmpiricalCDF) = printcdf(ostr,cdf,false)

# Note that we sort in place
function printcdf(ostr::IOStream, cdf::EmpiricalCDF, logprint::Bool)
    x = cdf.xdata
    sort!(x)
    n = length(x)
    xmin = x[1]
    xmax = x[end]
    local prpts
    println(ostr, "# cdf of survival times")
    println(ostr, "# lowreject = ", cdf.lowreject)
    println(ostr, "# lowreject counts = ", rejectcounts(cdf))
    if logprint
        println(ostr, "# cdf: log spacing of coordinate")
        prpts = logspace(log10(xmin),log10(xmax), cdf.nprint_pts)        
    else
        println(ostr, "# cdf: linear spacing of coordinate")
        prpts = linspace(xmin,xmax, cdf.nprint_pts)            
    end
    println(ostr, "# cdf: number of points in cdf: $n")    
    println(ostr, "# log10(t)  log10(P(t))  log10(1-P(t))  t  1-P(t)   P(t)")
    j = 1
    for i in 1:n-1  # don't print ordinate value of 1
        xp = x[i]
        if xp >= prpts[j]
            j += 1
            cdf_val = i/n
            @printf(ostr,"%e\t%e\t%e\t%e\t%e\t%e\n", log10(xp),  log10(1-cdf_val), log10(cdf_val), xp, cdf_val, 1-cdf_val)
        end
    end
end

end # module
