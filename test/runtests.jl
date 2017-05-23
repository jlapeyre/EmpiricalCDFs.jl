using EmpiricalCDFs
using Base.Test

@test (cdf = EmpiricalCDF(); true)
@test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; true)
@test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; sort!(cdf); typeof(cdf(0)) == Float64)
@test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; sort!(cdf); typeof(rand(cdf)) == Float64)
@test (cdf = EmpiricalCDF(.5); append!(cdf,rand(10^3)) ; sort!(cdf); typeof(cdf(1)) == Float64)

a = rand(10^5);            # points in [0,1)
cdf0 = EmpiricalCDF();     # accept all points
cdf1 = EmpiricalCDF(0.5);  # reject points < 0.5

append!(cdf0,a);
append!(cdf1,a);

@test maximum(cdf0) == maximum(cdf1)
@test minimum(cdf0) != minimum(cdf1)
@test minimum(cdf1) >= 0.5

sort!(cdf0)
sort!(cdf1)

@test cdf0(.4) != cdf1(.4)
@test cdf0(.6) == cdf1(.6)

@test getinverse(cdf0,1-eps(1.0)) == maximum(cdf0)   # last point is as close to 1 as possible
@test getinverse(cdf1,1-eps(1.0)) == maximum(cdf1)

indir = joinpath(Pkg.dir("EmpiricalCDFs"), "test")
infile = joinpath(indir, "paretocdf.bin")

paretocdf = readcdf(infile)
@test length(paretocdf) == 10^5

# mleks = EmpiricalCDFs.mleKS(paretocdf)
# @test_approx_eq mleks.alpha 1.996866804338394
# @test_approx_eq mleks.stderr 0.0031523696255227455
# mlescan = EmpiricalCDFs.scanmle(paretocdf,15)
# @test_approx_eq mlescan.alpha 1.9967583503268964

@test length(paretocdf.([.4,.5,.6])) == 3

@test (linprint(DevNull,paretocdf) ; true)
@test (logprint(DevNull,paretocdf); true)
@test typeof(rand(paretocdf)) <: AbstractFloat

@test (push!(paretocdf, .5) ; true)
@test (show(DevNull, paretocdf); true)
