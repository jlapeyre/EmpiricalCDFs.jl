using EmpiricalCDFs

# Create an empirical cdf with 10^6 normally distributed samples
cdf = EmpiricalCDF(randn(10^6))

# add another sample
push!(cdf, randn())

# add 10^6 more samples
append!(cdf, randn(10^6))

# sort the cdf before using it
sort!(cdf)

# Pick a random sample from the distribution approximated by `cdf`
rand(cdf)

# The normal distribution is symmetric, so this should be about 0.5
cdf(0)

# This should be approximately zero
getinverse(cdf,.5)

