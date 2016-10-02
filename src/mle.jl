using Distributions

# MLE formula from https://en.wikipedia.org/wiki/Power_law
function mle(data,xmin)
    acc = zero(xmin)
    for x in data
        acc += log(x/xmin)
    end
    return 1 + length(data)/acc
end

function testmle(nend)
    d = Pareto(.5)
    data = rand(d,10^7)
    sort!(data)
    mle(data[end-nend:end], data[end-nend])
end
