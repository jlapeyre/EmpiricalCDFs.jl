using EmpiricalCDFs
using Base.Test

@test (cdf = EmpiricalCDF(); true)
@test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; true)
@test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; sort!(cdf); typeof(cdf[0]) == Float64)
@test (cdf = EmpiricalCDF(); append!(cdf,rand(10^3)) ; sort!(cdf); typeof(rand(cdf)) == Float64)

