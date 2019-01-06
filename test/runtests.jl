using EmpiricalCDFs

using EmpiricalCDFs.IOcdf: readcdf, getcdf

using Test
using Statistics

@testset "construction" begin
    @test (cdf = EmpiricalCDF(); true)
    @test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; true)
    @test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; sort!(cdf); cdf(0) isa Float64)
    @test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; sort!(cdf); typeof(rand(cdf)) == Float64)
    @test (cdf = EmpiricalCDF(.5); append!(cdf,rand(10^3)) ; sort!(cdf); typeof(cdf(1)) == Float64)
end

@testset "cutoff" begin
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

    @test finv(cdf0)(1-eps(1.0)) == maximum(cdf0)   # last point is as close to 1 as possible
    @test finv(cdf1)(1-eps(1.0)) == maximum(cdf1)
end

@testset "read binary file" begin
    infile = joinpath(@__DIR__, "paretocdf.bin")
    paretocdf = readcdf(infile)
    @test length(paretocdf) == 10^5
    @test length(paretocdf.([.4,.5,.6])) == 3
    @test getcdf(paretocdf).([.4,.5,.6]) == getcdf(paretocdf)([.4,.5,.6])
    @test paretocdf.([.4,.5,.6]) == paretocdf([.4,.5,.6])
    @test (linprint(devnull, paretocdf) ; true)
    @test (logprint(devnull, paretocdf); true)
    @test rand(paretocdf) isa AbstractFloat
    @test (push!(paretocdf, .5) ; true)
    @test (show(devnull, paretocdf); true)
    p = getcdf(paretocdf)
    @test data(p) == p.xdata
    @test counts(p) == length(p)  # NOTE: counts and length are not always the same, but are in this case.
end

@testset "Inf cutoff" begin
    c = EmpiricalCDF(Inf)
    c2 = EmpiricalCDF(Inf)
    @test typeof(c) == typeof(c2)
    @test length(c) == length(c2)
    c = EmpiricalCDFHi(Inf)
    @test (push!(c,.5);true)
    @test (append!(c,[1.,1e10]);true)
end

@testset "statistics" begin
    n = 10^5
    cdf = EmpiricalCDF(randn(n))
    @test length(cdf) == n
    # named parameters
    @test std(cdf; mean=mean(cdf)) == std(cdf)
    empty!(cdf)
    @test length(cdf) == 0
end
