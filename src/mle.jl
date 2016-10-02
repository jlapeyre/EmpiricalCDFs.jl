"""
    (estimate, stderr) = mle(data::AbstractVector)

Return the maximum likelihood estimate and standard error of the exponent of a power law
applied to the sorted vector `data`.
"""
function mle{T<:AbstractFloat}(data::AbstractVector{T})
    xmin = data[1]
    acc = zero(xmin)
    xlast = Inf
    ncount = 0
    for x in data
        if xlast == x
            continue
        end
        xlast = x
        ncount += 1
        acc += log(x/xmin)
    end
    ahat = 1 + ncount/acc
    stderr = (ahat-1)/sqrt(ncount)
    (ahat,stderr)
end

"""
    KSstatistic(data::AbstractVector, alpha)

Return the Kolmogorv-Smirnov statistic
comparing `data` to a power law with power `alpha`. The elements of `data` are
assumed to be unique.
"""
function KSstatistic{T<:AbstractFloat}(data::AbstractVector{T}, alpha)
    n = length(data)
    xmin = data[1]
    maxdistance = zero(xmin)
    for i in 0:n-1
        pl = 1 - (xmin/data[i+1])^alpha
        distance = abs(pl - i/n)
        if distance > maxdistance maxdistance = distance end
    end
    maxdistance
end

"""
    MLEKS{T <: AbstractFloat}

Container for storing results of MLE estimate and 
Kolmogorv-Smirnov statistic of the exponent of a power law.
"""
immutable MLEKS{T <: AbstractFloat}
    alpha::T
    stderr::T
    KS::T    
end

"""
    mleKS{T<:AbstractFloat}(data::AbstractVector{T})

Return the maximum likelihood estimate and standard error of the exponent of a power law
applied to the sorted vector `data`. Also return the Kolmogorv-Smirnov statistic. Results
are returned in an instance of type `MLEKS`.
"""
function mleKS{T<:AbstractFloat}(data::AbstractVector{T})
    (alpha,stderr) = mle(data)
    KSstat = KSstatistic(data, alpha)
    MLEKS(alpha,stderr,KSstat)
end

"""
    MLEScan{T <: AbstractFloat}

Record best estimate of alpha and associated parameters.
"""
type MLEScan{T <: AbstractFloat}
    alpha::T
    stderr::T
    minKS::T    
    xmin::T
    imin::Int
    npts::Int
    ntrials::Int
end

function MLEScan(T)
    z = zero(T)
    inf = convert(T,Inf)
    MLEScan(z,z,inf,z,0,0,0)
end

"""
    comparescan(mle::MLEKS, i, data, mlescan::MLEScan)

compare the results of MLE estimation `mle` to record results
in `mlescan` and update `mlescan`.
"""
function comparescan(data, mle::MLEKS, i, mlescan::MLEScan)
    if mle.KS < mlescan.minKS
        mlescan.minKS = mle.KS
        mlescan.alpha = mle.alpha
        mlescan.stderr = mle.stderr
        mlescan.imin = i
        mlescan.npts = length(data)
        mlescan.xmin = data[1]
    end
    mlescan.ntrials += 1    
end

"""
    scanmle(data::AbstractVector, ntrials=100, stderrcutoff=0.1)

Perform `mle` approximately `ntrials` times on `data`, increasing `xmin`. Stop trials
if the `stderr` of the estimate `alpha` is greater than `stderrcutoff`.
"""
function scanmle{T<:AbstractFloat}(data::AbstractVector{T}, ntrials, stderrcutoff)
    skip = convert(Int,round(length(data)/ntrials))
    if skip < 1
        skip = 1
    end
    _scanmle(data, 1:skip:length(data), stderrcutoff)
end

scanmle{T<:AbstractFloat}(data::AbstractVector{T}, ntrials) = scanmle(data,ntrials, 0.1)
scanmle{T<:AbstractFloat}(data::AbstractVector{T}) = scanmle(data,100)

"""
    _scanmle{T<:AbstractFloat, V <: Integer}(data::AbstractVector{T}, range::AbstractVector{V},stderrcutoff)

Inner function for scanning power-law mle for power `alpha` over `xmin`. `range` specifies which `xmin` to try.
`stderrcutoff` specifies a standard error in `alpha` at which we stop trials. `range` should be increasing.
"""
function _scanmle{T<:AbstractFloat, V <: Integer}(data::AbstractVector{T}, range::AbstractVector{V},
                                    stderrcutoff)
    mlescan = MLEScan(T)
    for i in range
        ndata = data[i:end]
        mleks = mleKS(ndata)
        mleks.stderr > stderrcutoff && break
        comparescan(data, mleks, i, mlescan)
    end
    mlescan
end

#  LocalWords:  Kolmogorv Smirnov
