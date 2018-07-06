using EmpiricalCDFs

struct Pareto
    alpha::Float64
    x0::Float64
end

Pareto(alpha) = Pareto(alpha,1.0)
Pareto() = Pareto(1.0)

Base.rand(p::Pareto) = p.x0 * rand()^(-one(p.alpha)/p.alpha)

function Base.rand(p::Pareto, n::Int)
    a = Array(Float64, n)
    for i in 1:n
        a[i] = rand(p)
    end
    a
end

const odir = joinpath(Pkg.dir("EmpiricalCDFs"), "test")
const ofile = joinpath(odir, "paretocdf.bin")

function write_test_data()
    d = Pareto()
    cdf = EmpiricalCDF()
    append!(cdf, rand(d,10^5))
    sort!(cdf)
    write(ofile, cdf)
    nothing
end

import EmpiricalCDFs: mleKS, scanmle

# julia> read_test_data()
# EmpiricalCDFs.MLEKS{Float64}(2.0018144538762677,0.0010018144538762677,0.2488588894720618)

function read_test_data()
    cdf = readcdf(ofile)
    mleks = mleKS(cdf)
    println(mleks)
    scanmle(cdf,15)
end
