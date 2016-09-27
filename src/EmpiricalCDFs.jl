module EmpiricalCDFs

export EmpiricalCDF

doc"""
EmpiricalCDF()

Return an empirical CDF.
"""

immutable EmpiricalCDF{T <: Real}
    xdata::Array{T,1}  # death times
    nprint_pts::Int
    logprint::Bool
end

EmpiricalCDF(nprint_pts::Int) = EmpiricalCDF(Array(Float64,0), nprint_pts, true)
EmpiricalCDF() = EmpiricalCDF(2000,true)
EmpiricalCDF(logprint::Bool) = EmpiricalCDF(2000,logprint)

EmpiricalCDF(nprint_pts::Int, logprint::Bool) = EmpiricalCDF(Array(Float64,0), nprint_pts, logprint)

Base.push!(cdf::EmpiricalCDF, time) = push!(cdf.xdata,time)

Base.append!(cdf::EmpiricalCDF, times) = append!(cdf.xdata,times)

Base.sort!(cdf::EmpiricalCDF) = sort!(cdf.data)

function Base.print(cdf::EmpiricalCDF,fn::String)
    ostr = open(fn,"w")
    print(ostr,cdf)
    close(ostr)
end

# Note that we sort in place
function Base.print(ostr::IOStream, cdf::EmpiricalCDF)
    x = cdf.xdata
    sort!(x)
    n = length(x)
    xmin = x[1]
    xmax = x[end]
    local prpts
    println(ostr, "# cdf of survival times")
    if cdf.logprint
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
